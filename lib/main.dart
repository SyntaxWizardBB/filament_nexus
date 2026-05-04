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
      home: const MyHomePage(title: 'Alle Filamente'),
    );

  }
}


class User {
  final String name;
  User({required this.name});
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _titles = ['Alle Filamente', 'Meine Filamente'];
  int _selectedIndex = 0;
  final User _user = User(name: 'Andreas');
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
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Meine Filamente'),
            Text('Hier könnten deine Filamente angezeigt werden'),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
      centerTitle: true,                              // Titel mittig
      title: Text(_titles[_selectedIndex]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Tooltip(
            message: 'Profil von ${_user.name}',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // z. B. Profil-Screen öffnen
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
          // Optional: Profilbild
          // backgroundImage: NetworkImage('https://...'),
          // child: Icon(Icons.person, color: AppColors.textDark),
        ),
        
      ),
          ), 
    ),
  ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Column(
          children: [ Padding (
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:  SearchBar(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(AppColors.bg200),
            leading: const Icon(Icons.search),
            hintText: 'Filament suchen',
            onChanged: (value) {
              // Suchfunktion implementieren
            },
          ),
          ),
          Padding(padding:  const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          Expanded(
             child:
          FilterChip(
            avatar: const Icon(Icons.tune,size:24),
            label: SizedBox(
              width: double.infinity,
              child: const Text(
                'Material',
                textAlign: TextAlign.start,
              ),
            ),
            labelPadding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onSelected: (selected) {
              // Filterlogik implementieren
            },
          ),
          ),
          const SizedBox(width: 8),
          Expanded(child:
          FilterChip(
            avatar: const Icon(Icons.tune,size:24),
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
              // Filterlogik implementieren
            },
          ),
          ),
          
          ],
        ),
      ),
      ]
      ),
      ),
      ),
    
      

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {},
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
