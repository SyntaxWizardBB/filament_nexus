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
  bool _isLoading = true;
  String? _loadError;

  List<Filament> get filaments => List.unmodifiable(_filaments);

  /// True while the initial fetch is running — screens show a spinner.
  bool get isLoading => _isLoading;

  /// Set when the initial fetch failed (e.g. missing permissions).
  String? get loadError => _loadError;

  /// Fetches all filaments from the data source and rebuilds subscribers.
  /// Call once at app startup; re-call after switching data sources.
  Future<void> load() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _filaments = await _dataSource.fetchAll();
    } catch (e) {
      _loadError = 'Filamente konnten nicht geladen werden.';
      _filaments = const [];
      debugPrint('Loading filaments failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new filament (empty id) or replaces an existing one.
  /// Returns the stored filament, which carries the final id after a create.
  Future<Filament> save(Filament filament) async {
    final stored = await _dataSource.save(filament);
    final updated = List.of(_filaments);
    final index = updated.indexWhere((f) => f.id == stored.id);
    if (index >= 0) {
      updated[index] = stored;
    } else {
      updated.add(stored);
    }
    _filaments = updated;
    notifyListeners();
    return stored;
  }

  /// Removes the filament with the given [id]. No-op if not found.
  Future<void> delete(String id) async {
    await _dataSource.delete(id);
    _filaments = _filaments.where((f) => f.id != id).toList();
    notifyListeners();
  }
}
