import 'auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession?> currentSession();
  Stream<AuthSession?> sessionChanges();
  Future<AuthSession> signIn({
    required String username,
    required String password,
  });
  Future<void> signOut();
}
