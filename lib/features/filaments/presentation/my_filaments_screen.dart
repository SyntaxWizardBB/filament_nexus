import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class MyFilamentsScreen extends StatelessWidget {
  const MyFilamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FilamentList(filaments: mockFilaments);
  }
}
