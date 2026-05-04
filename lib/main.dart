import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fillament Nexus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        ),
      ),
      home: const MyHomePage(title: 'Fillament Nexus'),
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

  Widget _filamentIcon(BuildContext context, {required bool active}) {
    return SvgPicture.asset(
      'assets/icons/filament.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        items: [
          BottomNavigationBarItem(
            icon: _filamentIcon(context, active: _selectedIndex == 0),
            label: 'Alle',
          ),
          BottomNavigationBarItem(
            icon: _filamentIcon(context, active: _selectedIndex == 1),
            label: 'Meine',
          ),
        ],
      ),
    );
  }
}