import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/features/filaments/domain/filament_filter_props.dart';
import 'package:flutter/material.dart';



class FilamentFilter extends StatelessWidget {
  final List<String> materialOptions;
  final Set<String> selectedMaterials;
  final ValueChanged<Set<String>> onMaterialsChanged;
  final List<FilamentPropertyOption> propertyOptions;
  final Set<String> selectedProperties;
  final ValueChanged<Set<String>> onPropertiesChanged;

  const FilamentFilter({
    super.key,
    required this.materialOptions,
    required this.selectedMaterials,
    required this.onMaterialsChanged,
    required this.propertyOptions,
    required this.selectedProperties,
    required this.onPropertiesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(AppColors.bg200),
              leading: const Icon(Icons.search),
              hintText: 'Filament suchen',
              onChanged: (value) {
                // Suchfunktion implementieren
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilterChip(
                    avatar: _buildFilterAvatar(selectedMaterials.length),
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Material',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    labelPadding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.rounded),
                    ),
                    showCheckmark: false,
                    selectedColor: AppColors.bg200,
                    selected: selectedMaterials.isNotEmpty,
                    onSelected: (_) => _openMaterialSheet(context),
                    onDeleted: selectedMaterials.isEmpty
                        ? null
                        : () => onMaterialsChanged(<String>{}),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    avatar: _buildFilterAvatar(selectedProperties.length),
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Eigenschaften',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    labelPadding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.rounded),
                    ),
                    showCheckmark: false,
                    selectedColor: AppColors.bg200,
                    selected: selectedProperties.isNotEmpty,
                    onSelected: (_) => _openPropertiesSheet(context),
                    onDeleted: selectedProperties.isEmpty
                        ? null
                        : () => onPropertiesChanged(<String>{}),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAvatar(int count) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Icon(Icons.tune, size: 24),
          ),
          if (count > 0)
            Positioned(
              top: -2,
              left: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 16,
                constraints: const BoxConstraints(minWidth: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadii.rounded),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.bg200,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openMaterialSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final workingSelection = Set<String>.from(selectedMaterials);

        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final option in materialOptions)
                            CheckboxListTile(
                              value: workingSelection.contains(option),
                              title: Text(option),
                              onChanged: (checked) {
                                setModalState(() {
                                  if (checked == true) {
                                    workingSelection.add(option);
                                  } else {
                                    workingSelection.remove(option);
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setModalState(() => workingSelection.clear());
                            },
                            child: const Text('Zurücksetzen'),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: () {
                              onMaterialsChanged(workingSelection);
                              Navigator.pop(context);
                            },
                            child: const Text('Anwenden'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openPropertiesSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final workingSelection = Set<String>.from(selectedProperties);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final option in propertyOptions)
                            CheckboxListTile(
                              value: workingSelection.contains(option.key),
                              title: Text(option.label),
                              onChanged: (checked) {
                                setModalState(() {
                                  if (checked == true) {
                                    workingSelection.add(option.key);
                                  } else {
                                    workingSelection.remove(option.key);
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setModalState(() => workingSelection.clear());
                            },
                            child: const Text('Zurücksetzen'),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: () {
                              onPropertiesChanged(workingSelection);
                              Navigator.pop(context);
                            },
                            child: const Text('Anwenden'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
