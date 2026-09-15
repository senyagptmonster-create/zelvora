import 'package:flutter/material.dart';
import '../theme/zelvora_theme.dart';

class BloomCalendarScreen extends StatelessWidget {
  const BloomCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blooms = [
      {'plant': 'Phalaenopsis Orchid', 'stage': 'Peak Inflorescence', 'days': '14 days left'},
      {'plant': 'Amazonian Zebra Plant', 'stage': 'Bract Formation', 'days': '22 days left'},
      {'plant': 'Cape Sundew Carnivorous', 'stage': 'Flower Spike Emergence', 'days': '8 days left'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bloom Calendar')),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: blooms.length,
        separatorBuilder: (context, _) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final b = blooms[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ZelvoraTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD1E7D8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b['plant']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ZelvoraTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text(b['stage']!, style: const TextStyle(fontSize: 12, color: ZelvoraTheme.textSecondary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ZelvoraTheme.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(b['days']!, style: const TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.emerald, fontSize: 12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
