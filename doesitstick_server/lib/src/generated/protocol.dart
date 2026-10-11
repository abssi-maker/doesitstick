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
import 'package:doesitstick_server/src/generated/concept_option.dart'
    as _icruhs9h;
import 'package:doesitstick_server/src/generated/mark_input.dart' as _iogl7hai;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    as _izehhkf5;
import 'card_kind.dart' as _i9emmw3b;
import 'card_view.dart' as _iuaciou8;
import 'cheer.dart' as _ic7ycjzu;
import 'concept_digest.dart' as _i85n5w8z;
import 'concept_id.dart' as _igk9xj07;
import 'concept_option.dart' as _in1dh818;
import 'dis_exception.dart' as _i085ay1i;
import 'evidence_item.dart' as _idvtj3i7;
import 'family.dart' as _igf5ho4a;
import 'family_event.dart' as _i0fdno63;
import 'family_member.dart' as _i2ob6hdy;
import 'family_view.dart' as _i35187xv;
import 'future_calls_generated_models/read_worksheet_future_call_read_model.dart'
    as _iq2zyg1j;
import 'future_calls_generated_models/recheck_future_call_materialize_model.dart'
    as _itqh4pij;
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
import 'slip.dart' as _ijxu783d;
import 'weekly_digest.dart' as _ioeko3ow;
import 'worksheet.dart' as _itpm72xa;
import 'worksheet_status.dart' as _i3lw21mu;
export 'card_kind.dart';
export 'card_view.dart';
export 'cheer.dart';
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
export 'slip.dart';
export 'weekly_digest.dart';
export 'worksheet.dart';
export 'worksheet_status.dart';
export 'sync_tables.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'family',
      dartName: 'Family',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'childName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'inviteCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'shareToken',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'syncSpace',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'family_invite_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'inviteCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'family_share_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'shareToken',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'family_member',
      dartName: 'FamilyMember',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'joinedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'family_member_fk_0',
          columns: ['familyId'],
          referenceTable: 'family',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'family_member_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'mark',
      dartName: 'Mark',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'spaceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'questionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'cardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'outcome',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Outcome',
        ),
        _isp.ColumnDefinition(
          name: 'parentName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'markedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'mark_fk_0',
          columns: ['spaceId'],
          referenceTable: 'offline_sync_spaces',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'mark_question_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'questionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'mark_card_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'question',
      dartName: 'Question',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'cardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'conceptId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ConceptId',
        ),
        _isp.ColumnDefinition(
          name: 'style',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:QuestionStyle',
        ),
        _isp.ColumnDefinition(
          name: 'seed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'operands',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'prompt',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'expectedAnswer',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'answerValue',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'shownWrong',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'methodNote',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'listenFor',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hint',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nextStep',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'slips',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:Slip>?',
        ),
        _isp.ColumnDefinition(
          name: 'checkedByCode',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'fromWorksheet',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'variantOfQuestionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'question_fk_0',
          columns: ['cardId'],
          referenceTable: 'question_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'question_card',
      dartName: 'QuestionCard',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'conceptId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ConceptId',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CardKind',
        ),
        _isp.ColumnDefinition(
          name: 'recheckDay',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sourceCardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'question_card_fk_0',
          columns: ['familyId'],
          referenceTable: 'family',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'recheck',
      dartName: 'Recheck',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sourceCardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'conceptId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ConceptId',
        ),
        _isp.ColumnDefinition(
          name: 'dayOffset',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'dueAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RecheckStatus',
        ),
        _isp.ColumnDefinition(
          name: 'cardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'fastForwarded',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'recheck_fk_0',
          columns: ['familyId'],
          referenceTable: 'family',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'recheck_source_day_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceCardId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'dayOffset',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'worksheet',
      dartName: 'Worksheet',
      schema: 'public',
      module: 'doesitstick',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'familyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'uploadedByName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'photoPath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:WorksheetStatus',
        ),
        _isp.ColumnDefinition(
          name: 'conceptId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ConceptId?',
        ),
        _isp.ColumnDefinition(
          name: 'detectedProblems',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'cardId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'photoDeletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'worksheet_fk_0',
          columns: ['familyId'],
          referenceTable: 'family',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._izehhkf5.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _ic7ycjzu.Cheer) {
      return _ic7ycjzu.Cheer.fromJson(data) as T;
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
    if (t == _iq2zyg1j.ReadWorksheetFutureCallReadModel) {
      return _iq2zyg1j.ReadWorksheetFutureCallReadModel.fromJson(data) as T;
    }
    if (t == _itqh4pij.RecheckFutureCallMaterializeModel) {
      return _itqh4pij.RecheckFutureCallMaterializeModel.fromJson(data) as T;
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
    if (t == _ijxu783d.Slip) {
      return _ijxu783d.Slip.fromJson(data) as T;
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
    if (t == _is.getType<_i9emmw3b.CardKind?>()) {
      return (data != null ? _i9emmw3b.CardKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuaciou8.CardView?>()) {
      return (data != null ? _iuaciou8.CardView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ic7ycjzu.Cheer?>()) {
      return (data != null ? _ic7ycjzu.Cheer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i85n5w8z.ConceptDigest?>()) {
      return (data != null ? _i85n5w8z.ConceptDigest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igk9xj07.ConceptId?>()) {
      return (data != null ? _igk9xj07.ConceptId.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in1dh818.ConceptOption?>()) {
      return (data != null ? _in1dh818.ConceptOption.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i085ay1i.DidItStickException?>()) {
      return (data != null
              ? _i085ay1i.DidItStickException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_idvtj3i7.EvidenceItem?>()) {
      return (data != null ? _idvtj3i7.EvidenceItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igf5ho4a.Family?>()) {
      return (data != null ? _igf5ho4a.Family.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0fdno63.FamilyEvent?>()) {
      return (data != null ? _i0fdno63.FamilyEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2ob6hdy.FamilyMember?>()) {
      return (data != null ? _i2ob6hdy.FamilyMember.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i35187xv.FamilyView?>()) {
      return (data != null ? _i35187xv.FamilyView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iq2zyg1j.ReadWorksheetFutureCallReadModel?>()) {
      return (data != null
              ? _iq2zyg1j.ReadWorksheetFutureCallReadModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_itqh4pij.RecheckFutureCallMaterializeModel?>()) {
      return (data != null
              ? _itqh4pij.RecheckFutureCallMaterializeModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ikn5fpz0.HomeState?>()) {
      return (data != null ? _ikn5fpz0.HomeState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5z4rsow.Mark?>()) {
      return (data != null ? _i5z4rsow.Mark.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6sftrtx.MarkInput?>()) {
      return (data != null ? _i6sftrtx.MarkInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i76t1xe4.Outcome?>()) {
      return (data != null ? _i76t1xe4.Outcome.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivh14x5g.PhotoUploadTicket?>()) {
      return (data != null ? _ivh14x5g.PhotoUploadTicket.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_in6mynjk.Question?>()) {
      return (data != null ? _in6mynjk.Question.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijnkpz08.QuestionCard?>()) {
      return (data != null ? _ijnkpz08.QuestionCard.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i323tk66.QuestionStyle?>()) {
      return (data != null ? _i323tk66.QuestionStyle.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irhyxwad.QuestionView?>()) {
      return (data != null ? _irhyxwad.QuestionView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihmo3v7u.Recheck?>()) {
      return (data != null ? _ihmo3v7u.Recheck.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibuccmzf.RecheckStatus?>()) {
      return (data != null ? _ibuccmzf.RecheckStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i71vg603.ShareLink?>()) {
      return (data != null ? _i71vg603.ShareLink.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijxu783d.Slip?>()) {
      return (data != null ? _ijxu783d.Slip.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioeko3ow.WeeklyDigest?>()) {
      return (data != null ? _ioeko3ow.WeeklyDigest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itpm72xa.Worksheet?>()) {
      return (data != null ? _itpm72xa.Worksheet.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3lw21mu.WorksheetStatus?>()) {
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
    if (t == List<_ijxu783d.Slip>) {
      return (data as List).map((e) => deserialize<_ijxu783d.Slip>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_ijxu783d.Slip>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ijxu783d.Slip>(e))
                    .toList()
              : null)
          as T;
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
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_icruhs9h.ConceptOption>) {
      return (data as List)
              .map((e) => deserialize<_icruhs9h.ConceptOption>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iogl7hai.MarkInput>) {
      return (data as List)
              .map((e) => deserialize<_iogl7hai.MarkInput>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _izehhkf5.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i9emmw3b.CardKind => 'CardKind',
      _iuaciou8.CardView => 'CardView',
      _ic7ycjzu.Cheer => 'Cheer',
      _i85n5w8z.ConceptDigest => 'ConceptDigest',
      _igk9xj07.ConceptId => 'ConceptId',
      _in1dh818.ConceptOption => 'ConceptOption',
      _i085ay1i.DidItStickException => 'DidItStickException',
      _idvtj3i7.EvidenceItem => 'EvidenceItem',
      _igf5ho4a.Family => 'Family',
      _i0fdno63.FamilyEvent => 'FamilyEvent',
      _i2ob6hdy.FamilyMember => 'FamilyMember',
      _i35187xv.FamilyView => 'FamilyView',
      _iq2zyg1j.ReadWorksheetFutureCallReadModel =>
        'ReadWorksheetFutureCallReadModel',
      _itqh4pij.RecheckFutureCallMaterializeModel =>
        'RecheckFutureCallMaterializeModel',
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
      _ijxu783d.Slip => 'Slip',
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
      case _ic7ycjzu.Cheer():
        return 'Cheer';
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
      case _iq2zyg1j.ReadWorksheetFutureCallReadModel():
        return 'ReadWorksheetFutureCallReadModel';
      case _itqh4pij.RecheckFutureCallMaterializeModel():
        return 'RecheckFutureCallMaterializeModel';
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
      case _ijxu783d.Slip():
        return 'Slip';
      case _ioeko3ow.WeeklyDigest():
        return 'WeeklyDigest';
      case _itpm72xa.Worksheet():
        return 'Worksheet';
      case _i3lw21mu.WorksheetStatus():
        return 'WorksheetStatus';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _izehhkf5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'Cheer') {
      return deserialize<_ic7ycjzu.Cheer>(data['data']);
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
    if (dataClassName == 'ReadWorksheetFutureCallReadModel') {
      return deserialize<_iq2zyg1j.ReadWorksheetFutureCallReadModel>(
        data['data'],
      );
    }
    if (dataClassName == 'RecheckFutureCallMaterializeModel') {
      return deserialize<_itqh4pij.RecheckFutureCallMaterializeModel>(
        data['data'],
      );
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
    if (dataClassName == 'Slip') {
      return deserialize<_ijxu783d.Slip>(data['data']);
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _izehhkf5.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('doesitstick', this);
    _izehhkf5.Protocol().registerHostProtocol('doesitstick', this);
    _iacs.Protocol().registerHostProtocol('doesitstick', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _izehhkf5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _igf5ho4a.Family:
        return _igf5ho4a.Family.t;
      case _i2ob6hdy.FamilyMember:
        return _i2ob6hdy.FamilyMember.t;
      case _i5z4rsow.Mark:
        return _i5z4rsow.Mark.t;
      case _in6mynjk.Question:
        return _in6mynjk.Question.t;
      case _ijnkpz08.QuestionCard:
        return _ijnkpz08.QuestionCard.t;
      case _ihmo3v7u.Recheck:
        return _ihmo3v7u.Recheck.t;
      case _itpm72xa.Worksheet:
        return _itpm72xa.Worksheet.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _izehhkf5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
