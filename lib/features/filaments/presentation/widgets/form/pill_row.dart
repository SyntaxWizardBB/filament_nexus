import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Rounded grey row with a label on the left and the input(s) on the right.
class PillRow extends StatelessWidget {
  final String label;
  final Widget child;

  const PillRow({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg500,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          child,
        ],
      ),
    );
  }
}

/// Small left-aligned field label (e.g. above a full-width field).
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
