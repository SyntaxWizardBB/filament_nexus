import 'package:filament_nexus/features/filaments/domain/filament_rating.dart';

/// The five 0-10 quality ratings of a filament, with their display labels and
/// the meaning of the low (0) and high (10) ends of the scale.
enum FilamentRatingKind {
  workability('Verarbeitbarkeit allgemein', 'schwierig', 'einfach'),
  warping('Warping (Lösen vom Druckbett)', 'viel', 'wenig'),
  stringing('Stringing (Zieht Fäden)', 'viel', 'wenig'),
  shrinking('Shrinking (Schrumpfen beim Abkühlen)', 'viel', 'wenig'),
  draftSensitivity('Empfindlichkeit bei Luftzug', 'empfindlich', 'unempfindlich');

  final String label;
  final String lowLabel;
  final String highLabel;
  const FilamentRatingKind(this.label, this.lowLabel, this.highLabel);

  /// Reads this rating's value from a [FilamentRatings] instance.
  int read(FilamentRatings r) => switch (this) {
    FilamentRatingKind.workability => r.workability,
    FilamentRatingKind.warping => r.warping,
    FilamentRatingKind.stringing => r.stringing,
    FilamentRatingKind.shrinking => r.shrinking,
    FilamentRatingKind.draftSensitivity => r.draftSensitivity,
  };
}
