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
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  static const _titles = ['Alle Filamente', 'Meine Filamente'];
  int _selectedIndex = 0;
  final User _user = User(name: 'Andreas');

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const AllFilamentsScreen(),
      const MyFilamentsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SearchBar(
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(AppColors.bg200),
                  leading: const Icon(Icons.search),
                  hintText: 'Filament suchen',
                  onChanged: (value) {
                    // TODO: implement search
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FilterChip(
                        avatar: const Icon(Icons.tune, size: 24),
                        label: const SizedBox(
                          width: double.infinity,
                          child: Text('Material', textAlign: TextAlign.start),
                        ),
                        labelPadding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onSelected: (selected) {
                          // TODO: implement filter
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChip(
                        avatar: const Icon(Icons.tune, size: 24),
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Material',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        labelPadding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onSelected: (selected) {
                          // TODO: implement filter
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: filamentIcon(active: true),
            selectedIcon: filamentIcon(active: false),
            label: 'Alle',
            tooltip: 'Alle Filamente anzeigen',
          ),
          NavigationDestination(
            icon: filamentIcon(active: true),
            selectedIcon: filamentIcon(active: false),
            label: 'Meine',
            tooltip: 'Meine Filamente anzeigen',
          ),
        ],
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
