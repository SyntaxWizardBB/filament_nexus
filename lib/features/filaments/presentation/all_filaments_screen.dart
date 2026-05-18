import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class AllFilamentsScreen extends StatelessWidget {
  const AllFilamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FilamentList(filaments: mockFilaments);
  }
}
