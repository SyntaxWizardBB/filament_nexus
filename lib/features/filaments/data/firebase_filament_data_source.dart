import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Firestore-backed [FilamentDataSource].
///
/// ## One-time setup (when Firebase is ready)
///
/// 1. Add packages to pubspec.yaml:
///      firebase_core: ^3.x.x
///      cloud_firestore: ^5.x.x
///
/// 2. Configure Firebase:
///      dart pub global activate flutterfire_cli
///      flutterfire configure
///    → generates lib/firebase_options.dart
///
/// 3. Initialize Firebase in main.dart before runApp():
///      await Firebase.initializeApp(
///        options: DefaultFirebaseOptions.currentPlatform,
///      );
///
/// ## Firestore data layout
///   filaments/{filamentId}  →  Filament as a flat JSON document
///
/// Once [Filament.toJson] / [Filament.fromJson] are implemented,
/// uncomment the TODOs below.
class FirebaseFilamentDataSource implements FilamentDataSource {
  // TODO: uncomment once firebase_core + cloud_firestore are in pubspec.yaml:
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _collection = 'filaments';

  @override
  Future<List<Filament>> fetchAll() async {
    // TODO: implement
    // final snapshot = await _db.collection(_collection).get();
    // return snapshot.docs
    //     .map((doc) => Filament.fromJson(doc.id, doc.data()))
    //     .toList();
    throw UnimplementedError('$runtimeType.fetchAll (collection: $_collection) — Firebase not yet set up.');
  }

  @override
  Future<void> save(Filament filament) async {
    // TODO: implement
    // await _db
    //     .collection(_collection)
    //     .doc(filament.id)
    //     .set(filament.toJson());
    throw UnimplementedError('$runtimeType.save (collection: $_collection) — Firebase not yet set up.');
  }

  @override
  Future<void> delete(String id) async {
    // TODO: implement
    // await _db.collection(_collection).doc(id).delete();
    throw UnimplementedError('$runtimeType.delete (collection: $_collection) — Firebase not yet set up.');
  }
}
