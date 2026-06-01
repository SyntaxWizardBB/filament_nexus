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
}
