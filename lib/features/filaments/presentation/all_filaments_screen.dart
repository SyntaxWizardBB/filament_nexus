import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class AllFilamentsScreen extends StatefulWidget {
  const AllFilamentsScreen({super.key});

  @override
  State<AllFilamentsScreen> createState() => _AllFilamentsScreenState();
}

class _AllFilamentsScreenState extends State<AllFilamentsScreen> {
  final filamentList = mockFilaments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FilamentFilter(),
        Expanded(child: FilamentList(filaments: filamentList)),
      ],
    );
  }
}
