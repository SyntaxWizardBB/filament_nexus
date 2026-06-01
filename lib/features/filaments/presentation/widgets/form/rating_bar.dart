import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// A 0-10 selector drawn as ten tappable segments.
/// Segments up to [value] are filled; tapping the current value clears one.
class RatingBar extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const RatingBar({super.key, required this.value, required this.onChanged});

  static const int _segments = 10;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= _segments; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value == i ? i - 1 : i),
              child: Container(
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: i <= value ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.rating),
                  border: Border.all(
                    color: i <= value
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
