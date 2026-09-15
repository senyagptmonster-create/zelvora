import 'package:flutter/material.dart';
import '../services/flora_service.dart';
import '../theme/zelvora_theme.dart';

class FloraCard extends StatelessWidget {
  final FloraItem plant;
  final VoidCallback onWater;
  final VoidCallback? onTap;

  const FloraCard({
    super.key,
    required this.plant,
    required this.onWater,
    this.onTap,
  });

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'orchid':
        return Icons.filter_vintage_rounded;
      case 'fern':
        return Icons.eco_rounded;
      case 'succulent':
        return Icons.nature_rounded;
      case 'tropical':
        return Icons.park_rounded;
      default:
        return Icons.local_florist_rounded;
    }
  }

  Color _moistureColor(double val) {
    if (val < 35) return ZelvoraTheme.coralAlert;
    if (val < 65) return ZelvoraTheme.amberBloom;
    return ZelvoraTheme.mintAccent;
  }

  @override
  Widget build(BuildContext context) {
    final isDry = plant.needsWater;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: ZelvoraTheme.surfaceGreen,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ZelvoraTheme.emeraldPrimary.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ZelvoraTheme.emeraldPrimary.withAlpha(80),
                      ),
                    ),
                    child: Icon(
                      _categoryIcon(plant.category),
                      color: ZelvoraTheme.mintAccent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ZelvoraTheme.textHigh,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: ZelvoraTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: ZelvoraTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                plant.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ZelvoraTheme.mintAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.wb_sunny_outlined,
                              size: 13,
                              color: ZelvoraTheme.amberBloom,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              plant.lightRequirement,
                              style: const TextStyle(
                                fontSize: 11,
                                color: ZelvoraTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onWater,
                    icon: Icon(
                      Icons.water_drop_rounded,
                      color: isDry
                          ? ZelvoraTheme.coralAlert
                          : ZelvoraTheme.mintAccent,
                    ),
                    tooltip: 'Water plant',
                    style: IconButton.styleFrom(
                      backgroundColor: isDry
                          ? ZelvoraTheme.coralAlert.withAlpha(30)
                          : ZelvoraTheme.surfaceElevated,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soil Moisture: ${plant.soilMoisture.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _moistureColor(plant.soilMoisture),
                    ),
                  ),
                  Text(
                    'Bloom: ${plant.bloomStage} (${(plant.bloomProgress * 100).toInt()}%)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ZelvoraTheme.amberBloom,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: plant.soilMoisture / 100.0,
                  minHeight: 6,
                  backgroundColor: ZelvoraTheme.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _moistureColor(plant.soilMoisture),
                  ),
                ),
              ),
              if (isDry) ...[
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: ZelvoraTheme.coralAlert,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hydration threshold reached. Needs watering today.',
                      style: TextStyle(
                        fontSize: 11,
                        color: ZelvoraTheme.coralAlert,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
