import 'package:filament_nexus/features/filaments/data/mock.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_filter.dart';
import 'package:filament_nexus/features/filaments/presentation/widgets/filament_list.dart';
import 'package:flutter/material.dart';

class MyFilaments extends StatefulWidget {
  const MyFilaments({super.key});

  @override
  State<MyFilaments> createState() => _MyFilamentsState();
}

class _MyFilamentsState extends State<MyFilaments> {
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
