/// Compile-time app configuration.
///
/// ## Switching the data source
/// Set [useFirebase] to true to use Firestore as the backend.
/// When enabling Firebase, fill in the connection fields below.
///
/// ## Finding your Firebase values
/// Firebase Console → Project Settings → Your Apps → SDK setup and configuration
abstract final class AppConfig {
  // ---------------------------------------------------------------------------
  // Data source — set manually
  // ---------------------------------------------------------------------------

  /// Set to true to use [FirebaseFilamentDataSource], false for local mock data.
  static const useFirebase = false;

  // ---------------------------------------------------------------------------
  // Firebase connection — required when useFirebase is true
  // ---------------------------------------------------------------------------

  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '', // or hardcode: 'my-project-id'
  );

  static const firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '', // or hardcode: 'AIzaSy...'
  );

  static const firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '', // or hardcode: '1:123456789:android:abc...'
  );

  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '', // or hardcode: '123456789'
  );

  static const firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '', // or hardcode: 'my-project.appspot.com'
  );
}
