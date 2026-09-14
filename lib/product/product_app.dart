import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/brand.dart';
import '../app/theme.dart';
import 'screens.dart';
import 'zelvora_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ZelvoraStore(),
      child: MaterialApp(
        title: 'Zelvora',
        theme: ThemeData(
          scaffoldBackgroundColor: cBg,
          colorScheme: ColorScheme.light(primary: cInk, secondary: cAccent),
        ),
        home: ZelvoraDashboard(),
      ),
    );
  }
}

class ZelvoraDashboard extends StatelessWidget {
  const ZelvoraDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        title: Text('Zelvora Dashboard', style: AppTheme.display(cSurface)),
        backgroundColor: cInk,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, 'Bloom Schedule', Icons.calendar_today, BloomScheduleScreen()),
          _buildCard(context, 'Environment', Icons.thermostat, GreenhouseEnvironmentScreen()),
          _buildCard(context, 'Soil Humidity', Icons.water_drop, SoilHumidityGuideScreen()),
          _buildCard(context, 'Flora Catalog', Icons.local_florist, FloraCatalogScreen()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      color: cSurface,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: cAccent),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.text(cInk), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
