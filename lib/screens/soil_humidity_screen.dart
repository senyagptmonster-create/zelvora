import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flora_service.dart';
import '../theme/zelvora_theme.dart';

class SoilHumidityScreen extends StatelessWidget {
  const SoilHumidityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flora = Provider.of<FloraService>(context);
    final plants = flora.plants;
    final avgMoisture = flora.averageMoisture;
    final dryPlants = plants.where((p) => p.needsWater).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Substrate & Soil Moisture'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall moisture overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ZelvoraTheme.surfaceGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ZelvoraTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Greenhouse Substrate Average',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ZelvoraTheme.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: dryPlants.isEmpty
                              ? ZelvoraTheme.emeraldPrimary.withAlpha(40)
                              : ZelvoraTheme.coralAlert.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dryPlants.isEmpty
                              ? 'All Hydrated'
                              : '${dryPlants.length} Attention Needed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: dryPlants.isEmpty
                                ? ZelvoraTheme.mintAccent
                                : ZelvoraTheme.coralAlert,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${avgMoisture.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: ZelvoraTheme.mintAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          'Volumetric Water Content',
                          style: TextStyle(
                            fontSize: 12,
                            color: ZelvoraTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (avgMoisture / 100.0).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: ZelvoraTheme.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        avgMoisture < 35
                            ? ZelvoraTheme.coralAlert
                            : (avgMoisture < 60
                                ? ZelvoraTheme.amberBloom
                                : ZelvoraTheme.mintAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Zone breakdown
            const Text(
              'Greenhouse Sector Probes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ZelvoraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 12),
            _ZoneMoistureTile(
              zoneName: 'Zone A - Epiphytes & Orchids',
              sensorId: 'PROBE-901',
              substrateType: 'Pine Bark & Sphagnum',
              reading: 58,
              status: 'Ideal',
            ),
            const SizedBox(height: 10),
            _ZoneMoistureTile(
              zoneName: 'Zone B - Tropical Understory',
              sensorId: 'PROBE-902',
              substrateType: 'Peat, Perlite & Coco Coir',
              reading: 42,
              status: 'Moderate',
            ),
            const SizedBox(height: 10),
            _ZoneMoistureTile(
              zoneName: 'Zone C - Xerophytic Succulents',
              sensorId: 'PROBE-903',
              substrateType: 'Pumice & Gritty Clay',
              reading: 28,
              status: 'Dry (Normal)',
            ),
            const SizedBox(height: 24),

            // Plant-by-Plant Moisture & Manual Calibration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Sensor Readings per Plant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ZelvoraTheme.textHigh,
                  ),
                ),
                Text(
                  'Slide to calibrate',
                  style: TextStyle(fontSize: 11, color: ZelvoraTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...plants.map((plant) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plant.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ZelvoraTheme.textHigh,
                            ),
                          ),
                          Text(
                            '${plant.soilMoisture.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: plant.soilMoisture < 35
                                  ? ZelvoraTheme.coralAlert
                                  : ZelvoraTheme.mintAccent,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: plant.soilMoisture,
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        activeColor: plant.soilMoisture < 35
                            ? ZelvoraTheme.coralAlert
                            : ZelvoraTheme.emeraldPrimary,
                        inactiveColor: ZelvoraTheme.surfaceElevated,
                        onChanged: (val) => flora.updateMoisture(plant.id, val),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ZoneMoistureTile extends StatelessWidget {
  final String zoneName;
  final String sensorId;
  final String substrateType;
  final int reading;
  final String status;

  const _ZoneMoistureTile({
    required this.zoneName,
    required this.sensorId,
    required this.substrateType,
    required this.reading,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ZelvoraTheme.surfaceElevated,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ZelvoraTheme.surfaceGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.sensors_rounded,
                color: ZelvoraTheme.mintAccent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zoneName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ZelvoraTheme.textHigh,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$substrateType • $sensorId',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZelvoraTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$reading%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ZelvoraTheme.textHigh,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 11,
                    color: ZelvoraTheme.amberBloom,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
