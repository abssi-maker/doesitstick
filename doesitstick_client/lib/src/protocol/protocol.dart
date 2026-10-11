/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:doesitstick_client/src/protocol/concept_option.dart'
    as _im3fhzym;
import 'package:doesitstick_client/src/protocol/mark_input.dart' as _iriw8uld;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    as _ipulbpi2;
import 'card_kind.dart' as _i9emmw3b;
import 'card_view.dart' as _iuaciou8;
import 'concept_digest.dart' as _i85n5w8z;
import 'concept_id.dart' as _igk9xj07;
import 'concept_option.dart' as _in1dh818;
import 'dis_exception.dart' as _i085ay1i;
import 'evidence_item.dart' as _idvtj3i7;
import 'family.dart' as _igf5ho4a;
import 'family_event.dart' as _i0fdno63;
import 'family_member.dart' as _i2ob6hdy;
import 'family_view.dart' as _i35187xv;
import 'home_state.dart' as _ikn5fpz0;
import 'mark.dart' as _i5z4rsow;
import 'mark_input.dart' as _i6sftrtx;
import 'outcome.dart' as _i76t1xe4;
import 'photo_upload_ticket.dart' as _ivh14x5g;
import 'question.dart' as _in6mynjk;
import 'question_card.dart' as _ijnkpz08;
import 'question_style.dart' as _i323tk66;
import 'question_view.dart' as _irhyxwad;
import 'recheck.dart' as _ihmo3v7u;
import 'recheck_status.dart' as _ibuccmzf;
import 'share_link.dart' as _i71vg603;
import 'weekly_digest.dart' as _ioeko3ow;
import 'worksheet.dart' as _itpm72xa;
import 'worksheet_status.dart' as _i3lw21mu;
export 'card_kind.dart';
export 'card_view.dart';
export 'concept_digest.dart';
export 'concept_id.dart';
export 'concept_option.dart';
export 'dis_exception.dart';
export 'evidence_item.dart';
export 'family.dart';
export 'family_event.dart';
export 'family_member.dart';
export 'family_view.dart';
export 'home_state.dart';
export 'mark.dart';
export 'mark_input.dart';
export 'outcome.dart';
export 'photo_upload_ticket.dart';
export 'question.dart';
export 'question_card.dart';
export 'question_style.dart';
export 'question_view.dart';
export 'recheck.dart';
export 'recheck_status.dart';
export 'share_link.dart';
export 'weekly_digest.dart';
export 'worksheet.dart';
export 'worksheet_status.dart';
export 'client.dart';
export 'sync_tables.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'mark',
      dartName: 'Mark',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isd.ColumnDefinition(
          name: 'spaceId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isd.ColumnDefinition(
          name: 'questionId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'cardId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'familyId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'outcome',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Outcome',
        ),
        _isd.ColumnDefinition(
          name: 'parentName',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'authUserId',
          columnType: _isd.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isd.ColumnDefinition(
          name: 'markedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'mark_fk_0',
          columns: ['spaceId'],
          referenceTable: 'offline_sync_spaces',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'mark_question_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'questionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isd.IndexDefinition(
          indexName: 'mark_card_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'cardId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._ipulbpi2.Protocol() is _isd.DatabaseSerializationManager
        ? (_ipulbpi2.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i9emmw3b.CardKind) {
      return _i9emmw3b.CardKind.fromJson(data) as T;
    }
    if (t == _iuaciou8.CardView) {
      return _iuaciou8.CardView.fromJson(data) as T;
    }
    if (t == _i85n5w8z.ConceptDigest) {
      return _i85n5w8z.ConceptDigest.fromJson(data) as T;
    }
    if (t == _igk9xj07.ConceptId) {
      return _igk9xj07.ConceptId.fromJson(data) as T;
    }
    if (t == _in1dh818.ConceptOption) {
      return _in1dh818.ConceptOption.fromJson(data) as T;
    }
    if (t == _i085ay1i.DidItStickException) {
      return _i085ay1i.DidItStickException.fromJson(data) as T;
    }
    if (t == _idvtj3i7.EvidenceItem) {
      return _idvtj3i7.EvidenceItem.fromJson(data) as T;
    }
    if (t == _igf5ho4a.Family) {
      return _igf5ho4a.Family.fromJson(data) as T;
    }
    if (t == _i0fdno63.FamilyEvent) {
      return _i0fdno63.FamilyEvent.fromJson(data) as T;
    }
    if (t == _i2ob6hdy.FamilyMember) {
      return _i2ob6hdy.FamilyMember.fromJson(data) as T;
    }
    if (t == _i35187xv.FamilyView) {
      return _i35187xv.FamilyView.fromJson(data) as T;
    }
    if (t == _ikn5fpz0.HomeState) {
      return _ikn5fpz0.HomeState.fromJson(data) as T;
    }
    if (t == _i5z4rsow.Mark) {
      return _i5z4rsow.Mark.fromJson(data) as T;
    }
    if (t == _i6sftrtx.MarkInput) {
      return _i6sftrtx.MarkInput.fromJson(data) as T;
    }
    if (t == _i76t1xe4.Outcome) {
      return _i76t1xe4.Outcome.fromJson(data) as T;
    }
    if (t == _ivh14x5g.PhotoUploadTicket) {
      return _ivh14x5g.PhotoUploadTicket.fromJson(data) as T;
    }
    if (t == _in6mynjk.Question) {
      return _in6mynjk.Question.fromJson(data) as T;
    }
    if (t == _ijnkpz08.QuestionCard) {
      return _ijnkpz08.QuestionCard.fromJson(data) as T;
    }
    if (t == _i323tk66.QuestionStyle) {
      return _i323tk66.QuestionStyle.fromJson(data) as T;
    }
    if (t == _irhyxwad.QuestionView) {
      return _irhyxwad.QuestionView.fromJson(data) as T;
    }
    if (t == _ihmo3v7u.Recheck) {
      return _ihmo3v7u.Recheck.fromJson(data) as T;
    }
    if (t == _ibuccmzf.RecheckStatus) {
      return _ibuccmzf.RecheckStatus.fromJson(data) as T;
    }
    if (t == _i71vg603.ShareLink) {
      return _i71vg603.ShareLink.fromJson(data) as T;
    }
    if (t == _ioeko3ow.WeeklyDigest) {
      return _ioeko3ow.WeeklyDigest.fromJson(data) as T;
    }
    if (t == _itpm72xa.Worksheet) {
      return _itpm72xa.Worksheet.fromJson(data) as T;
    }
    if (t == _i3lw21mu.WorksheetStatus) {
      return _i3lw21mu.WorksheetStatus.fromJson(data) as T;
    }
    if (t == _isc.getType<_i9emmw3b.CardKind?>()) {
      return (data != null ? _i9emmw3b.CardKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuaciou8.CardView?>()) {
      return (data != null ? _iuaciou8.CardView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i85n5w8z.ConceptDigest?>()) {
      return (data != null ? _i85n5w8z.ConceptDigest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igk9xj07.ConceptId?>()) {
      return (data != null ? _igk9xj07.ConceptId.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in1dh818.ConceptOption?>()) {
      return (data != null ? _in1dh818.ConceptOption.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i085ay1i.DidItStickException?>()) {
      return (data != null
              ? _i085ay1i.DidItStickException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idvtj3i7.EvidenceItem?>()) {
      return (data != null ? _idvtj3i7.EvidenceItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igf5ho4a.Family?>()) {
      return (data != null ? _igf5ho4a.Family.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0fdno63.FamilyEvent?>()) {
      return (data != null ? _i0fdno63.FamilyEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2ob6hdy.FamilyMember?>()) {
      return (data != null ? _i2ob6hdy.FamilyMember.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i35187xv.FamilyView?>()) {
      return (data != null ? _i35187xv.FamilyView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikn5fpz0.HomeState?>()) {
      return (data != null ? _ikn5fpz0.HomeState.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5z4rsow.Mark?>()) {
      return (data != null ? _i5z4rsow.Mark.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6sftrtx.MarkInput?>()) {
      return (data != null ? _i6sftrtx.MarkInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i76t1xe4.Outcome?>()) {
      return (data != null ? _i76t1xe4.Outcome.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivh14x5g.PhotoUploadTicket?>()) {
      return (data != null ? _ivh14x5g.PhotoUploadTicket.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_in6mynjk.Question?>()) {
      return (data != null ? _in6mynjk.Question.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijnkpz08.QuestionCard?>()) {
      return (data != null ? _ijnkpz08.QuestionCard.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i323tk66.QuestionStyle?>()) {
      return (data != null ? _i323tk66.QuestionStyle.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irhyxwad.QuestionView?>()) {
      return (data != null ? _irhyxwad.QuestionView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihmo3v7u.Recheck?>()) {
      return (data != null ? _ihmo3v7u.Recheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibuccmzf.RecheckStatus?>()) {
      return (data != null ? _ibuccmzf.RecheckStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i71vg603.ShareLink?>()) {
      return (data != null ? _i71vg603.ShareLink.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioeko3ow.WeeklyDigest?>()) {
      return (data != null ? _ioeko3ow.WeeklyDigest.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itpm72xa.Worksheet?>()) {
      return (data != null ? _itpm72xa.Worksheet.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3lw21mu.WorksheetStatus?>()) {
      return (data != null ? _i3lw21mu.WorksheetStatus.fromJson(data) : null)
          as T;
    }
    if (t == List<_irhyxwad.QuestionView>) {
      return (data as List)
              .map((e) => deserialize<_irhyxwad.QuestionView>(e))
              .toList()
          as T;
    }
    if (t == List<_idvtj3i7.EvidenceItem>) {
      return (data as List)
              .map((e) => deserialize<_idvtj3i7.EvidenceItem>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_itpm72xa.Worksheet>) {
      return (data as List)
              .map((e) => deserialize<_itpm72xa.Worksheet>(e))
              .toList()
          as T;
    }
    if (t == List<_iuaciou8.CardView>) {
      return (data as List)
              .map((e) => deserialize<_iuaciou8.CardView>(e))
              .toList()
          as T;
    }
    if (t == List<_ihmo3v7u.Recheck>) {
      return (data as List)
              .map((e) => deserialize<_ihmo3v7u.Recheck>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i5z4rsow.Mark>) {
      return (data as List).map((e) => deserialize<_i5z4rsow.Mark>(e)).toList()
          as T;
    }
    if (t == List<_i85n5w8z.ConceptDigest>) {
      return (data as List)
              .map((e) => deserialize<_i85n5w8z.ConceptDigest>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_im3fhzym.ConceptOption>) {
      return (data as List)
              .map((e) => deserialize<_im3fhzym.ConceptOption>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iriw8uld.MarkInput>) {
      return (data as List)
              .map((e) => deserialize<_iriw8uld.MarkInput>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ipulbpi2.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i9emmw3b.CardKind => 'CardKind',
      _iuaciou8.CardView => 'CardView',
      _i85n5w8z.ConceptDigest => 'ConceptDigest',
      _igk9xj07.ConceptId => 'ConceptId',
      _in1dh818.ConceptOption => 'ConceptOption',
      _i085ay1i.DidItStickException => 'DidItStickException',
      _idvtj3i7.EvidenceItem => 'EvidenceItem',
      _igf5ho4a.Family => 'Family',
      _i0fdno63.FamilyEvent => 'FamilyEvent',
      _i2ob6hdy.FamilyMember => 'FamilyMember',
      _i35187xv.FamilyView => 'FamilyView',
      _ikn5fpz0.HomeState => 'HomeState',
      _i5z4rsow.Mark => 'Mark',
      _i6sftrtx.MarkInput => 'MarkInput',
      _i76t1xe4.Outcome => 'Outcome',
      _ivh14x5g.PhotoUploadTicket => 'PhotoUploadTicket',
      _in6mynjk.Question => 'Question',
      _ijnkpz08.QuestionCard => 'QuestionCard',
      _i323tk66.QuestionStyle => 'QuestionStyle',
      _irhyxwad.QuestionView => 'QuestionView',
      _ihmo3v7u.Recheck => 'Recheck',
      _ibuccmzf.RecheckStatus => 'RecheckStatus',
      _i71vg603.ShareLink => 'ShareLink',
      _ioeko3ow.WeeklyDigest => 'WeeklyDigest',
      _itpm72xa.Worksheet => 'Worksheet',
      _i3lw21mu.WorksheetStatus => 'WorksheetStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('doesitstick.', '');
    }

    switch (data) {
      case _i9emmw3b.CardKind():
        return 'CardKind';
      case _iuaciou8.CardView():
        return 'CardView';
      case _i85n5w8z.ConceptDigest():
        return 'ConceptDigest';
      case _igk9xj07.ConceptId():
        return 'ConceptId';
      case _in1dh818.ConceptOption():
        return 'ConceptOption';
      case _i085ay1i.DidItStickException():
        return 'DidItStickException';
      case _idvtj3i7.EvidenceItem():
        return 'EvidenceItem';
      case _igf5ho4a.Family():
        return 'Family';
      case _i0fdno63.FamilyEvent():
        return 'FamilyEvent';
      case _i2ob6hdy.FamilyMember():
        return 'FamilyMember';
      case _i35187xv.FamilyView():
        return 'FamilyView';
      case _ikn5fpz0.HomeState():
        return 'HomeState';
      case _i5z4rsow.Mark():
        return 'Mark';
      case _i6sftrtx.MarkInput():
        return 'MarkInput';
      case _i76t1xe4.Outcome():
        return 'Outcome';
      case _ivh14x5g.PhotoUploadTicket():
        return 'PhotoUploadTicket';
      case _in6mynjk.Question():
        return 'Question';
      case _ijnkpz08.QuestionCard():
        return 'QuestionCard';
      case _i323tk66.QuestionStyle():
        return 'QuestionStyle';
      case _irhyxwad.QuestionView():
        return 'QuestionView';
      case _ihmo3v7u.Recheck():
        return 'Recheck';
      case _ibuccmzf.RecheckStatus():
        return 'RecheckStatus';
      case _i71vg603.ShareLink():
        return 'ShareLink';
      case _ioeko3ow.WeeklyDigest():
        return 'WeeklyDigest';
      case _itpm72xa.Worksheet():
        return 'Worksheet';
      case _i3lw21mu.WorksheetStatus():
        return 'WorksheetStatus';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _ipulbpi2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CardKind') {
      return deserialize<_i9emmw3b.CardKind>(data['data']);
    }
    if (dataClassName == 'CardView') {
      return deserialize<_iuaciou8.CardView>(data['data']);
    }
    if (dataClassName == 'ConceptDigest') {
      return deserialize<_i85n5w8z.ConceptDigest>(data['data']);
    }
    if (dataClassName == 'ConceptId') {
      return deserialize<_igk9xj07.ConceptId>(data['data']);
    }
    if (dataClassName == 'ConceptOption') {
      return deserialize<_in1dh818.ConceptOption>(data['data']);
    }
    if (dataClassName == 'DidItStickException') {
      return deserialize<_i085ay1i.DidItStickException>(data['data']);
    }
    if (dataClassName == 'EvidenceItem') {
      return deserialize<_idvtj3i7.EvidenceItem>(data['data']);
    }
    if (dataClassName == 'Family') {
      return deserialize<_igf5ho4a.Family>(data['data']);
    }
    if (dataClassName == 'FamilyEvent') {
      return deserialize<_i0fdno63.FamilyEvent>(data['data']);
    }
    if (dataClassName == 'FamilyMember') {
      return deserialize<_i2ob6hdy.FamilyMember>(data['data']);
    }
    if (dataClassName == 'FamilyView') {
      return deserialize<_i35187xv.FamilyView>(data['data']);
    }
    if (dataClassName == 'HomeState') {
      return deserialize<_ikn5fpz0.HomeState>(data['data']);
    }
    if (dataClassName == 'Mark') {
      return deserialize<_i5z4rsow.Mark>(data['data']);
    }
    if (dataClassName == 'MarkInput') {
      return deserialize<_i6sftrtx.MarkInput>(data['data']);
    }
    if (dataClassName == 'Outcome') {
      return deserialize<_i76t1xe4.Outcome>(data['data']);
    }
    if (dataClassName == 'PhotoUploadTicket') {
      return deserialize<_ivh14x5g.PhotoUploadTicket>(data['data']);
    }
    if (dataClassName == 'Question') {
      return deserialize<_in6mynjk.Question>(data['data']);
    }
    if (dataClassName == 'QuestionCard') {
      return deserialize<_ijnkpz08.QuestionCard>(data['data']);
    }
    if (dataClassName == 'QuestionStyle') {
      return deserialize<_i323tk66.QuestionStyle>(data['data']);
    }
    if (dataClassName == 'QuestionView') {
      return deserialize<_irhyxwad.QuestionView>(data['data']);
    }
    if (dataClassName == 'Recheck') {
      return deserialize<_ihmo3v7u.Recheck>(data['data']);
    }
    if (dataClassName == 'RecheckStatus') {
      return deserialize<_ibuccmzf.RecheckStatus>(data['data']);
    }
    if (dataClassName == 'ShareLink') {
      return deserialize<_i71vg603.ShareLink>(data['data']);
    }
    if (dataClassName == 'WeeklyDigest') {
      return deserialize<_ioeko3ow.WeeklyDigest>(data['data']);
    }
    if (dataClassName == 'Worksheet') {
      return deserialize<_itpm72xa.Worksheet>(data['data']);
    }
    if (dataClassName == 'WorksheetStatus') {
      return deserialize<_i3lw21mu.WorksheetStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _ipulbpi2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('doesitstick', this);
    _ipulbpi2.Protocol().registerHostProtocol('doesitstick', this);
    _iacc.Protocol().registerHostProtocol('doesitstick', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ipulbpi2.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5z4rsow.Mark:
        return _i5z4rsow.Mark.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'doesitstick';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _ipulbpi2.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
