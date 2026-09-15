import 'package:flutter/material.dart';
import '../painters/greenhouse_dial_painter.dart';
import '../state/greenhouse_scope.dart';
import '../theme/zelvora_theme.dart';
import 'bloom_calendar_screen.dart';
import 'flora_catalog_screen.dart';
import 'soil_moisture_screen.dart';

class GreenhouseHubScreen extends StatelessWidget {
  const GreenhouseHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gh = GreenhouseScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zelvora Greenhouse Hub'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dual Dial Canvas
              SizedBox(
                height: 150,
                child: CustomPaint(
                  painter: GreenhouseDialPainter(
                    temperatureC: gh.temperatureC,
                    humidityPct: gh.humidityPct,
                  ),
                ),
              ),

              // Metrics Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('TEMPERATURE', '${gh.temperatureC} C', Icons.thermostat_rounded),
                  _buildMetric('HUMIDITY', '${gh.humidityPct.toStringAsFixed(0)}%', Icons.water_drop_rounded),
                  _buildMetric('ACTIVE BLOOMS', '${gh.activeBloomsCount}', Icons.local_florist_rounded),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'GREENHOUSE CONTROLS & LOGS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: ZelvoraTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // 2x2 Dashboard Cards
              Row(
                children: [
                  Expanded(
                    child: _buildHubCard(
                      context,
                      title: 'Bloom Calendar',
                      subtitle: 'Flowering cycles log',
                      icon: Icons.calendar_month_rounded,
                      destination: const BloomCalendarScreen(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHubCard(
                      context,
                      title: 'Soil Sensors',
                      subtitle: 'Substrate moisture',
                      icon: Icons.grain_rounded,
                      destination: const SoilMoistureScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildHubCard(
                      context,
                      title: 'Flora Catalog',
                      subtitle: 'Greenhouse botanical list',
                      icon: Icons.spa_rounded,
                      destination: const FloraCatalogScreen(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ZelvoraTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD1E7D8)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.air_rounded, color: ZelvoraTheme.emerald, size: 28),
                          SizedBox(height: 8),
                          Text('Ventilation', style: TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.textPrimary)),
                          SizedBox(height: 4),
                          Text('Fan Level 2 Auto', style: TextStyle(fontSize: 12, color: ZelvoraTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: ZelvoraTheme.emerald, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ZelvoraTheme.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 10, color: ZelvoraTheme.textSecondary)),
      ],
    );
  }

  Widget _buildHubCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    final gh = GreenhouseScope.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GreenhouseScope(data: gh, child: destination)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ZelvoraTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD1E7D8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ZelvoraTheme.emerald, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: ZelvoraTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
