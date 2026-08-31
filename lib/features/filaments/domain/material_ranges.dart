/// Plausible operating windows per filament material, used for input
/// plausibility checks (catching typos like "PLA at 320 °C").
///
/// The windows are intentionally *generous* — wider than the typical
/// sweet-spot — so legitimate values pass and only clearly implausible
/// entries are rejected. Source: Recherche.MD (manufacturer TDS + community
/// consensus), keyed by [FilamentType.name].
class MaterialRange {
  final int min;
  final int max;

  const MaterialRange(this.min, this.max);

  bool contains(int value) => value >= min && value <= max;
}

class MaterialRanges {
  final MaterialRange nozzle; // print/nozzle temperature (°C)
  final MaterialRange bed; // heated bed temperature (°C)

  const MaterialRanges({required this.nozzle, required this.bed});
}

/// Material-independent fallback bounds when the material is unknown.
const MaterialRanges kFallbackRanges = MaterialRanges(
  nozzle: MaterialRange(150, 500),
  bed: MaterialRange(0, 150),
);

const Map<String, MaterialRanges> kMaterialRanges = {
  'PLA': MaterialRanges(nozzle: MaterialRange(160, 240), bed: MaterialRange(0, 70)),
  'PETG': MaterialRanges(nozzle: MaterialRange(200, 270), bed: MaterialRange(0, 120)),
  'ABS': MaterialRanges(nozzle: MaterialRange(210, 280), bed: MaterialRange(0, 120)),
  'TPU': MaterialRanges(nozzle: MaterialRange(190, 250), bed: MaterialRange(0, 70)),
  'ASA': MaterialRanges(nozzle: MaterialRange(220, 280), bed: MaterialRange(0, 120)),
  'PC': MaterialRanges(nozzle: MaterialRange(240, 320), bed: MaterialRange(0, 130)),
  'PA-CF': MaterialRanges(nozzle: MaterialRange(240, 320), bed: MaterialRange(0, 110)),
};

/// Returns the plausibility window for [materialName], or the fallback bounds.
MaterialRanges materialRangesFor(String? materialName) =>
    kMaterialRanges[materialName] ?? kFallbackRanges;
