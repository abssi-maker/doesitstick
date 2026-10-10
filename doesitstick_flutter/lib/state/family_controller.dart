import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../client.dart';

enum SyncState { live, connecting, offline }

/// What the parent sees under a marked question, in plain words.
enum MarkSync { savedOnPhone, sending, shared }

class EffectiveMark {
  final Outcome outcome;
  final String by;
  final MarkSync sync;
  const EffectiveMark(this.outcome, this.by, this.sync);
}

/// Holds the family's state, the live connection and the offline outbox.
/// The server is the source of truth: after any event or reconnect we
/// refetch [home], so a missed stream message never loses data.
class FamilyController extends ChangeNotifier {
  FamilyController({SharedPreferences? prefs})
    : _prefs = prefs; // ignore: prefer_initializing_formals

  static const _outboxKey = 'dis.outbox.v1';
  static const _homeKey = 'dis.home.v1';

  SharedPreferences? _prefs;
  HomeState? home;
  List<ConceptOption> concepts = const [];
  SyncState sync = SyncState.connecting;
  bool demoOffline = false;
  bool busy = false;
  final List<MarkInput> outbox = [];
  final Set<String> _inFlight = {};
  StreamSubscription<FamilyEvent>? _sub;
  Timer? _retry;
  int _backoffSeconds = 1;
  bool _disposed = false;

  final _events = StreamController<FamilyEvent>.broadcast();

  /// Events from the other parent (or the server), for toasts.
  Stream<FamilyEvent> get events => _events.stream;

  String get me => home?.family.me ?? '';
  String? get partner => home?.family.parents.where((p) => p != me).firstOrNull;

  Future<void> start() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadLocal();
    notifyListeners();
    try {
      concepts = await client.family.concepts();
    } catch (_) {}
    await refresh();
    _connect();
  }

  void _loadLocal() {
    final p = _prefs!;
    final raw = p.getString(_outboxKey);
    if (raw != null) {
      outbox
        ..clear()
        ..addAll(
          (jsonDecode(raw) as List).map(
            (j) => MarkInput.fromJson(j as Map<String, dynamic>),
          ),
        );
    }
    final cached = p.getString(_homeKey);
    if (cached != null && home == null) {
      try {
        home = HomeState.fromJson(jsonDecode(cached) as Map<String, dynamic>);
      } catch (_) {}
    }
  }

  Future<void> _saveOutbox() async {
    await _prefs?.setString(
      _outboxKey,
      jsonEncode(outbox.map((m) => m.toJson()).toList()),
    );
  }

  Future<void> refresh() async {
    if (demoOffline) return;
    try {
      final h = await client.family.home();
      home = h;
      await _prefs?.setString(_homeKey, jsonEncode(h.toJson()));
      _notify();
    } catch (_) {
      // Keep showing the cached state; the stream retry will refetch.
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _connect() {
    if (demoOffline || _disposed) return;
    _retry?.cancel();
    _sub?.cancel();
    sync = SyncState.connecting;
    _notify();
    _sub = client.family.updates().listen(
      (e) {
        if (e.kind == 'hello') {
          sync = SyncState.live;
          _backoffSeconds = 1;
          _notify();
          refresh();
          flush();
          return;
        }
        if (e.actorName != me) _events.add(e);
        refresh();
      },
      onError: (_) => _lost(),
      onDone: _lost,
      cancelOnError: true,
    );
  }

  void _lost() {
    if (demoOffline || _disposed) return;
    sync = SyncState.offline;
    _notify();
    _retry?.cancel();
    _retry = Timer(Duration(seconds: _backoffSeconds), _connect);
    _backoffSeconds = min(_backoffSeconds * 2, 30);
  }

  /// Demo switch so judges can watch offline queueing on one laptop.
  void setDemoOffline(bool offline) {
    demoOffline = offline;
    if (offline) {
      _retry?.cancel();
      _sub?.cancel();
      _sub = null;
      sync = SyncState.offline;
      _notify();
    } else {
      _connect();
    }
  }

  static String _newId() {
    final r = Random.secure();
    return '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-'
        '${List.generate(10, (_) => r.nextInt(36).toRadixString(36)).join()}';
  }

  /// Saves the mark on this phone first, then sends it when possible.
  Future<void> mark(Question q, Outcome outcome) async {
    outbox.removeWhere(
      (m) => m.questionId == q.id && !_inFlight.contains(m.clientMarkId),
    );
    outbox.add(
      MarkInput(
        clientMarkId: _newId(),
        questionId: q.id!,
        outcome: outcome,
        markedAt: DateTime.now().toUtc(),
      ),
    );
    await _saveOutbox();
    _notify();
    await flush();
  }

  Future<void> flush() async {
    if (demoOffline || outbox.isEmpty || _inFlight.isNotEmpty) return;
    final batch = List<MarkInput>.of(outbox);
    _inFlight.addAll(batch.map((m) => m.clientMarkId));
    _notify();
    try {
      final accepted = (await client.card.syncMarks(batch)).toSet();
      // Marks the server refused (e.g. a deleted card) are dropped too, so a
      // bad entry can't block the queue forever.
      final sent = batch.map((m) => m.clientMarkId).toSet();
      outbox.removeWhere((m) => sent.contains(m.clientMarkId));
      await _saveOutbox();
      if (accepted.length < sent.length) {
        debugPrint('Server skipped ${sent.length - accepted.length} marks');
      }
      await refresh();
    } catch (_) {
      // Still offline; the marks stay queued.
    } finally {
      _inFlight.clear();
      _notify();
    }
    if (outbox.isNotEmpty && !demoOffline && sync == SyncState.live) {
      unawaited(flush());
    }
  }

  EffectiveMark? effectiveMark(QuestionView qv) {
    final local = outbox
        .where((m) => m.questionId == qv.question.id)
        .lastOrNull;
    if (local != null) {
      return EffectiveMark(
        local.outcome,
        me,
        _inFlight.contains(local.clientMarkId)
            ? MarkSync.sending
            : MarkSync.savedOnPhone,
      );
    }
    final latest = qv.latest;
    if (latest == null) return null;
    return EffectiveMark(latest.outcome, latest.parentName, MarkSync.shared);
  }

  CardView? cardById(int id) =>
      home?.cards.where((c) => c.card.id == id).firstOrNull;

  CardView? get tonightCard =>
      home?.cards.where((c) => c.card.kind == CardKind.tonight).firstOrNull;

  List<CardView> get openRechecks => (home?.cards ?? const <CardView>[])
      .where(
        (c) =>
            c.card.kind == CardKind.recheck &&
            c.questions.any((q) => effectiveMark(q) == null),
      )
      .toList();

  Worksheet? get activeWorksheet => home?.worksheets
      .where(
        (w) =>
            w.status == WorksheetStatus.uploaded ||
            w.status == WorksheetStatus.reading ||
            w.status == WorksheetStatus.needsTopic,
      )
      .firstOrNull;

  Future<T> _busy<T>(Future<T> Function() f) async {
    busy = true;
    _notify();
    try {
      return await f();
    } finally {
      busy = false;
      _notify();
    }
  }

  /// Photo → private storage → background reader. Returns false if the
  /// parent cancelled the picker.
  /// Snapped photos, kept in memory on this phone only so the parent can see
  /// what was read. The server deletes its copy right after reading.
  final _photos = <int, Uint8List>{};
  Uint8List? photoFor(int? worksheetId) =>
      worksheetId == null ? null : _photos[worksheetId];

  Future<bool> snapWorksheet(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 72,
    );
    if (picked == null) return false;
    await _busy(() async {
      final bytes = await picked.readAsBytes();
      final ticket = await client.worksheet.startPhoto();
      _photos[ticket.worksheetId] = bytes;
      final ok = await FileUploader(
        ticket.uploadDescription,
      ).uploadByteData(ByteData.sublistView(bytes));
      if (!ok) throw Exception('upload failed');
      await client.worksheet.submitPhoto(ticket.worksheetId);
      await refresh();
    });
    return true;
  }

  Future<void> chooseTopic(ConceptId concept, {int? worksheetId}) =>
      _busy(() async {
        await client.worksheet.chooseTopic(worksheetId, concept);
        await refresh();
      });

  Future<int> jumpAhead(int days) => _busy(() async {
    final made = await client.progress.jumpAhead(days);
    await refresh();
    return made;
  });

  @override
  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _sub?.cancel();
    _events.close();
    super.dispose();
  }
}
