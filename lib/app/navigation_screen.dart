import 'package:filament_nexus/app/services/user_service.dart';
import 'package:filament_nexus/features/filaments/data/filament_repository.dart';
import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/features/about/presentation/about_screen.dart';
import 'package:filament_nexus/features/filaments/presentation/add_edit_filament_screen.dart';
import 'package:filament_nexus/features/filaments/presentation/all_filaments_screen.dart';
import 'package:filament_nexus/features/filaments/presentation/my_filaments_screen.dart';
import 'package:filament_nexus/features/info/presentation/info_screen.dart';
import 'package:filament_nexus/features/profile/presentation/profile_screen.dart';
import 'package:filament_nexus/features/wiki/presentation/wiki_screen.dart';
import 'package:filament_nexus/shared/widgets/filament_icon.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
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

  @override
  void initState() {
    super.initState();
    UserService().initialize();
    FilamentRepository.instance.load();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openInfoScreen() {
    Navigator.pop(context);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InfoScreen()));
  }

  void _openProfileScreen() {
    try {
      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.pop(context);
      }
    } catch (_) {
      // Drawer check failed, ignore
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _openWikiScreen() {
    Navigator.pop(context);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WikiScreen()));
  }

  void _openAboutScreen() {
    Navigator.pop(context);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Filament Nexus',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.bg200,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Info'),
              subtitle: const Text('App-Infos und Beschreibung'),
              onTap: _openInfoScreen,
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Wiki'),
              subtitle: const Text('Wiki-Entries anzeigen'),
              onTap: _openWikiScreen,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              subtitle: const Text('Mein Benutzerprofil'),
              onTap: _openProfileScreen,
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Über uns'),
              subtitle: const Text('Informationen über die Entwickler der App'),
              onTap: _openAboutScreen,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: 'Profil öffnen',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _openProfileScreen,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    UserService().currentUser.avatarInitial,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditFilamentScreen(),
            ),
          );
        },
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
