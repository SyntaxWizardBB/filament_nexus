import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/features/filaments/domain/filament.dart';
import 'package:filament_nexus/features/filaments/domain/filament_filter_props.dart';
import 'package:filament_nexus/features/filaments/presentation/filament_detail.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class AllFilamentsScreen extends StatefulWidget {
  const AllFilamentsScreen({super.key});

  @override
  State<AllFilamentsScreen> createState() => _AllFilamentsScreenState();
}

class _AllFilamentsScreenState extends State<AllFilamentsScreen> {
  final FilamentRepository _repository = FilamentRepository.instance;
  Set<String> _selectedMaterials = <String>{};
  Set<String> _selectedProperties = <String>{};
  String _query = '';

  List<String> get _materialOptions {
    final options = _repository.filaments
        .map((filament) => filament.type.name)
        .toSet();
    final sorted = options.toList()..sort();
    return sorted;
  }

  List<FilamentPropertyOption> get _propertyOptions {
    return allPropertyOptions
        .where(
          (option) => _repository.filaments.any(
            (filament) => hasProperty(filament, option.key),
          ),
        )
        .toList();
  }

  List<Filament> get _filteredFilaments {
    return _repository.filaments.where((filament) {
      if (!matchesQuery(filament, _query)) {
        return false;
      }

      if (_selectedMaterials.isNotEmpty &&
          !_selectedMaterials.contains(filament.type.name)) {
        return false;
      }

      if (_selectedProperties.isNotEmpty &&
          !_selectedProperties.any((key) => hasProperty(filament, key))) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _repository,
      builder: (context, _) {
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
              onSearchChanged: (value) => setState(() => _query = value),
            ),
            Expanded(
              child: FilamentList(
                filaments: _filteredFilaments,
                isLoading: _repository.isLoading,
                error: _repository.loadError,
                emptyMessage: 'Keine Filamente gefunden.',
                onTap: (filament) => _openDetails(context, filament),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetails(BuildContext context, Filament filament) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: FilamentDetailModal(filament: filament),
      ),
    );
  }
}
