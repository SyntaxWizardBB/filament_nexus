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

  /// Whether the signed-in user confirmed their e-mail address.
  /// Writing to Firestore requires this (enforced by the security rules).
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Sends (or resends) the confirmation e-mail. Firebase delivers it.
  Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  /// Refetches the user so [isEmailVerified] reflects a just-clicked link.
  Future<void> reloadUser() => _auth.currentUser?.reload() ?? Future.value();

  /// Sends a password reset link to [email].
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

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
      // Confirmation mail is sent by Firebase right after sign-up.
      await cred.user?.sendEmailVerification();
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

  /// Confirms the user's identity with [currentPassword] — required by
  /// Firebase before security-sensitive changes (password, e-mail).
  Future<User> _reauthenticate(String currentPassword) async {
    final user = _auth.currentUser;
    final userEmail = user?.email;
    if (user == null || userEmail == null) {
      throw AuthException('Nicht angemeldet.');
    }
    final credential = EmailAuthProvider.credential(
      email: userEmail,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    return user;
  }

  /// Reauthenticates with [currentPassword], then sets [newPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = await _reauthenticate(currentPassword);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  /// Reauthenticates, then sends a confirmation link to [newEmail].
  ///
  /// The login address only changes once that link is opened — until then the
  /// current address stays valid.
  Future<void> changeEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    try {
      final user = await _reauthenticate(currentPassword);
      await user.verifyBeforeUpdateEmail(newEmail.trim());
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
      case 'too-many-requests':
        return 'Zu viele Versuche. Bitte warte einen Moment.';
      default:
        return e.message ?? 'Authentifizierung fehlgeschlagen.';
    }
  }
}
