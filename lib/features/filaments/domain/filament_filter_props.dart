import 'package:filament_nexus/features/filaments/domain/filament.dart';

class FilamentPropertyOption {
  final String key;
  final String label;

  const FilamentPropertyOption({required this.key, required this.label});
}

final allPropertyOptions = <FilamentPropertyOption>[
  FilamentPropertyOption(key: 'uvResistant', label: 'UV-beständig'),
  FilamentPropertyOption(key: 'solventResistant', label: 'Lösungsmittel'),
  FilamentPropertyOption(key: 'electricallyConductive', label: 'Leitfähig'),
  FilamentPropertyOption(key: 'magnetic', label: 'Magnetisch'),
  FilamentPropertyOption(key: 'waterSoluble', label: 'Wasserlöslich'),
  FilamentPropertyOption(key: 'fexible', label: 'Flexibel'),
  FilamentPropertyOption(key: 'foodSafe', label: 'Lebensmittelecht'),
  FilamentPropertyOption(key: 'abrasionResistant', label: 'Abriebfest'),
  FilamentPropertyOption(key: 'ecoFriendly', label: 'Ökologisch'),
  FilamentPropertyOption(key: 'fireRetardant', label: 'Flammhemmend'),
  FilamentPropertyOption(key: 'forLightweightBuild', label: 'Leichtbau'),
];

bool hasProperty(Filament filament, String key) {
  final details = filament.details;

  switch (key) {
    case 'uvResistant':
      return details.uvResistant;
    case 'solventResistant':
      return details.solventResistant;
    case 'electricallyConductive':
      return details.electricallyConductive;
    case 'magnetic':
      return details.magnetic;
    case 'waterSoluble':
      return details.waterSoluble;
    case 'fexible':
      return details.fexible;
    case 'foodSafe':
      return details.foodSafe;
    case 'abrasionResistant':
      return details.abrasionResistant;
    case 'ecoFriendly':
      return details.ecoFriendly;
    case 'fireRetardant':
      return details.fireRetardant;
    case 'forLightweightBuild':
      return details.forLightweightBuild;
    default:
      return false;
  }
}
