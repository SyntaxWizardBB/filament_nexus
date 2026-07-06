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
  Future<void> save(Filament filament) async {
    await _db.collection(_collection).doc(filament.id).set(filament.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
