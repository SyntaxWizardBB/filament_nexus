import 'package:filament_nexus/features/filaments/domain/filament_property.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament/filament_form_controller.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/check_row.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/number_field.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/pill_row.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/form/range_input.dart';
import 'package:flutter/material.dart';

/// Tab "Details": density (value ± tolerance), melt point, glass transition
/// and the 11 boolean material properties.
class DetailsTab extends StatelessWidget {
  final FilamentFormController form;
  final void Function(FilamentProperty, bool) onPropertyChanged;

  const DetailsTab({
    super.key,
    required this.form,
    required this.onPropertyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PillRow(
          label: 'Dichte [g/cm³]',
          child: RangeInput(
            first: form.density,
            second: form.densityTolerance,
            separator: '±',
            decimal: true,
          ),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Schmelzpunkt [°C]',
          child: NumberField(controller: form.meltPoint, decimal: true),
        ),
        const SizedBox(height: 12),
        PillRow(
          label: 'Glasübergang [°C]',
          child: NumberField(controller: form.glassTransition, decimal: true),
        ),
        const SizedBox(height: 8),
        for (final property in FilamentProperty.values)
          CheckRow(
            label: property.label,
            value: form.properties[property] ?? false,
            onChanged: (v) => onPropertyChanged(property, v),
          ),
      ],
    );
  }
}
