/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:doesitstick_server/src/generated/concept_id.dart' as _iqejb9wz;
import 'package:doesitstick_server/src/generated/future_calls.dart'
    as _i7eeai5e;
import 'package:doesitstick_server/src/generated/mark_input.dart' as _iogl7hai;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    as _izehhkf5;
import '../auth/anonymous_idp_endpoint.dart' as _in0zita6;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints.dart' as _iwwls8qa;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'anonymousIdp': _in0zita6.AnonymousIdpEndpoint()
        ..initialize(
          server,
          'anonymousIdp',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'family': _iwwls8qa.FamilyEndpoint()
        ..initialize(
          server,
          'family',
          null,
        ),
      'worksheet': _iwwls8qa.WorksheetEndpoint()
        ..initialize(
          server,
          'worksheet',
          null,
        ),
      'familySync': _iwwls8qa.FamilySyncEndpoint()
        ..initialize(
          server,
          'familySync',
          null,
        ),
      'card': _iwwls8qa.CardEndpoint()
        ..initialize(
          server,
          'card',
          null,
        ),
      'progress': _iwwls8qa.ProgressEndpoint()
        ..initialize(
          server,
          'progress',
          null,
        ),
    };
    connectors['anonymousIdp'] = _is.EndpointConnector(
      name: 'anonymousIdp',
      endpoint: endpoints['anonymousIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['anonymousIdp'] as _in0zita6.AnonymousIdpEndpoint)
                      .login(
                        session,
                        token: params['token'],
                      ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['family'] = _is.EndpointConnector(
      name: 'family',
      endpoint: endpoints['family']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _iwwls8qa.FamilyEndpoint).me(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'childName': _is.ParameterDescription(
              name: 'childName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'parentName': _is.ParameterDescription(
              name: 'parentName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['family'] as _iwwls8qa.FamilyEndpoint).create(
                    session,
                    params['childName'],
                    params['parentName'],
                  ),
        ),
        'join': _is.MethodConnector(
          name: 'join',
          params: {
            'inviteCode': _is.ParameterDescription(
              name: 'inviteCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'parentName': _is.ParameterDescription(
              name: 'parentName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['family'] as _iwwls8qa.FamilyEndpoint).join(
                session,
                params['inviteCode'],
                params['parentName'],
              ),
        ),
        'home': _is.MethodConnector(
          name: 'home',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['family'] as _iwwls8qa.FamilyEndpoint).home(
                session,
              ),
        ),
        'concepts': _is.MethodConnector(
          name: 'concepts',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['family'] as _iwwls8qa.FamilyEndpoint)
                  .concepts(session),
        ),
        'updates': _is.MethodStreamConnector(
          name: 'updates',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['family'] as _iwwls8qa.FamilyEndpoint).updates(
                session,
              ),
        ),
      },
    );
    connectors['worksheet'] = _is.EndpointConnector(
      name: 'worksheet',
      endpoint: endpoints['worksheet']!,
      methodConnectors: {
        'startPhoto': _is.MethodConnector(
          name: 'startPhoto',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['worksheet'] as _iwwls8qa.WorksheetEndpoint)
                  .startPhoto(session),
        ),
        'submitPhoto': _is.MethodConnector(
          name: 'submitPhoto',
          params: {
            'worksheetId': _is.ParameterDescription(
              name: 'worksheetId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['worksheet'] as _iwwls8qa.WorksheetEndpoint)
                  .submitPhoto(
                    session,
                    params['worksheetId'],
                  ),
        ),
        'photo': _is.MethodConnector(
          name: 'photo',
          params: {
            'worksheetId': _is.ParameterDescription(
              name: 'worksheetId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['worksheet'] as _iwwls8qa.WorksheetEndpoint).photo(
                    session,
                    params['worksheetId'],
                  ),
        ),
        'deletePhoto': _is.MethodConnector(
          name: 'deletePhoto',
          params: {
            'worksheetId': _is.ParameterDescription(
              name: 'worksheetId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['worksheet'] as _iwwls8qa.WorksheetEndpoint)
                  .deletePhoto(
                    session,
                    params['worksheetId'],
                  ),
        ),
        'chooseTopic': _is.MethodConnector(
          name: 'chooseTopic',
          params: {
            'worksheetId': _is.ParameterDescription(
              name: 'worksheetId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'conceptId': _is.ParameterDescription(
              name: 'conceptId',
              type: _is.getType<_iqejb9wz.ConceptId>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['worksheet'] as _iwwls8qa.WorksheetEndpoint)
                  .chooseTopic(
                    session,
                    params['worksheetId'],
                    params['conceptId'],
                  ),
        ),
      },
    );
    connectors['familySync'] = _is.EndpointConnector(
      name: 'familySync',
      endpoint: endpoints['familySync']!,
      methodConnectors: {
        'sync': _is.MethodStreamConnector(
          name: 'sync',
          params: {
            'once': _is.ParameterDescription(
              name: 'once',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          streamParams: {
            'changes':
                _is.StreamParameterDescription<
                  _izehhkf5.OfflineSyncStreamEvent
                >(
                  name: 'changes',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['familySync'] as _iwwls8qa.FamilySyncEndpoint)
                  .sync(
                    session,
                    changes: streamParams['changes']!
                        .cast<_izehhkf5.OfflineSyncStreamEvent>(),
                    once: params['once'],
                  ),
        ),
      },
    );
    connectors['card'] = _is.EndpointConnector(
      name: 'card',
      endpoint: endpoints['card']!,
      methodConnectors: {
        'card': _is.MethodConnector(
          name: 'card',
          params: {
            'cardId': _is.ParameterDescription(
              name: 'cardId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _iwwls8qa.CardEndpoint).card(
                session,
                params['cardId'],
              ),
        ),
        'syncMarks': _is.MethodConnector(
          name: 'syncMarks',
          params: {
            'marks': _is.ParameterDescription(
              name: 'marks',
              type: _is.getType<List<_iogl7hai.MarkInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['card'] as _iwwls8qa.CardEndpoint).syncMarks(
                    session,
                    params['marks'],
                  ),
        ),
      },
    );
    connectors['progress'] = _is.EndpointConnector(
      name: 'progress',
      endpoint: endpoints['progress']!,
      methodConnectors: {
        'digest': _is.MethodConnector(
          name: 'digest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _iwwls8qa.ProgressEndpoint)
                  .digest(session),
        ),
        'shareDigest': _is.MethodConnector(
          name: 'shareDigest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _iwwls8qa.ProgressEndpoint)
                  .shareDigest(session),
        ),
        'stopSharing': _is.MethodConnector(
          name: 'stopSharing',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _iwwls8qa.ProgressEndpoint)
                  .stopSharing(session),
        ),
        'jumpAhead': _is.MethodConnector(
          name: 'jumpAhead',
          params: {
            'days': _is.ParameterDescription(
              name: 'days',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _iwwls8qa.ProgressEndpoint)
                  .jumpAhead(
                    session,
                    params['days'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_offline_sync'] = _izehhkf5.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i7eeai5e.FutureCalls();
  }
}
