import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/filament_mock.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// In-memory [FilamentDataSource] seeded with mock data.
///
/// Replace with a FirebaseFilamentDataSource (same interface) to go live.
class LocalFilamentDataSource implements FilamentDataSource {
  final List<Filament> _store = List.of(mockFilaments);

  @override
  Future<List<Filament>> fetchAll() async => List.unmodifiable(_store);

  @override
  Future<Filament> save(Filament filament) async {
    // Mirrors the Firestore behaviour: no id yet → assign one on create.
    final stored = filament.id.isEmpty
        ? filament.withId('f-${DateTime.now().millisecondsSinceEpoch}')
        : filament;

    final index = _store.indexWhere((f) => f.id == stored.id);
    if (index >= 0) {
      _store[index] = stored;
    } else {
      _store.add(stored);
    }
    return stored;
  }

  @override
  Future<void> delete(String id) async {
    _store.removeWhere((f) => f.id == id);
  }
}
