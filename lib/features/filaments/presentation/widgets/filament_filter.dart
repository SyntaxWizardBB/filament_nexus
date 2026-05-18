import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FilamentFilter extends StatefulWidget {
  const FilamentFilter({super.key});

  @override
  State<FilamentFilter> createState() => _FilamentFilterState();
}

class _FilamentFilterState extends State<FilamentFilter> {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FilterChip(
                    avatar: const Icon(Icons.tune, size: 24),
                    label: SizedBox(
                      width: double.infinity,
                      child: const Text('Material', textAlign: TextAlign.start),
                    ),
                    labelPadding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onSelected: (selected) {
                      // Filterlogik implementieren
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    avatar: const Icon(Icons.tune, size: 24),
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Material',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    labelPadding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onSelected: (selected) {
                      // Filterlogik implementieren
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
