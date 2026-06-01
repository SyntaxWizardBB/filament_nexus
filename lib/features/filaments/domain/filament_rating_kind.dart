import 'package:filament_nexus/features/filaments/domain/filament_rating.dart';

/// The five 0-10 quality ratings of a filament, with their display labels.
enum FilamentRatingKind {
  workability('Verarbeitbarkeit allgemein'),
  warping('Warping (Lösen vom Druckbett)'),
  stringing('Stringing (Zieht Fäden)'),
  shrinking('Shrinking (Schrumpfen beim Abkühlen)'),
  draftSensitivity('Empfindlichkeit bei Luftzug');

  final String label;
  const FilamentRatingKind(this.label);

  /// Reads this rating's value from a [FilamentRatings] instance.
  int read(FilamentRatings r) => switch (this) {
    FilamentRatingKind.workability => r.workability,
    FilamentRatingKind.warping => r.warping,
    FilamentRatingKind.stringing => r.stringing,
    FilamentRatingKind.shrinking => r.shrinking,
    FilamentRatingKind.draftSensitivity => r.draftSensitivity,
  };
}
