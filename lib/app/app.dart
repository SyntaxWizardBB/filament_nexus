import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/features/filaments/presentation/all_filaments_screen.dart';
import 'package:filament_nexus/features/filaments/presentation/my_filaments_screen.dart';
import 'package:filament_nexus/shared/widgets/filament_icon.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class User {
  final String name;
  User({required this.name});
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}

class FilamentNexus extends StatelessWidget {
  const FilamentNexus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filament Nexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final User _user = User(name: 'Andreas');
  static const _titles = ['Alle Filamente', 'Meine Filamente'];

  final screens = [AllFilamentsScreen(), MyFilamentsScreen()];

  final destinations = <NavigationDestination>[
    NavigationDestination(
      icon: filamentIcon(active: false),
      selectedIcon: filamentIcon(active: true),
      label: 'Alle',
      tooltip: 'Alle Filamente anzeigen',
    ),
    NavigationDestination(
      icon: filamentIcon(active: false),
      selectedIcon: filamentIcon(active: true),
      label: 'Meine',
      tooltip: 'Meine Filamente anzeigen',
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Titel mittig
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: 'Profil von ${_user.name}',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  // TODO: open profile screen
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _user.initial,
                    style: const TextStyle(
                      color: AppColors.bg200,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: destinations,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {},
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
