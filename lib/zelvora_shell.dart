import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/flora_service.dart';
import 'theme/zelvora_theme.dart';
import 'screens/flora_catalog_screen.dart';
import 'screens/greenhouse_env_screen.dart';
import 'screens/soil_humidity_screen.dart';
import 'screens/bloom_calendar_screen.dart';

class ZelvoraApp extends StatelessWidget {
  const ZelvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FloraService()..initialize(),
      child: MaterialApp(
        title: 'Zelvora Botanical',
        debugShowCheckedModeBanner: false,
        theme: ZelvoraTheme.darkTheme,
        home: const ZelvoraShell(),
      ),
    );
  }
}

class ZelvoraShell extends StatefulWidget {
  const ZelvoraShell({super.key});

  @override
  State<ZelvoraShell> createState() => _ZelvoraShellState();
}

class _ZelvoraShellState extends State<ZelvoraShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FloraCatalogScreen(),
    GreenhouseEnvScreen(),
    SoilHumidityScreen(),
    BloomCalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_florist_outlined),
            selectedIcon: Icon(Icons.local_florist),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.thermostat_outlined),
            selectedIcon: Icon(Icons.thermostat),
            label: 'Climate',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Moisture',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Phenology',
          ),
        ],
      ),
    );
  }
}
