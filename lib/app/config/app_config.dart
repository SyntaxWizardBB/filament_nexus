/// Central app configuration.
///
/// ## Switching the data source
/// Flip [useFirebase] here to choose the backend — no build flag needed:
///   * `false` → local mock data (default)
///   * `true`  → Firestore
///
/// Firebase connection details are NOT needed here — they come from the
/// generated `firebase_options.dart` and `Firebase.initializeApp` in main.dart.
abstract final class AppConfig {
  /// Set to `true` to use [FirebaseFilamentDataSource], `false` for the local
  /// mock data source.
  static const bool useFirebase = true;
}