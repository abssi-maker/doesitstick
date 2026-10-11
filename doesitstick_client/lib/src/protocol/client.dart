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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:doesitstick_client/src/protocol/card_view.dart' as _idhtdmyd;
import 'package:doesitstick_client/src/protocol/concept_id.dart' as _iab13f5m;
import 'package:doesitstick_client/src/protocol/concept_option.dart'
    as _im3fhzym;
import 'package:doesitstick_client/src/protocol/family_event.dart' as _iwtbkv8o;
import 'package:doesitstick_client/src/protocol/family_view.dart' as _ien4x08m;
import 'package:doesitstick_client/src/protocol/home_state.dart' as _iyuhn6os;
import 'package:doesitstick_client/src/protocol/mark_input.dart' as _iriw8uld;
import 'package:doesitstick_client/src/protocol/photo_upload_ticket.dart'
    as _i3wi8kje;
import 'package:doesitstick_client/src/protocol/share_link.dart' as _i7acv2a2;
import 'package:doesitstick_client/src/protocol/weekly_digest.dart'
    as _iu9kcjbp;
import 'package:doesitstick_client/src/protocol/worksheet.dart' as _i7ms0xun;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    as _ipulbpi2;
import 'protocol.dart' as _il2as5qe;
import 'sync_tables.dart' as _ii3f3u05;
import 'package:doesitstick_client/migrations/migration_registry.dart';

/// One-tap sign-in: each phone gets its own account without an email, so a
/// parent (or a judge) lands straight in the app. Email stays available.
/// {@category Endpoint}
class EndpointAnonymousIdp extends _iaic.EndpointAnonymousIdpBase {
  EndpointAnonymousIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'anonymousIdp';

  /// Creates a new anonymous account and returns its session.
  ///
  /// Invokes the [AnonymousIdp.beforeAnonymousAccount] callback if configured,
  /// which may prevent account creation if the endpoint is protected.
  @override
  _ida.Future<_iacc.AuthSuccess> login({String? token}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'anonymousIdp',
        'login',
        {'token': token},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Pairing two parents into one family, and the live family stream.
/// {@category Endpoint}
class EndpointFamily extends _isc.EndpointRef {
  EndpointFamily(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'family';

  _ida.Future<_ien4x08m.FamilyView?> me() =>
      caller.callServerEndpoint<_ien4x08m.FamilyView?>(
        'family',
        'me',
        {},
      );

  _ida.Future<_ien4x08m.FamilyView> create(
    String childName,
    String parentName,
  ) => caller.callServerEndpoint<_ien4x08m.FamilyView>(
    'family',
    'create',
    {
      'childName': childName,
      'parentName': parentName,
    },
  );

  _ida.Future<_ien4x08m.FamilyView> join(
    String inviteCode,
    String parentName,
  ) => caller.callServerEndpoint<_ien4x08m.FamilyView>(
    'family',
    'join',
    {
      'inviteCode': inviteCode,
      'parentName': parentName,
    },
  );

  /// Everything the home screen needs, in one call. The app also refetches
  /// this after reconnecting, so a missed stream event never loses data.
  _ida.Future<_iyuhn6os.HomeState> home() =>
      caller.callServerEndpoint<_iyuhn6os.HomeState>(
        'family',
        'home',
        {},
      );

  _ida.Future<List<_im3fhzym.ConceptOption>> concepts() =>
      caller.callServerEndpoint<List<_im3fhzym.ConceptOption>>(
        'family',
        'concepts',
        {},
      );

  _ida.Stream<_iwtbkv8o.FamilyEvent> updates() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iwtbkv8o.FamilyEvent>,
        _iwtbkv8o.FamilyEvent
      >(
        'family',
        'updates',
        {},
        {},
      );
}

/// Worksheet photo upload and topic choice.
/// {@category Endpoint}
class EndpointWorksheet extends _isc.EndpointRef {
  EndpointWorksheet(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'worksheet';

  _ida.Future<_i3wi8kje.PhotoUploadTicket> startPhoto() =>
      caller.callServerEndpoint<_i3wi8kje.PhotoUploadTicket>(
        'worksheet',
        'startPhoto',
        {},
      );

  /// Called after the upload finishes; hands the photo to the background job.
  _ida.Future<_i7ms0xun.Worksheet> submitPhoto(int worksheetId) =>
      caller.callServerEndpoint<_i7ms0xun.Worksheet>(
        'worksheet',
        'submitPhoto',
        {'worksheetId': worksheetId},
      );

  /// The worksheet photo, for either parent, while it's still kept.
  _ida.Future<_idt.ByteData?> photo(int worksheetId) =>
      caller.callServerEndpoint<_idt.ByteData?>(
        'worksheet',
        'photo',
        {'worksheetId': worksheetId},
      );

  /// Deletes the worksheet photo now instead of after the re-check week.
  _ida.Future<_i7ms0xun.Worksheet> deletePhoto(int worksheetId) =>
      caller.callServerEndpoint<_i7ms0xun.Worksheet>(
        'worksheet',
        'deletePhoto',
        {'worksheetId': worksheetId},
      );

  /// Pick the topic directly (no photo), or correct the reader's guess.
  _ida.Future<_i7ms0xun.Worksheet> chooseTopic(
    int? worksheetId,
    _iab13f5m.ConceptId conceptId,
  ) => caller.callServerEndpoint<_i7ms0xun.Worksheet>(
    'worksheet',
    'chooseTopic',
    {
      'worksheetId': worksheetId,
      'conceptId': conceptId,
    },
  );
}

/// Serverpod offline sync for the family's marks: the module's CRDT sync,
/// plus a hook for when a phone's marks land on the server (complete cards,
/// schedule re-checks, tell the other parent).
/// {@category Endpoint}
class EndpointFamilySync extends _isc.EndpointRef {
  EndpointFamilySync(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'familySync';

  _ida.Stream<_ipulbpi2.OfflineSyncStreamEvent> sync({
    required _ida.Stream<_ipulbpi2.OfflineSyncStreamEvent> changes,
    required bool once,
  }) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ipulbpi2.OfflineSyncStreamEvent>,
        _ipulbpi2.OfflineSyncStreamEvent
      >(
        'familySync',
        'sync',
        {'once': once},
        {'changes': changes},
      );
}

/// Cards and marks.
/// {@category Endpoint}
class EndpointCard extends _isc.EndpointRef {
  EndpointCard(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'card';

  _ida.Future<_idhtdmyd.CardView> card(int cardId) =>
      caller.callServerEndpoint<_idhtdmyd.CardView>(
        'card',
        'card',
        {'cardId': cardId},
      );

  /// Accepts a batch of marks, typically a phone's offline queue. Resending
  /// is safe. Returns the clientMarkIds the server holds.
  _ida.Future<List<String>> syncMarks(List<_iriw8uld.MarkInput> marks) =>
      caller.callServerEndpoint<List<String>>(
        'card',
        'syncMarks',
        {'marks': marks},
      );
}

/// Re-checks, the weekly digest and its share link.
/// {@category Endpoint}
class EndpointProgress extends _isc.EndpointRef {
  EndpointProgress(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'progress';

  _ida.Future<_iu9kcjbp.WeeklyDigest> digest() =>
      caller.callServerEndpoint<_iu9kcjbp.WeeklyDigest>(
        'progress',
        'digest',
        {},
      );

  _ida.Future<_i7acv2a2.ShareLink> shareDigest() =>
      caller.callServerEndpoint<_i7acv2a2.ShareLink>(
        'progress',
        'shareDigest',
        {},
      );

  _ida.Future<void> stopSharing() => caller.callServerEndpoint<void>(
    'progress',
    'stopSharing',
    {},
  );

  /// Demo control, labelled as such in the app: runs re-checks due within
  /// [days] right now instead of waiting.
  _ida.Future<int> jumpAhead(int days) => caller.callServerEndpoint<int>(
    'progress',
    'jumpAhead',
    {'days': days},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    offline_sync = _ipulbpi2.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _ipulbpi2.Caller offline_sync;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    anonymousIdp = EndpointAnonymousIdp(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    family = EndpointFamily(this);
    worksheet = EndpointWorksheet(this);
    familySync = EndpointFamilySync(this);
    card = EndpointCard(this);
    progress = EndpointProgress(this);
    modules = Modules(this);
  }

  late final EndpointAnonymousIdp anonymousIdp;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointFamily family;

  late final EndpointWorksheet worksheet;

  late final EndpointFamilySync familySync;

  late final EndpointCard card;

  late final EndpointProgress progress;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'anonymousIdp': anonymousIdp,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'family': family,
    'worksheet': worksheet,
    'familySync': familySync,
    'card': card,
    'progress': progress,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'offline_sync': modules.offline_sync,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }

  /// Creates a new client-side database session for the given path, wrapped
  /// with the `serverpod_offline_sync` engine for the tables declared with
  /// `database: sync`. See [createSession] for the [path], [runMigrations] and
  /// [isDebugMode] parameters.
  ///
  /// The [persistentUserId] is the user all local operations belong to. When
  /// omitted, the user must be passed through the transaction.
  _ida.Future<_ipulbpi2.OfflineSyncDatabaseSession> createSyncSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
    _isc.UuidValue? persistentUserId,
  }) async {
    final session = _ipulbpi2.OfflineSyncDatabaseSession.wraps(
      await createSession(
        path,
        runMigrations: runMigrations,
        isDebugMode: isDebugMode,
      ),
      syncTables: _ii3f3u05.syncTables,
      persistentUserId: persistentUserId,
    );
    await session.db.initialize();
    return session;
  }
}
