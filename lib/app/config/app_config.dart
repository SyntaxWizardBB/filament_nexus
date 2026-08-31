/// Central app configuration.
///
/// ## Switching the data source
/// Flip [useFirebase] here to choose the backend — no build flag needed:
///   * `false` → local mock data
///   * `true`  → Firestore (the current setting)
///
/// Firebase connection details are NOT needed here — they come from the
/// generated `firebase_options.dart` and `Firebase.initializeApp` in main.dart.
abstract final class AppConfig {
  /// Set to `true` to use [FirebaseFilamentDataSource], `false` for the local
  /// mock data source.
  static const bool useFirebase = true;

  /// Whether users must confirm their e-mail before entering the app.
  ///
  /// Keep in sync with `verificationRequired()` in `firestore.rules` — that
  /// function guards the same rule on the server. After changing it there:
  /// `firebase deploy --only firestore:rules`
  static const bool requireEmailVerification = false;
}