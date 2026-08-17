import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:flutter/material.dart';

class FilamentRating extends StatelessWidget {
  const FilamentRating({
    super.key,
    required this.name,
    required this.rating,
    required this.lowLabel,
    required this.highLabel,
  });

  final String name;
  final int rating;
  final String lowLabel;
  final String highLabel;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: AppColors.textLight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lowLabel, style: labelStyle),
            Text(highLabel, style: labelStyle),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: List.generate(10, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RatingDot(isFilled: index < rating),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class RatingDot extends StatelessWidget {
  const RatingDot({super.key, required this.isFilled});

  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary : Colors.transparent,
        border: isFilled ? null : Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
    );
  }
}
