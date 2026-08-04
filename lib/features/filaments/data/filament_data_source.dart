import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Contract for any filament persistence backend.
///
/// Swap the implementation injected into [FilamentRepository] to switch
/// between local mock data and a remote source (e.g. Firebase Firestore)
/// without touching a single screen.
abstract interface class FilamentDataSource {
  /// Returns all stored filaments.
  Future<List<Filament>> fetchAll();

  /// Persists [filament] and returns it with its final id.
  ///
  /// An empty [Filament.id] means "create": the data source assigns the id
  /// (for Firestore the generated document id) and returns the stored
  /// filament. A non-empty id updates the existing entry.
  Future<Filament> save(Filament filament);

  /// Permanently removes the filament with the given [id].
  Future<void> delete(String id);
}
