import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

/// One-tap sign-in: each phone gets its own account without an email, so a
/// parent (or a judge) lands straight in the app. Email stays available.
class AnonymousIdpEndpoint extends AnonymousIdpBaseEndpoint {}
