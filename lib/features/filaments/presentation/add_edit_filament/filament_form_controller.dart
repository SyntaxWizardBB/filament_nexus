import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/domain/filament_detail.dart';
import 'package:filament_nexus/features/filaments/domain/filament_property.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating_kind.dart';
import 'package:filament_nexus/features/filaments/domain/filament_type.dart';
import 'package:filament_nexus/features/filaments/domain/filament_vendor.dart';
import 'package:flutter/material.dart';

/// Holds the whole add/edit form state in one place: text controllers,
/// dropdown selections, property flags and ratings.
///
/// [FilamentFormController.fromFilament] prefills everything for the edit flow
/// (null = create). All controllers are owned here and released via [dispose].
class FilamentFormController {
  // Allgemein
  FilamentType? type;
  FilamentVendor? vendor;
  final TextEditingController name;
  final TextEditingController printTempMin;
  final TextEditingController printTempMax;
  final TextEditingController bedTempMin;
  final TextEditingController bedTempMax;
  final TextEditingController printSpeedMin;
  final TextEditingController printSpeedMax;
  final TextEditingController fanFirstLayer;
  final TextEditingController fan;

  // Details
  final TextEditingController density;
  final TextEditingController densityTolerance;
  final TextEditingController meltPoint;
  final TextEditingController glassTransition;
  final Map<FilamentProperty, bool> properties;

  // Bewertung
  final Map<FilamentRatingKind, int> ratings;
  final TextEditingController description;

  FilamentFormController.fromFilament(Filament? f)
    : type = f?.type,
      vendor = f?.vendor,
      name = TextEditingController(text: f?.name ?? ''),
      printTempMin = _intCtrl(f?.printTempMin),
      printTempMax = _intCtrl(f?.printTempMax),
      bedTempMin = _intCtrl(f?.bedTempMin),
      bedTempMax = _intCtrl(f?.bedTempMax),
      printSpeedMin = _intCtrl(f?.printSpeedMin),
      printSpeedMax = _intCtrl(f?.printSpeedMax),
      fanFirstLayer = _intCtrl(f?.fanSpeedFirstLayer),
      fan = _intCtrl(f?.fanSpeed),
      density = _doubleCtrl(f?.details.density),
      densityTolerance = _doubleCtrl(f?.details.densityTolerance),
      meltPoint = _doubleCtrl(f?.details.meltPointTemp),
      glassTransition = _doubleCtrl(f?.details.glassTransitionTemp),
      properties = {
        for (final p in FilamentProperty.values)
          p: f == null ? false : p.read(f.details),
      },
      ratings = {
        for (final r in FilamentRatingKind.values)
          r: f == null ? 0 : r.read(f.ratings),
      },
      description = TextEditingController(text: f?.description ?? '');

  List<TextEditingController> get _all => [
    name,
    printTempMin,
    printTempMax,
    bedTempMin,
    bedTempMax,
    printSpeedMin,
    printSpeedMax,
    fanFirstLayer,
    fan,
    density,
    densityTolerance,
    meltPoint,
    glassTransition,
    description,
  ];

  void dispose() {
    for (final controller in _all) {
      controller.dispose();
    }
  }

  /// All fields on the "Allgemein" tab are required for saving; the "Details"
  /// and "Bewertung" tabs are optional.
  bool get isValid =>
      type != null &&
      vendor != null &&
      name.text.trim().isNotEmpty &&
      _generalNumbers.every((c) => c.text.trim().isNotEmpty);

  List<TextEditingController> get _generalNumbers => [
    printTempMin,
    printTempMax,
    bedTempMin,
    bedTempMax,
    printSpeedMin,
    printSpeedMax,
    fanFirstLayer,
    fan,
  ];

  // Prefill with the value when editing (incl. 0), empty when creating.
  static TextEditingController _intCtrl(int? value) =>
      TextEditingController(text: value == null ? '' : value.toString());

  // Show empty for unset (0 / null) doubles, otherwise the value.
  static TextEditingController _doubleCtrl(double? value) =>
      TextEditingController(
        text: (value == null || value == 0) ? '' : _trimDouble(value),
      );

  static String _trimDouble(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  /// Builds a [Filament] from the current form state.
  /// Missing type/vendor fall back to the first option so saving never fails.
  Filament toFilament({required String id}) {
    return Filament(
      id: id,
      type: type ?? kFilamentTypes.first,
      vendor: vendor ?? kFilamentVendors.first,
      name: name.text.trim(),
      description: description.text.trim(),
      printTempMin: _int(printTempMin),
      printTempMax: _int(printTempMax),
      bedTempMin: _int(bedTempMin),
      bedTempMax: _int(bedTempMax),
      printSpeedMin: _int(printSpeedMin),
      printSpeedMax: _int(printSpeedMax),
      fanSpeedFirstLayer: _int(fanFirstLayer),
      fanSpeed: _int(fan),
      details: FilamentDetails(
        density: _double(density),
        densityTolerance: _double(densityTolerance),
        meltPointTemp: _double(meltPoint),
        glassTransitionTemp: _double(glassTransition),
        uvResistant: _flag(FilamentProperty.uvResistant),
        solventResistant: _flag(FilamentProperty.solventResistant),
        electricallyConductive: _flag(FilamentProperty.electricallyConductive),
        magnetic: _flag(FilamentProperty.magnetic),
        waterSoluble: _flag(FilamentProperty.waterSoluble),
        flexible: _flag(FilamentProperty.flexible),
        foodSafe: _flag(FilamentProperty.foodSafe),
        abrasionResistant: _flag(FilamentProperty.abrasionResistant),
        ecoFriendly: _flag(FilamentProperty.ecoFriendly),
        fireRetardant: _flag(FilamentProperty.fireRetardant),
        forLightweightBuild: _flag(FilamentProperty.forLightweightBuild),
      ),
      ratings: FilamentRatings(
        workability: _rating(FilamentRatingKind.workability),
        warping: _rating(FilamentRatingKind.warping),
        stringing: _rating(FilamentRatingKind.stringing),
        shrinking: _rating(FilamentRatingKind.shrinking),
        draftSensitivity: _rating(FilamentRatingKind.draftSensitivity),
      ),
    );
  }

  int _int(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
  double _double(TextEditingController c) =>
      double.tryParse(c.text.trim()) ?? 0;
  bool _flag(FilamentProperty p) => properties[p] ?? false;
  int _rating(FilamentRatingKind r) => ratings[r] ?? 0;
}
