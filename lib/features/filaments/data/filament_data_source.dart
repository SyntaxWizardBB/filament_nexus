import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Contract for any filament persistence backend.
///
/// Swap the implementation injected into [FilamentRepository] to switch
/// between local mock data and a remote source (e.g. Firebase Firestore)
/// without touching a single screen.
abstract interface class FilamentDataSource {
  /// Returns all stored filaments.
  Future<List<Filament>> fetchAll();

  /// Persists [filament], inserting or replacing by id.
  Future<void> save(Filament filament);

  /// Permanently removes the filament with the given [id].
  Future<void> delete(String id);
}
