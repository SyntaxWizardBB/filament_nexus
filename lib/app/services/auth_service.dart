import 'package:firebase_auth/firebase_auth.dart';

/// Thrown by [AuthService] with a user-facing (German) message.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// Thin wrapper around Firebase Auth (email/password).
///
/// Single source of truth for the signed-in user. The UI reacts to
/// [authStateChanges]; screens use [uid] to scope data (e.g. a filament's
/// owner) and [avatarInitial] for the header.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;
  String? get displayName => _auth.currentUser?.displayName;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// First letter of the display name (fallback: e-mail) for the avatar.
  String get avatarInitial {
    final source = (displayName?.isNotEmpty ?? false)
        ? displayName!
        : (email ?? '');
    return source.isNotEmpty ? source[0].toUpperCase() : '?';
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user?.updateDisplayName(name.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<void> logout() => _auth.signOut();

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
  }

  /// Reauthenticates with [currentPassword], then sets [newPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final userEmail = user?.email;
    if (user == null || userEmail == null) {
      throw AuthException('Nicht angemeldet.');
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: userEmail,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Diese E-Mail ist bereits registriert.';
      case 'invalid-email':
        return 'Ungültige E-Mail-Adresse.';
      case 'weak-password':
        return 'Das Passwort ist zu schwach.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-Mail oder Passwort ist falsch.';
      case 'requires-recent-login':
        return 'Bitte melde dich neu an und versuche es erneut.';
      case 'network-request-failed':
        return 'Keine Verbindung zum Server.';
      default:
        return e.message ?? 'Authentifizierung fehlgeschlagen.';
    }
  }
}
