import 'package:filament_nexus/features/filaments/presentation/widgets/form/number_field.dart';
import 'package:flutter/material.dart';

/// Two number fields separated by a symbol — "min – max" for ranges, or
/// "value ± tolerance" via [separator].
class RangeInput extends StatelessWidget {
  final TextEditingController first;
  final TextEditingController second;
  final String separator;
  final bool decimal;

  const RangeInput({
    super.key,
    required this.first,
    required this.second,
    this.separator = '–',
    this.decimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NumberField(controller: first, decimal: decimal),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(separator, style: const TextStyle(fontSize: 18)),
        ),
        NumberField(controller: second, decimal: decimal),
      ],
    );
  }
}
