import 'package:flutter/material.dart';
import '../theme/zelvora_theme.dart';

class SoilMoistureScreen extends StatelessWidget {
  const SoilMoistureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Substrate Sensors')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildSensorCard('Bed 1: Tropical Aroids (Orchid Bark)', 0.74),
            const SizedBox(height: 12),
            _buildSensorCard('Bed 2: Cloud Forest Ferns (Sphagnum)', 0.88),
            const SizedBox(height: 12),
            _buildSensorCard('Bed 3: Succulent Rockery (Pumice Mix)', 0.32),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, double moisture) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZelvoraTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1E7D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.textPrimary)),
              Text('${(moisture * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.emerald)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: moisture,
            minHeight: 8,
            backgroundColor: const Color(0xFFD1E7D8),
            valueColor: const AlwaysStoppedAnimation<Color>(ZelvoraTheme.emerald),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
