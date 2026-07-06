import 'package:filament_nexus/features/filaments/domain/filament_rating_level.dart';

class FilamentRatings {
  final int workability;
  final int warping;
  final int stringing;
  final int shrinking;
  final int draftSensitivity;

  const FilamentRatings({
    this.workability = 0,
    this.warping = 0,
    this.stringing = 0,
    this.shrinking = 0,
    this.draftSensitivity = 0,
  });

  Map<String, dynamic> toJson() => {
    'workability': workability,
    'warping': warping,
    'stringing': stringing,
    'shrinking': shrinking,
    'draftSensitivity': draftSensitivity,
  };

  factory FilamentRatings.fromJson(Map<String, dynamic> json) => FilamentRatings(
    workability: (json['workability'] as num?)?.toInt() ?? 0,
    warping: (json['warping'] as num?)?.toInt() ?? 0,
    stringing: (json['stringing'] as num?)?.toInt() ?? 0,
    shrinking: (json['shrinking'] as num?)?.toInt() ?? 0,
    draftSensitivity: (json['draftSensitivity'] as num?)?.toInt() ?? 0,
  );

  FilamentRatingLevel get level {
    final scored = [
      workability,
      warping,
      stringing,
      shrinking,
      draftSensitivity,
    ].where((r) => r > 0).toList();

    if (scored.isEmpty) return FilamentRatingLevel.neutral;

    final avg = scored.reduce((a, b) => a + b) / scored.length;

    if (avg < 3)return FilamentRatingLevel.bad;
    if (avg < 5)return FilamentRatingLevel.semiBad;
    if (avg < 7) return FilamentRatingLevel.medium;
    if (avg < 9)return FilamentRatingLevel.semiGood;
    return FilamentRatingLevel.good;
  }
}
