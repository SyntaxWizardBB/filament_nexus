class FilamentDetails {
  final double densityTemp;
  final double meltPointTemp;
  final double glassTransitionTemp;
  final bool uvResistant;
  final bool solventResistant;
  final bool electricallyConductive;
  final bool magnetic;
  final bool waterSoluble;
  final bool fexible;
  final bool foodSafe;
  final bool abrasionResistant;
  final bool ecoFriendly;
  final bool fireRetardant;
  final bool forLightweightBuild;

  const FilamentDetails({
    this.densityTemp = 0.0,
    this.meltPointTemp = 0.0,
    this.glassTransitionTemp = 0.0,
    this.uvResistant = false,
    this.solventResistant = false,
    this.electricallyConductive = false,
    this.magnetic = false,
    this.waterSoluble = false,
    this.fexible = false,
    this.foodSafe = false,
    this.abrasionResistant = false,
    this.ecoFriendly = false,
    this.fireRetardant = false,
    this.forLightweightBuild = false,
  });
}
