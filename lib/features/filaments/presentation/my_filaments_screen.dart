import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament_screen.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class MyFilamentsScreen extends StatelessWidget {
  const MyFilamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FilamentRepository.instance;

    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        return Column(
          children: [
            const FilamentFilter(),
            Expanded(
              child: FilamentList(
                filaments: repository.filaments,
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
