import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Firestore-backed [FilamentDataSource].
///
/// Firebase itself is already wired up (firebase_core + cloud_firestore in
/// pubspec, `firebase_options.dart` generated, initialized in `main.dart`).
/// What is still missing to go live:
///   1. `Filament.toJson` / `Filament.fromJson`
///   2. the Firestore calls below (a reference implementation is kept as
///      comments)
///
/// Data layout: `filaments/{filamentId}` → Filament as a flat JSON document.
/// Selected via `--dart-define=USE_FIREBASE=true` (see [AppConfig]).
class FirebaseFilamentDataSource implements FilamentDataSource {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _collection = 'filaments';

  @override
  Future<List<Filament>> fetchAll() async {
    // final snapshot = await _db.collection(_collection).get();
    // return snapshot.docs
    //     .map((doc) => Filament.fromJson(doc.id, doc.data()))
    //     .toList();
    throw UnimplementedError(
      'FirebaseFilamentDataSource.fetchAll is not implemented yet '
      '(collection: $_collection).',
    );
  }

  @override
  Future<void> save(Filament filament) async {
    // await _db.collection(_collection).doc(filament.id).set(filament.toJson());
    throw UnimplementedError(
      'FirebaseFilamentDataSource.save is not implemented yet '
      '(collection: $_collection).',
    );
  }

  @override
  Future<void> delete(String id) async {
    // await _db.collection(_collection).doc(id).delete();
    throw UnimplementedError(
      'FirebaseFilamentDataSource.delete is not implemented yet '
      '(collection: $_collection).',
    );
  }
}
