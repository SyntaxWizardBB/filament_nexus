class FilamentDetails {
  final double density;
  final double densityTolerance;
  final double meltPointTemp;
  final double glassTransitionTemp;
  final bool uvResistant;
  final bool solventResistant;
  final bool electricallyConductive;
  final bool magnetic;
  final bool waterSoluble;
  final bool flexible;
  final bool foodSafe;
  final bool abrasionResistant;
  final bool ecoFriendly;
  final bool fireRetardant;
  final bool forLightweightBuild;

  const FilamentDetails({
    this.density = 0.0,
    this.densityTolerance = 0.0,
    this.meltPointTemp = 0.0,
    this.glassTransitionTemp = 0.0,
    this.uvResistant = false,
    this.solventResistant = false,
    this.electricallyConductive = false,
    this.magnetic = false,
    this.waterSoluble = false,
    this.flexible = false,
    this.foodSafe = false,
    this.abrasionResistant = false,
    this.ecoFriendly = false,
    this.fireRetardant = false,
    this.forLightweightBuild = false,
  });

  Map<String, dynamic> toJson() => {
    'density': density,
    'densityTolerance': densityTolerance,
    'meltPointTemp': meltPointTemp,
    'glassTransitionTemp': glassTransitionTemp,
    'uvResistant': uvResistant,
    'solventResistant': solventResistant,
    'electricallyConductive': electricallyConductive,
    'magnetic': magnetic,
    'waterSoluble': waterSoluble,
    'flexible': flexible,
    'foodSafe': foodSafe,
    'abrasionResistant': abrasionResistant,
    'ecoFriendly': ecoFriendly,
    'fireRetardant': fireRetardant,
    'forLightweightBuild': forLightweightBuild,
  };

  factory FilamentDetails.fromJson(Map<String, dynamic> json) =>
      FilamentDetails(
        density: (json['density'] as num?)?.toDouble() ?? 0,
        densityTolerance: (json['densityTolerance'] as num?)?.toDouble() ?? 0,
        meltPointTemp: (json['meltPointTemp'] as num?)?.toDouble() ?? 0,
        glassTransitionTemp:
            (json['glassTransitionTemp'] as num?)?.toDouble() ?? 0,
        uvResistant: json['uvResistant'] as bool? ?? false,
        solventResistant: json['solventResistant'] as bool? ?? false,
        electricallyConductive: json['electricallyConductive'] as bool? ?? false,
        magnetic: json['magnetic'] as bool? ?? false,
        waterSoluble: json['waterSoluble'] as bool? ?? false,
        flexible: json['flexible'] as bool? ?? false,
        foodSafe: json['foodSafe'] as bool? ?? false,
        abrasionResistant: json['abrasionResistant'] as bool? ?? false,
        ecoFriendly: json['ecoFriendly'] as bool? ?? false,
        fireRetardant: json['fireRetardant'] as bool? ?? false,
        forLightweightBuild: json['forLightweightBuild'] as bool? ?? false,
      );
}
