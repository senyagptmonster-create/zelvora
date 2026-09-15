import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flora_service.dart';
import '../theme/zelvora_theme.dart';

class BloomCalendarScreen extends StatefulWidget {
  const BloomCalendarScreen({super.key});

  @override
  State<BloomCalendarScreen> createState() => _BloomCalendarScreenState();
}

class _BloomCalendarScreenState extends State<BloomCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final flora = Provider.of<FloraService>(context);
    final plants = flora.plants;

    final bloomingSoon = plants.where((p) => p.bloomProgress >= 0.3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phenology & Bloom Calendar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Day Selector Strip
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: ZelvoraTheme.surfaceGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ZelvoraTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Observation Timeline',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ZelvoraTheme.textHigh,
                          ),
                        ),
                        Text(
                          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: ZelvoraTheme.mintAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final day = DateTime.now().add(Duration(days: index - 3));
                      final isSelected = day.year == _selectedDate.year &&
                          day.month == _selectedDate.month &&
                          day.day == _selectedDate.day;
                      final isToday = day.day == DateTime.now().day &&
                          day.month == DateTime.now().month;

                      const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      final weekdayStr = weekdays[day.weekday - 1];

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = day),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ZelvoraTheme.emeraldPrimary
                                : (isToday
                                    ? ZelvoraTheme.surfaceElevated
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? ZelvoraTheme.mintAccent
                                  : (isToday
                                      ? ZelvoraTheme.borderSubtle
                                      : Colors.transparent),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                weekdayStr,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected
                                      ? Colors.white
                                      : ZelvoraTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : ZelvoraTheme.textHigh,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active Bloom Cycle Tracker
            const Text(
              'Flowering Stage & Phenology Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ZelvoraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 12),

            ...bloomingSoon.map((plant) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ZelvoraTheme.textHigh,
                                ),
                              ),
                              Text(
                                plant.scientificName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: ZelvoraTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ZelvoraTheme.amberBloom.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              plant.bloomStage,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: ZelvoraTheme.amberBloom,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Phenology Cycle Completion',
                            style: TextStyle(
                              fontSize: 12,
                              color: ZelvoraTheme.textMuted,
                            ),
                          ),
                          Text(
                            '${(plant.bloomProgress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ZelvoraTheme.mintAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: plant.bloomProgress,
                          minHeight: 8,
                          backgroundColor: ZelvoraTheme.surfaceElevated,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ZelvoraTheme.amberBloom,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _bloomStagePill(
                            'Vegetative',
                            plant.bloomProgress >= 0.25,
                          ),
                          const SizedBox(width: 6),
                          _bloomStagePill('Budding', plant.bloomProgress >= 0.5),
                          const SizedBox(width: 6),
                          _bloomStagePill('Flowering', plant.bloomProgress >= 0.75),
                          const SizedBox(width: 6),
                          _bloomStagePill('Post-Bloom', plant.bloomProgress >= 0.95),
                        ],
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

  Widget _bloomStagePill(String label, bool reached) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: reached
              ? ZelvoraTheme.emeraldPrimary.withAlpha(50)
              : ZelvoraTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: reached ? ZelvoraTheme.mintAccent : Colors.transparent,
            width: 0.8,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: reached ? FontWeight.bold : FontWeight.normal,
            color: reached ? ZelvoraTheme.mintAccent : ZelvoraTheme.textMuted,
          ),
        ),
      ),
    );
  }
}
