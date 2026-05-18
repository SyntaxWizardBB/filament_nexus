import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum FilamentRatingLevel { neutral, bad, semiBad, medium, semiGood, good }

extension FilamentRatingLevelColor on FilamentRatingLevel {
  Color get color => switch (this) {
    FilamentRatingLevel.neutral => AppColors.filamentNeutral,
    FilamentRatingLevel.bad => AppColors.filamentBad,
    FilamentRatingLevel.semiBad => AppColors.filamentSemiBad,
    FilamentRatingLevel.medium => AppColors.filamentMedium,
    FilamentRatingLevel.semiGood => AppColors.filamentSemiGood,
    FilamentRatingLevel.good => AppColors.filamentGood,
  };
}
