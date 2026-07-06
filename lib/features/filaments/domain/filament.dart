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
  final String description;

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
    this.description = '',
  });

  /// Serializes to a Firestore document map. [id] is stored as the document id,
  /// so it is intentionally not part of the map.
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'type': type.toJson(),
    'vendor': vendor.toJson(),
    'name': name,
    'description': description,
    'printTempMin': printTempMin,
    'printTempMax': printTempMax,
    'bedTempMin': bedTempMin,
    'bedTempMax': bedTempMax,
    'printSpeedMin': printSpeedMin,
    'printSpeedMax': printSpeedMax,
    'fanSpeedFirstLayer': fanSpeedFirstLayer,
    'fanSpeed': fanSpeed,
    'details': details.toJson(),
    'ratings': ratings.toJson(),
  };

  factory Filament.fromJson(String id, Map<String, dynamic> json) {
    Map<String, dynamic> nested(String key) =>
        Map<String, dynamic>.from(json[key] as Map? ?? const {});
    int intOf(String key) => (json[key] as num?)?.toInt() ?? 0;

    return Filament(
      id: id,
      userId: json['userId'] as String? ?? 'default',
      type: FilamentType.fromJson(nested('type')),
      vendor: FilamentVendor.fromJson(nested('vendor')),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      printTempMin: intOf('printTempMin'),
      printTempMax: intOf('printTempMax'),
      bedTempMin: intOf('bedTempMin'),
      bedTempMax: intOf('bedTempMax'),
      printSpeedMin: intOf('printSpeedMin'),
      printSpeedMax: intOf('printSpeedMax'),
      fanSpeedFirstLayer: intOf('fanSpeedFirstLayer'),
      fanSpeed: intOf('fanSpeed'),
      details: FilamentDetails.fromJson(nested('details')),
      ratings: FilamentRatings.fromJson(nested('ratings')),
    );
  }
}
