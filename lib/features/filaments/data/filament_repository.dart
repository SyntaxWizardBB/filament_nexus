import 'package:filament_nexus/app/config/app_config.dart';
import 'package:filament_nexus/features/filaments/data/filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/filament_repository_exception.dart';
import 'package:filament_nexus/features/filaments/data/firebase_filament_data_source.dart';
import 'package:filament_nexus/features/filaments/data/local_filament_data_source.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:flutter/foundation.dart';

/// Reactive cache in front of a [FilamentDataSource].
///
/// Screens subscribe via [ListenableBuilder] and are rebuilt whenever the
/// list changes. The backing source is picked by [AppConfig.useFirebase] and
/// is swappable without touching any screen.
///
/// ## Paging
/// Filaments are fetched one page at a time. [load] pulls the first page;
/// [loadMore] appends the next one and is driven by the list scrolling near
/// its end. Both feed the single shared [filaments] list that every screen
/// renders — screen-side search and filters still operate on whatever has
/// been loaded so far.
///
/// Typical startup sequence:
///   1. App boots → [FilamentRepository.instance] is created (empty list).
///   2. Root widget calls [load()] once to populate the first page.
///   3. Scrolling triggers [loadMore()]; [save]/[delete] keep the cache in sync.
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

  /// How many filaments are fetched per page.
  static const int pageSize = 20;

  final FilamentDataSource _dataSource;
  List<Filament> _filaments = const [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _loadError;
  String? _loadMoreError;
  FilamentPageCursor? _cursor;
  bool _hasMore = true;

  List<Filament> get filaments => List.unmodifiable(_filaments);

  /// True while the initial page is loading — screens show a full-screen spinner.
  bool get isLoading => _isLoading;

  /// True while a follow-up page is loading — the list shows a footer spinner.
  bool get isLoadingMore => _isLoadingMore;

  /// True while there is at least one more page to fetch.
  bool get hasMore => _hasMore;

  /// Set when the initial page failed (e.g. missing permissions).
  String? get loadError => _loadError;

  /// Set when fetching a follow-up page failed — the list offers a retry.
  String? get loadMoreError => _loadMoreError;

  /// Fetches the first page and rebuilds subscribers.
  /// Call once at app startup; re-call to refresh from the top.
  Future<void> load() async {
    _isLoading = true;
    _loadError = null;
    _loadMoreError = null;
    _cursor = null;
    _hasMore = true;
    notifyListeners();
    try {
      final page = await _dataSource.fetchPage(limit: pageSize);
      _filaments = page.items;
      _cursor = page.cursor;
      _hasMore = page.hasMore;
    } catch (e) {
      _loadError = 'Filamente konnten nicht geladen werden.';
      _filaments = const [];
      _hasMore = false;
      debugPrint('Loading filaments failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches the next page and appends it to [filaments].
  /// No-op while the first page loads, another page is in flight, or the end
  /// has been reached.
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();
    try {
      final page = await _dataSource.fetchPage(cursor: _cursor, limit: pageSize);
      _filaments = [..._filaments, ...page.items];
      _cursor = page.cursor;
      _hasMore = page.hasMore;
    } catch (e) {
      // Not a full-screen error — the already loaded list stays usable and the
      // footer shows a retry button.
      _loadMoreError = 'Weitere Filamente konnten nicht geladen werden.';
      debugPrint('Loading more filaments failed: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Adds a new filament (empty id) or replaces an existing one.
  /// Returns the stored filament, which carries the final id after a create.
  ///
  /// Throws [FilamentRepositoryException] if the data source write fails; the
  /// cache is left untouched in that case.
  Future<Filament> save(Filament filament) async {
    final Filament stored;
    try {
      stored = await _dataSource.save(filament);
    } catch (e, s) {
      debugPrint('Saving filament failed: $e\n$s');
      throw FilamentRepositoryException(
        filament.id.isEmpty
            ? 'Filament konnte nicht gespeichert werden.'
            : 'Änderungen konnten nicht gespeichert werden.',
      );
    }

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
  ///
  /// Throws [FilamentRepositoryException] if the data source delete fails; the
  /// cache is left untouched in that case.
  Future<void> delete(String id) async {
    try {
      await _dataSource.delete(id);
    } catch (e, s) {
      debugPrint('Deleting filament failed: $e\n$s');
      throw const FilamentRepositoryException(
        'Filament konnte nicht gelöscht werden.',
      );
    }
    _filaments = _filaments.where((f) => f.id != id).toList();
    notifyListeners();
  }
}
