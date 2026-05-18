import 'package:filament_nexus/features/filaments/data/mock.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      const FilamentFilter(),
      Expanded(
        child: FilamentList(filaments: filamentList),
      ),
    ],
  );
  }
}
