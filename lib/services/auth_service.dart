import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around [FirebaseAuth] for email/password and phone (OTP) auth.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Emits the current user whenever the auth state changes.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  /// Re-authenticates the current user with their password. Required by
  /// Firebase before sensitive operations like [deleteAccount] if the user's
  /// sign-in is no longer "recent" (throws `requires-recent-login` otherwise).
  Future<void> reauthenticateWithPassword(String password) {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw StateError('No signed-in email/password user to reauthenticate.');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    return user.reauthenticateWithCredential(credential);
  }

  /// Permanently deletes the current user's account.
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await user.delete();
  }
}
