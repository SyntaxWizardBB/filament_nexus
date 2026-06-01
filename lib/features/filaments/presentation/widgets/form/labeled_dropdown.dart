import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Generic dropdown rendered as a grey pill, with a rounded popup list.
class LabeledDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const LabeledDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg600,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(AppRadii.dropdownMenu),
          dropdownColor: AppColors.bg200,
          hint: Text(hint, style: Theme.of(context).textTheme.bodyMedium),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textDark),
          items: [
            for (final option in options)
              DropdownMenuItem<T>(value: option, child: Text(labelOf(option))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
