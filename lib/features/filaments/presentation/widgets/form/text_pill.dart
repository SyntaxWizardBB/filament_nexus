import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Full-width grey text field (e.g. "Bezeichnung" or the multi-line
/// "Bemerkung").
class TextPill extends StatelessWidget {
  final TextEditingController controller;
  final int minLines;
  final int maxLines;

  const TextPill({
    super.key,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.bg500,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
