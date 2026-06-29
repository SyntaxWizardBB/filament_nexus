import 'package:filament_nexus/features/filaments/data/filament_mock.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:flutter/foundation.dart';

/// In-memory store for filaments, seeded with the mock data.
///
/// Single source of truth: screens listen to it and rebuild on changes.
/// No database/API — sufficient for the mock-data scope of this app.
class FilamentRepository extends ChangeNotifier {
  FilamentRepository._() : _filaments = List.of(mockFilaments);

  static final FilamentRepository instance = FilamentRepository._();

  final List<Filament> _filaments;

  List<Filament> get filaments => List.unmodifiable(_filaments);

  /// Adds a new filament or replaces an existing one with the same id.
  void save(Filament filament) {
    final index = _filaments.indexWhere((f) => f.id == filament.id);
    if (index >= 0) {
      _filaments[index] = filament;
    } else {
      _filaments.add(filament);
    }
    notifyListeners();
  }

  /// Removes the filament with the given [id]. No-op if not found.
  void delete(String id) {
    _filaments.removeWhere((f) => f.id == id);
    notifyListeners();
  }
}
