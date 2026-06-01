import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FilamentRating extends StatelessWidget {
  const FilamentRating({super.key, required this.name, required this.rating});

  final String name;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
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
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
