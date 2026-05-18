import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/domain/filament_filter_props.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class MyFilamentsScreen extends StatefulWidget {
  const MyFilamentsScreen({super.key});

  @override
  State<MyFilamentsScreen> createState() => _MyFilamentsScreenState();
}

class _MyFilamentsScreenState extends State<MyFilamentsScreen> {
  final filamentList = mockFilaments;
  Set<String> _selectedMaterials = <String>{};
  Set<String> _selectedProperties = <String>{};

  List<String> get _materialOptions {
    final options = filamentList.map((filament) => filament.type.name).toSet();
    final sorted = options.toList()..sort();
    return sorted;
  }

  List<FilamentPropertyOption> get _propertyOptions {
    return allPropertyOptions
        .where(
          (option) => filamentList.any(
            (filament) => _hasProperty(filament, option.key),
          ),
        )
        .toList();
  }

  List<Filament> get _filteredFilaments {
    return filamentList.where((filament) {
      if (_selectedMaterials.isNotEmpty &&
          !_selectedMaterials.contains(filament.type.name)) {
        return false;
      }

      if (_selectedProperties.isNotEmpty &&
          !_selectedProperties.any((key) => _hasProperty(filament, key))) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _hasProperty(Filament filament, String key) {
    final details = filament.details;

    switch (key) {
      case 'uvResistant':
        return details.uvResistant;
      case 'solventResistant':
        return details.solventResistant;
      case 'electricallyConductive':
        return details.electricallyConductive;
      case 'magnetic':
        return details.magnetic;
      case 'waterSoluble':
        return details.waterSoluble;
      case 'fexible':
        return details.fexible;
      case 'foodSafe':
        return details.foodSafe;
      case 'abrasionResistant':
        return details.abrasionResistant;
      case 'ecoFriendly':
        return details.ecoFriendly;
      case 'fireRetardant':
        return details.fireRetardant;
      case 'forLightweightBuild':
        return details.forLightweightBuild;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilamentFilter(
          materialOptions: _materialOptions,
          selectedMaterials: _selectedMaterials,
          onMaterialsChanged: (value) =>
              setState(() => _selectedMaterials = value),
          propertyOptions: _propertyOptions,
          selectedProperties: _selectedProperties,
          onPropertiesChanged: (value) =>
              setState(() => _selectedProperties = value),
        ),
        Expanded(child: FilamentList(filaments: _filteredFilaments)),
      ],
    );
  }
}
