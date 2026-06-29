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
  Future<void> save(Filament filament) async {
    final index = _store.indexWhere((f) => f.id == filament.id);
    if (index >= 0) {
      _store[index] = filament;
    } else {
      _store.add(filament);
    }
  }

  @override
  Future<void> delete(String id) async {
    _store.removeWhere((f) => f.id == id);
  }
}
