import 'package:filament_nexus/app/config/app_config.dart';
import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/firebase_filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/local_filament_data_source.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:flutter/foundation.dart';

/// Reactive cache in front of a [FilamentDataSource].
///
/// Screens subscribe via [ListenableBuilder] and are rebuilt whenever the
/// list changes. The backing source (local mock today, Firebase tomorrow) is
/// swappable without touching any screen.
///
/// Typical startup sequence:
///   1. App boots → [FilamentRepository.instance] is created (empty list).
///   2. Root widget calls [load()] once to populate from the data source.
///   3. Subsequent [save]/[delete] calls keep the cache in sync optimistically.
class FilamentRepository extends ChangeNotifier {
  FilamentRepository._({FilamentDataSource? dataSource})
      : _dataSource = dataSource ?? _defaultDataSource();

  static FilamentDataSource _defaultDataSource() {
    if (AppConfig.useFirebase) {
      return FirebaseFilamentDataSource();
    }
    return LocalFilamentDataSource();
  }

  static final FilamentRepository instance = FilamentRepository._();

  final FilamentDataSource _dataSource;
  List<Filament> _filaments = const [];

  List<Filament> get filaments => List.unmodifiable(_filaments);

  /// Fetches all filaments from the data source and rebuilds subscribers.
  /// Call once at app startup; re-call after switching data sources.
  Future<void> load() async {
    _filaments = await _dataSource.fetchAll();
    notifyListeners();
  }

  /// Adds a new filament or replaces an existing one with the same id.
  Future<void> save(Filament filament) async {
    await _dataSource.save(filament);
    final updated = List.of(_filaments);
    final index = updated.indexWhere((f) => f.id == filament.id);
    if (index >= 0) {
      updated[index] = filament;
    } else {
      updated.add(filament);
    }
    _filaments = updated;
    notifyListeners();
  }

  /// Removes the filament with the given [id]. No-op if not found.
  Future<void> delete(String id) async {
    await _dataSource.delete(id);
    _filaments = _filaments.where((f) => f.id != id).toList();
    notifyListeners();
  }
}
