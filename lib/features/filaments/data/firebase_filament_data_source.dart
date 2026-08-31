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
  Future<FilamentPage> fetchPage({
    FilamentPageCursor? cursor,
    int limit = 20,
  }) async {
    // Ordering by the document id needs no composite index and gives a stable,
    // total order to page through.
    Query<Map<String, dynamic>> query = _db
        .collection(_collection)
        .orderBy(FieldPath.documentId)
        .limit(limit);

    if (cursor is _SnapshotCursor) {
      query = query.startAfterDocument(cursor.doc);
    }

    final snapshot = await query.get();
    final docs = snapshot.docs;

    return FilamentPage(
      items: docs
          .map((doc) => Filament.fromJson(doc.id, doc.data()))
          .toList(),
      // A short page means we hit the end — keep the old cursor, it is unused.
      cursor: docs.isEmpty ? cursor : _SnapshotCursor(docs.last),
      hasMore: docs.length == limit,
    );
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

/// Firestore cursor: wraps the last document of the previous page so the next
/// query can resume with `startAfterDocument`.
class _SnapshotCursor implements FilamentPageCursor {
  final DocumentSnapshot<Map<String, dynamic>> doc;
  const _SnapshotCursor(this.doc);
}
