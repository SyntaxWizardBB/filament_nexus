import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Compact number input used inside pill rows.
///
/// [decimal] == false restricts input to integer digits; true allows a single
/// decimal point. This prevents invalid values like "1.2.3" reaching parsing.
class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final bool decimal;

  const NumberField({super.key, required this.controller, this.decimal = false});

  static const double _width = 72;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        inputFormatters: [
          if (decimal)
            _SingleDecimalFormatter()
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.bg200,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.rounded),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// Allows only digits and at most one decimal point.
class _SingleDecimalFormatter extends TextInputFormatter {
  static final _pattern = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _pattern.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
