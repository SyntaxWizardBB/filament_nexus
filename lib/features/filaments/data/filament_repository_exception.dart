/// Thrown by [FilamentRepository] when a write to the data source fails
/// (save, update or delete).
///
/// [message] is user-facing German text, ready to drop into a SnackBar.
class FilamentRepositoryException implements Exception {
  final String message;

  const FilamentRepositoryException(this.message);

  @override
  String toString() => 'FilamentRepositoryException: $message';
}
