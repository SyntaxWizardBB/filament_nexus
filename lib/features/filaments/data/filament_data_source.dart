import 'package:filament_nexus/features/filaments/domain/filament.dart';

/// Contract for any filament persistence backend.
///
/// Swap the implementation injected into [FilamentRepository] to switch
/// between local mock data and a remote source (e.g. Firebase Firestore)
/// without touching a single screen.
abstract interface class FilamentDataSource {
  /// Returns one page of filaments plus the cursor for the following page.
  ///
  /// Pass [cursor] `null` for the first page; on every subsequent call pass
  /// the [FilamentPage.cursor] returned by the previous call.
  Future<FilamentPage> fetchPage({FilamentPageCursor? cursor, int limit = 20});

  /// Persists [filament] and returns it with its final id.
  ///
  /// An empty [Filament.id] means "create": the data source assigns the id
  /// (for Firestore the generated document id) and returns the stored
  /// filament. A non-empty id updates the existing entry.
  Future<Filament> save(Filament filament);

  /// Permanently removes the filament with the given [id].
  Future<void> delete(String id);
}

/// One page of filaments plus the token needed to fetch the next one.
class FilamentPage {
  final List<Filament> items;

  /// Opaque token to hand back into [FilamentDataSource.fetchPage] for the
  /// next page. `null` once the end has been reached.
  final FilamentPageCursor? cursor;

  /// `false` once the last page has been delivered — the UI stops asking
  /// for more.
  final bool hasMore;

  const FilamentPage({
    required this.items,
    required this.cursor,
    required this.hasMore,
  });

  static const empty = FilamentPage(items: [], cursor: null, hasMore: false);
}

/// Opaque pagination token. Each data source returns its own implementation
/// (a Firestore `DocumentSnapshot`, an in-memory offset, …) and receives it
/// back unchanged on the next [FilamentDataSource.fetchPage] call. The
/// repository never inspects it.
abstract interface class FilamentPageCursor {}
