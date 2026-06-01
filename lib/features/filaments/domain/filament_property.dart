import 'package:filament_nexus/features/filaments/domain/filament_detail.dart';

/// The boolean material properties of a filament, with their display labels.
enum FilamentProperty {
  uvResistant('UV-Beständig'),
  solventResistant('Lösungsmittelbeständig'),
  electricallyConductive('Stromleitend'),
  magnetic('Magnetisch'),
  waterSoluble('Wasserlöslich'),
  flexible('Flexibel'),
  foodSafe('Lebensmittelecht'),
  abrasionResistant('Abriebfest'),
  ecoFriendly('Ökologisch'),
  fireRetardant('Feuerfest'),
  forLightweightBuild('Leichtbau');

  final String label;
  const FilamentProperty(this.label);

  /// Reads this property's value from a [FilamentDetails] instance.
  bool read(FilamentDetails d) => switch (this) {
    FilamentProperty.uvResistant => d.uvResistant,
    FilamentProperty.solventResistant => d.solventResistant,
    FilamentProperty.electricallyConductive => d.electricallyConductive,
    FilamentProperty.magnetic => d.magnetic,
    FilamentProperty.waterSoluble => d.waterSoluble,
    FilamentProperty.flexible => d.flexible,
    FilamentProperty.foodSafe => d.foodSafe,
    FilamentProperty.abrasionResistant => d.abrasionResistant,
    FilamentProperty.ecoFriendly => d.ecoFriendly,
    FilamentProperty.fireRetardant => d.fireRetardant,
    FilamentProperty.forLightweightBuild => d.forLightweightBuild,
  };
}
