import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/filament_mock.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// In-memory [FilamentDataSource] seeded with mock data.
///
/// Replace with a FirebaseFilamentDataSource (same interface) to go live.
class LocalFilamentDataSource implements FilamentDataSource {
  final List<Filament> _store = List.of(mockFilaments);

  @override
  Future<FilamentPage> fetchPage({
    FilamentPageCursor? cursor,
    int limit = 20,
  }) async {
    // Simulate network latency so the paging spinner is actually visible.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final start = cursor is _OffsetCursor ? cursor.offset : 0;
    if (start >= _store.length) {
      return FilamentPage.empty;
    }

    final end = (start + limit).clamp(0, _store.length);
    return FilamentPage(
      items: List.unmodifiable(_store.sublist(start, end)),
      cursor: _OffsetCursor(end),
      hasMore: end < _store.length,
    );
  }

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

/// In-memory cursor: the index the next page starts at.
class _OffsetCursor implements FilamentPageCursor {
  final int offset;
  const _OffsetCursor(this.offset);
}
