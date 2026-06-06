import 'package:filament_nexus/features/filaments/domain/filament_detail.dart';
import 'package:filament_nexus/features/filaments/domain/filament_rating.dart';
import 'package:filament_nexus/features/filaments/domain/filament_type.dart';
import 'package:filament_nexus/features/filaments/domain/filament_vendor.dart';

class Filament {
  final String id;
  final String userId;
  final FilamentType type;
  final FilamentVendor vendor;
  final String name;
  final int printTempMin;
  final int printTempMax;
  final int bedTempMin;
  final int bedTempMax;
  final int printSpeedMin;
  final int printSpeedMax;
  final int fanSpeedFirstLayer;
  final int fanSpeed;
  final FilamentDetails details;
  final FilamentRatings ratings;
  final String remark;

  const Filament({
    required this.id,
    this.userId = 'default',
    required this.type,
    required this.vendor,
    required this.name,
    this.printTempMin = 0,
    this.printTempMax = 0,
    this.bedTempMin = 0,
    this.bedTempMax = 0,
    this.printSpeedMin = 0,
    this.printSpeedMax = 0,
    this.fanSpeedFirstLayer = 0,
    this.fanSpeed = 0,
    this.details = const FilamentDetails(),
    this.ratings = const FilamentRatings(),
    this.remark = '',
  });
}
