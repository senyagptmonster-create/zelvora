import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flora_service.dart';
import '../theme/zelvora_theme.dart';

class GreenhouseEnvScreen extends StatelessWidget {
  const GreenhouseEnvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flora = Provider.of<FloraService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Greenhouse Environment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Climate Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ZelvoraTheme.emeraldPrimary.withAlpha(50),
                    ZelvoraTheme.surfaceElevated,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ZelvoraTheme.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ZelvoraTheme.emeraldPrimary.withAlpha(80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.thermostat_auto_rounded,
                      color: ZelvoraTheme.mintAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Climate Control: Optimal Zone',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ZelvoraTheme.textHigh,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ventilation: ${flora.ventilationActive ? "Running" : "Idle"} | Misters: ${flora.mistingActive ? "Spraying" : "Standby"}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ZelvoraTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dials / Gauge Cards Row
            Row(
              children: [
                Expanded(
                  child: _ClimateGaugeCard(
                    title: 'Air Temperature',
                    value: '${flora.currentTemp.toStringAsFixed(1)}°C',
                    target: 'Target: ${flora.targetTemp.toStringAsFixed(1)}°C',
                    icon: Icons.device_thermostat_rounded,
                    accentColor: ZelvoraTheme.amberBloom,
                    progress: ((flora.currentTemp - 15) / 20).clamp(0.0, 1.0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ClimateGaugeCard(
                    title: 'Relative Humidity',
                    value: '${flora.currentHumidity.toStringAsFixed(0)}%',
                    target: 'Target: ${flora.targetHumidity.toStringAsFixed(0)}%',
                    icon: Icons.water_drop_outlined,
                    accentColor: ZelvoraTheme.mintAccent,
                    progress: (flora.currentHumidity / 100.0).clamp(0.0, 1.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Ventilation and misting switches
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Atmospheric Actuators',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ZelvoraTheme.textHigh,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: flora.ventilationActive
                              ? ZelvoraTheme.mintAccent.withAlpha(40)
                              : ZelvoraTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.air_rounded,
                          color: flora.ventilationActive
                              ? ZelvoraTheme.mintAccent
                              : ZelvoraTheme.textMuted,
                        ),
                      ),
                      title: const Text('Louvre Roof Ventilation'),
                      subtitle: const Text(
                        'Circulates fresh air and exhausts excess greenhouse heat',
                        style: TextStyle(fontSize: 12, color: ZelvoraTheme.textMuted),
                      ),
                      value: flora.ventilationActive,
                      activeThumbColor: ZelvoraTheme.mintAccent,
                      onChanged: (_) => flora.toggleVentilation(),
                    ),
                    const Divider(color: ZelvoraTheme.borderSubtle),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: flora.mistingActive
                              ? ZelvoraTheme.mintAccent.withAlpha(40)
                              : ZelvoraTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.grain_rounded,
                          color: flora.mistingActive
                              ? ZelvoraTheme.mintAccent
                              : ZelvoraTheme.textMuted,
                        ),
                      ),
                      title: const Text('Ultrasonic Canopy Misting'),
                      subtitle: const Text(
                        'Boosts ambient humidity for tropical epiphytes and ferns',
                        style: TextStyle(fontSize: 12, color: ZelvoraTheme.textMuted),
                      ),
                      value: flora.mistingActive,
                      activeThumbColor: ZelvoraTheme.mintAccent,
                      onChanged: (_) => flora.toggleMisting(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Target Setpoints Sliders
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Climate Target Setpoints',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ZelvoraTheme.textHigh,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Temperature',
                          style: TextStyle(color: ZelvoraTheme.textHigh),
                        ),
                        Text(
                          '${flora.targetTemp.toStringAsFixed(1)} °C',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ZelvoraTheme.amberBloom,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: flora.targetTemp,
                      min: 16.0,
                      max: 32.0,
                      divisions: 32,
                      activeColor: ZelvoraTheme.amberBloom,
                      inactiveColor: ZelvoraTheme.surfaceElevated,
                      onChanged: (v) => flora.setTargetTemp(v),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Relative Humidity',
                          style: TextStyle(color: ZelvoraTheme.textHigh),
                        ),
                        Text(
                          '${flora.targetHumidity.toStringAsFixed(0)} %',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ZelvoraTheme.mintAccent,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: flora.targetHumidity,
                      min: 40.0,
                      max: 90.0,
                      divisions: 50,
                      activeColor: ZelvoraTheme.mintAccent,
                      inactiveColor: ZelvoraTheme.surfaceElevated,
                      onChanged: (v) => flora.setTargetHumidity(v),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClimateGaugeCard extends StatelessWidget {
  final String title;
  final String value;
  final String target;
  final IconData icon;
  final Color accentColor;
  final double progress;

  const _ClimateGaugeCard({
    required this.title,
    required this.value,
    required this.target,
    required this.icon,
    required this.accentColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ZelvoraTheme.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              target,
              style: const TextStyle(fontSize: 11, color: ZelvoraTheme.textMuted),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: ZelvoraTheme.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
