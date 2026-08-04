import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament_screen.dart';
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
  Set<String> _selectedMaterials = <String>{};
  Set<String> _selectedProperties = <String>{};
  String _query = '';
  final FilamentRepository _repository = FilamentRepository.instance;

  List<String> get _materialOptions {
    final userId = AuthService.instance.uid;
    final options = _repository.filaments
        .where((filament) => filament.userId == userId)
        .map((filament) => filament.type.name)
        .toSet();
    final sorted = options.toList()..sort();
    return sorted;
  }

  List<FilamentPropertyOption> get _propertyOptions {
    final userId = AuthService.instance.uid;
    return allPropertyOptions
        .where(
          (option) => _repository.filaments
              .where((filament) => filament.userId == userId)
              .any((filament) => hasProperty(filament, option.key)),
        )
        .toList();
  }

  List<Filament> get _filteredFilaments {
    return _repository.filaments
        .where((filament) => filament.userId == AuthService.instance.uid)
        .where((filament) {
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
        })
        .toList();
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
                emptyMessage:
                    'Du hast noch keine eigenen Filamente erfasst.\n'
                    'Lege mit + ein neues an.',
                // Tapping a filament opens it for editing.
                onTap: (filament) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddEditFilamentScreen(filament: filament),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
