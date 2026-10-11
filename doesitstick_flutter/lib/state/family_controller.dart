import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:image_picker/image_picker.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../client.dart';
import 'offline_marks.dart';

enum SyncState { live, connecting, offline }

/// What the parent sees under a marked question, in plain words.
enum MarkSync { savedOnPhone, sending, shared }

/// Where the other parent is, from their phone's presence pings.
class PartnerPresence {
  final String name;
  final int? cardId;
  final int? step;
  final String detail;
  final DateTime seen;
  const PartnerPresence(
    this.name,
    this.cardId,
    this.step,
    this.detail,
    this.seen,
  );

  /// Sitting with the child on a problem right now.
  bool get atTable =>
      cardId != null && (detail == 'working' || detail == 'hint');
}

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

  /// Serverpod offline sync for marks; null until open, or where it can't
  /// run (then marks go through [outbox]).
  OfflineMarks? _offline;
  bool _openingOffline = false;

  /// Whether marks sync with Serverpod offline sync on this device.
  bool get usesOfflineSync => _offline != null;
  Timer? _retry;
  int _backoffSeconds = 1;
  bool _disposed = false;

  final _events = StreamController<FamilyEvent>.broadcast();

  /// Events from the other parent (or the server), for toasts.
  Stream<FamilyEvent> get events => _events.stream;

  final _cheers = StreamController<FamilyEvent>.broadcast();

  /// Cheers from the other parent, shown big at the table.
  Stream<FamilyEvent> get cheers => _cheers.stream;

  PartnerPresence? _partner;
  ({int? cardId, int? step, String detail}) _here = (
    cardId: null,
    step: null,
    detail: 'around',
  );
  Timer? _heartbeat;
  AppLifecycleListener? _lifecycle;
  bool _visible = true;

  /// The other parent, while their app is open (heard from recently).
  PartnerPresence? get partnerHere {
    final p = _partner;
    if (p == null || p.detail == 'gone' || sync != SyncState.live) return null;
    if (DateTime.now().difference(p.seen) > const Duration(seconds: 75)) {
      return null;
    }
    return p;
  }

  /// Where this parent is, for the other parent's phone. Repeated every
  /// 30 seconds while the app is open; only streamed, never stored.
  void setPresence({int? cardId, int? step, required String detail}) {
    final next = (cardId: cardId, step: step, detail: detail);
    if (next == _here) return;
    _here = next;
    _sendPresence();
  }

  void _sendPresence({bool gone = false, bool greet = false}) {
    if (demoOffline || sync != SyncState.live || home == null) return;
    final h = _here;
    unawaited(
      client.family
          .presence(h.cardId, h.step, gone ? 'gone' : h.detail, greet: greet)
          .catchError((_) {}),
    );
  }

  Future<void> sendCheer(Cheer cheer) => client.family.cheer(cheer);

  String get me => home?.family.me ?? '';
  String? get partner => home?.family.parents.where((p) => p != me).firstOrNull;

  Future<void> start() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadLocal();
    notifyListeners();
    // Offline at launch: marks still save, from the cached family.
    _openOffline();
    _heartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_visible) _sendPresence();
      _notify(); // lets a quiet partner's presence expire
    });
    _lifecycle = AppLifecycleListener(
      onHide: () {
        _visible = false;
        _sendPresence(gone: true);
      },
      onShow: () {
        _visible = true;
        _sendPresence();
      },
    );
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
      _openOffline();
    } catch (_) {
      // Keep showing the cached state; the stream retry will refetch.
    }
  }

  void _openOffline() {
    final space = home?.family.syncSpace;
    final user = client.auth.authInfo?.authUserId;
    if (_offline != null || _openingOffline || space == null || user == null) {
      return;
    }
    _openingOffline = true;
    OfflineMarks.open(
      user: user,
      space: space,
      onChange: _notify,
      onSynced: _refreshSoon,
    ).then((m) {
      _openingOffline = false;
      if (_disposed) {
        unawaited(m?.close());
        return;
      }
      _offline = m;
      if (!demoOffline) m?.resume();
      _notify();
    });
  }

  Timer? _refreshTimer;

  /// One refetch for a burst of sync rounds.
  void _refreshSoon() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer(const Duration(milliseconds: 300), refresh);
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
          _sendPresence(greet: true);
          return;
        }
        if (e.kind == 'presence' || e.kind == 'cheer') {
          if (e.actorName == me) return;
          if (e.kind == 'cheer') {
            _cheers.add(e);
            return;
          }
          // A partner who just connected hears back at once, so both
          // phones know where the other is without waiting for a ping.
          final arrived = partnerHere == null || e.message == 'hi';
          _partner = PartnerPresence(
            e.actorName ?? '',
            e.cardId,
            e.step,
            e.detail ?? 'around',
            DateTime.now(),
          );
          if (arrived) _sendPresence();
          _notify();
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
      unawaited(_offline?.pause());
      _retry?.cancel();
      _sub?.cancel();
      _sub = null;
      sync = SyncState.offline;
      _notify();
    } else {
      _offline?.resume();
      _connect();
    }
  }

  static String _newId() {
    final r = Random.secure();
    return '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-'
        '${List.generate(10, (_) => r.nextInt(36).toRadixString(36)).join()}';
  }

  /// Saves the mark on this phone first, then sends it when possible: with
  /// offline sync when it runs here, otherwise through the outbox.
  Future<void> mark(Question q, Outcome outcome) async {
    final offline = _offline;
    if (offline != null && await offline.write(q, outcome, me)) {
      _notify();
      return;
    }
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
    final synced = _offline?.byQuestion[qv.question.id]?.lastOrNull;
    if (synced != null &&
        (latest == null || !synced.markedAt.isBefore(latest.markedAt))) {
      final onServer = qv.marks.any((m) => m.id == synced.id);
      return EffectiveMark(
        synced.outcome,
        synced.parentName,
        onServer
            ? MarkSync.shared
            : (_offline!.connected && sync == SyncState.live
                  ? MarkSync.sending
                  : MarkSync.savedOnPhone),
      );
    }
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
  /// Worksheet photos, cached in memory. The server keeps them privately for
  /// the family for 7 days; either parent can load them.
  final _photos = <int, Uint8List>{};
  Uint8List? photoFor(int? worksheetId) =>
      worksheetId == null ? null : _photos[worksheetId];

  Future<Uint8List?> loadPhoto(Worksheet ws) async {
    final id = ws.id;
    if (id == null || ws.photoDeletedAt != null) return null;
    final cached = _photos[id];
    if (cached != null) return cached;
    final data = await client.worksheet.photo(id);
    if (data == null) return null;
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    _photos[id] = bytes;
    return bytes;
  }

  Future<void> deletePhoto(int worksheetId) => _busy(() async {
    await client.worksheet.deletePhoto(worksheetId);
    _photos.remove(worksheetId);
    await refresh();
  });

  Future<bool> snapWorksheet(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 72,
    );
    if (picked == null) return false;
    await _upload(await picked.readAsBytes());
    return true;
  }

  /// A sample grade-4 multiplication worksheet, for parents (and judges) who
  /// don't have tonight's homework at hand. It goes through the same path as
  /// a real photo: upload, Gemini, server-built and re-checked questions.
  Future<void> snapSample() async {
    final data = await rootBundle.load('assets/sample_worksheet.jpg');
    await _upload(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  Future<void> _upload(Uint8List bytes) async {
    await _busy(() async {
      final ticket = await client.worksheet.startPhoto();
      _photos[ticket.worksheetId] = bytes;
      final ok = await FileUploader(
        ticket.uploadDescription,
      ).uploadByteData(ByteData.sublistView(bytes));
      if (!ok) throw Exception('upload failed');
      await client.worksheet.submitPhoto(ticket.worksheetId);
      await refresh();
    });
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
    _refreshTimer?.cancel();
    _heartbeat?.cancel();
    _lifecycle?.dispose();
    _cheers.close();
    unawaited(_offline?.close());
    _retry?.cancel();
    _sub?.cancel();
    _events.close();
    super.dispose();
  }
}
