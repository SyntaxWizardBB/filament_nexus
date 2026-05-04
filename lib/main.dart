import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filament Nexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MyHomePage(title: 'Filament Nexus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _filamentIcon({required bool active}) {
    return SvgPicture.asset(
      'assets/icons/filament.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        active ? AppColors.primary : AppColors.secondary,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const Center(child: Text('Alle Filamente')),
      const Center(child: Text('Meine Filamente')),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: _filamentIcon(active: true),
            selectedIcon: _filamentIcon(active: false),
            label: 'Alle',
            tooltip: 'Alle Filamente anzeigen',
          ),
          NavigationDestination(
            icon: _filamentIcon(active: true),
            selectedIcon: _filamentIcon(active: false),
            label: 'Meine',
            tooltip: 'Meine Filamente anzeigen',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
