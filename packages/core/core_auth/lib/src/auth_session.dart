import 'package:meta/meta.dart';

@immutable
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.accessToken,
    this.refreshToken,
  });

  final String userId;
  final String accessToken;
  final String? refreshToken;

  bool get isAuthenticated => accessToken.isNotEmpty;
}
