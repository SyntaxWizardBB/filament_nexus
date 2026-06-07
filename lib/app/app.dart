import 'package:filament_nexus/app/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class FilamentNexus extends StatelessWidget {
  const FilamentNexus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filament Nexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const NavigationScreen(),
    );
  }
}
