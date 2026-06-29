/// Compile-time app configuration.
///
/// ## Switching the data source
/// The backend is chosen via a build flag, so no code edit is needed:
///
/// ```bash
/// flutter run                                  # local mock data (default)
/// flutter run --dart-define=USE_FIREBASE=true  # Firestore backend
/// ```
///
/// Firebase connection details are NOT needed here — they come from the
/// generated `firebase_options.dart` and `Firebase.initializeApp` in main.dart.
abstract final class AppConfig {
  /// Whether to use [FirebaseFilamentDataSource] (true) or the local mock
  /// data source (false). Toggle with `--dart-define=USE_FIREBASE=true`.
  static const useFirebase = bool.fromEnvironment('USE_FIREBASE');
}
