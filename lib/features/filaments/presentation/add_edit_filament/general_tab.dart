import 'package:filament_nexus/features/filaments/domain/filament_type.dart';
import 'package:filament_nexus/features/filaments/domain/filament_vendor.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/filament_form_controller.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/labeled_dropdown.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/number_field.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/pill_row.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/range_input.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/text_pill.dart';
import 'package:flutter/material.dart';

/// Tab "Allgemein": type/vendor dropdowns, name, temperature/speed ranges and
/// fan speeds.
class GeneralTab extends StatelessWidget {
  final FilamentFormController form;
  final ValueChanged<FilamentType?> onTypeChanged;
  final ValueChanged<FilamentVendor?> onVendorChanged;

  const GeneralTab({
    super.key,
    required this.form,
    required this.onTypeChanged,
    required this.onVendorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: LabeledDropdown<FilamentType>(
                hint: 'Typ',
                value: form.type,
                options: kFilamentTypes,
                labelOf: (t) => t.name,
                onChanged: onTypeChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledDropdown<FilamentVendor>(
                hint: 'Hersteller',
                value: form.vendor,
                options: kFilamentVendors,
                labelOf: (v) => v.name,
                onChanged: onVendorChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const FieldLabel('Bezeichnung'),
        const SizedBox(height: 6),
        TextPill(controller: form.name),
        const SizedBox(height: 12),
        PillRow(
          label: 'Drucktemperatur',
          child: RangeInput(first: form.printTempMin, second: form.printTempMax),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Bett-Temperatur',
          child: RangeInput(first: form.bedTempMin, second: form.bedTempMax),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Druckgesch. [mm/s]',
          child: RangeInput(
            first: form.printSpeedMin,
            second: form.printSpeedMax,
          ),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Lüfter Layer 1 [%]',
          child: NumberField(controller: form.fanFirstLayer),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Lüfter ab Layer 2 [%]',
          child: NumberField(controller: form.fan),
        ),
      ],
    );
  }
}
