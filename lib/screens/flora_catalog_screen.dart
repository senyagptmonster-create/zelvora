import 'package:flutter/material.dart';
import '../theme/zelvora_theme.dart';

class FloraCatalogScreen extends StatelessWidget {
  const FloraCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final species = [
      {'name': 'Staghorn Fern', 'humidity': '75-85%', 'light': 'Dappled Canopy'},
      {'name': 'Nepenthes Pitcher Plant', 'humidity': '80-95%', 'light': 'Bright Diffused'},
      {'name': 'Anthurium Clarinervium', 'humidity': '65-80%', 'light': 'Partial Shade'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Greenhouse Flora Catalog')),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: species.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final s = species[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ZelvoraTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD1E7D8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: ZelvoraTheme.textPrimary)),
                    Text(s['light']!, style: const TextStyle(fontSize: 12, color: ZelvoraTheme.textSecondary)),
                  ],
                ),
                Text(s['humidity']!, style: const TextStyle(color: ZelvoraTheme.emerald, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
