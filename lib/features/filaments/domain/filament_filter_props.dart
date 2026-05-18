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