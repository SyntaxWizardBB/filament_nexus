
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/all_filaments/presentation/all_filaments_screen.dart';

class FilamentNexus extends StatelessWidget {
  const FilamentNexus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filament Nexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AllFilaments(title: 'Alle Filamente'),
    );
  }
}