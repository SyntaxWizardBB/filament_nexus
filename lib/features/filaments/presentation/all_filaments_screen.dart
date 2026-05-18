import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class AllFilaments extends StatefulWidget {
  const AllFilaments({super.key});

  @override
  State<AllFilaments> createState() => _AllFilamentsState();
}

class _AllFilamentsState extends State<AllFilaments> {
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
