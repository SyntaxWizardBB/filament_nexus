import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Firestore-backed [FilamentDataSource].
///
/// Data layout: `filaments/{filamentId}` → Filament as a flat JSON document
/// (the document id is the filament id). Selected via [AppConfig.useFirebase].
class FirebaseFilamentDataSource implements FilamentDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _collection = 'filaments';

  @override
  Future<List<Filament>> fetchAll() async {
    final snapshot = await _db.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Filament.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Filament> save(Filament filament) async {
    final collection = _db.collection(_collection);

    // No id yet → create with add(); Firestore generates the document id.
    if (filament.id.isEmpty) {
      final docRef = await collection.add(filament.toJson());
      return filament.withId(docRef.id);
    }

    // Existing id → update that very document.
    await collection.doc(filament.id).update(filament.toJson());
    return filament;
  }

  @override
  Future<void> delete(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
