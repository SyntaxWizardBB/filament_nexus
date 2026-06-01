import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class AllFilamentsScreen extends StatelessWidget {
  const AllFilamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FilamentRepository.instance;

    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        return Column(
          children: [
            const FilamentFilter(),
            Expanded(child: FilamentList(filaments: repository.filaments)),
          ],
        );
      },
    );
  }
}
