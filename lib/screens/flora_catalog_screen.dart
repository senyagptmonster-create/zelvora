import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flora_service.dart';
import '../components/flora_card.dart';
import '../theme/zelvora_theme.dart';

class FloraCatalogScreen extends StatefulWidget {
  const FloraCatalogScreen({super.key});

  @override
  State<FloraCatalogScreen> createState() => _FloraCatalogScreenState();
}

class _FloraCatalogScreenState extends State<FloraCatalogScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Orchid',
    'Fern',
    'Succulent',
    'Tropical',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAddPlantDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final scientificCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String category = 'Tropical';
    String light = 'Bright Indirect';
    int interval = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ZelvoraTheme.surfaceGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Register Botanical Specimen',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ZelvoraTheme.textHigh,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: ZelvoraTheme.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Common Name (e.g. Fiddle Leaf Fig)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: scientificCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Scientific Taxonomy (e.g. Ficus lyrata)',
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Category',
                      style: TextStyle(color: ZelvoraTheme.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: ['Orchid', 'Fern', 'Succulent', 'Tropical'].map((cat) {
                        final isSelected = category == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: ZelvoraTheme.emeraldPrimary,
                          backgroundColor: ZelvoraTheme.surfaceElevated,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : ZelvoraTheme.textHigh,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) setDialogState(() => category = cat);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Light Exposure',
                      style: TextStyle(color: ZelvoraTheme.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: light,
                      dropdownColor: ZelvoraTheme.surfaceElevated,
                      items: const [
                        DropdownMenuItem(
                          value: 'Direct Sunlight',
                          child: Text('Direct Sunlight'),
                        ),
                        DropdownMenuItem(
                          value: 'Bright Indirect',
                          child: Text('Bright Indirect'),
                        ),
                        DropdownMenuItem(
                          value: 'Medium Indirect',
                          child: Text('Medium Indirect'),
                        ),
                        DropdownMenuItem(
                          value: 'Filtered Shade',
                          child: Text('Filtered Shade'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) setDialogState(() => light = v);
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          'Water Interval:',
                          style: TextStyle(color: ZelvoraTheme.textHigh, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          '$interval days',
                          style: const TextStyle(
                            color: ZelvoraTheme.mintAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: interval.toDouble(),
                      min: 1,
                      max: 21,
                      divisions: 20,
                      activeColor: ZelvoraTheme.emeraldPrimary,
                      inactiveColor: ZelvoraTheme.surfaceElevated,
                      onChanged: (val) => setDialogState(() => interval = val.round()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Greenhouse Notes & Substrate Care',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;
                          final scientific = scientificCtrl.text.trim().isEmpty
                              ? 'Species indet.'
                              : scientificCtrl.text.trim();
                          Provider.of<FloraService>(context, listen: false).addPlant(
                            name: name,
                            scientificName: scientific,
                            category: category,
                            lightRequirement: light,
                            wateringIntervalDays: interval,
                            notes: notesCtrl.text.trim(),
                          );
                          Navigator.pop(ctx);
                        },
                        child: const Text('Add Plant to Catalog'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final floraService = Provider.of<FloraService>(context);
    final allPlants = floraService.plants;

    final filtered = allPlants.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.scientificName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Botanical Flora Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Specimen',
            onPressed: () => _showAddPlantDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: ZelvoraTheme.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                hintText: 'Search by common name or taxonomy...',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: ZelvoraTheme.emeraldPrimary,
                    backgroundColor: ZelvoraTheme.surfaceElevated,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : ZelvoraTheme.textHigh,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    checkmarkColor: Colors.white,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.local_florist_outlined,
                          size: 48,
                          color: ZelvoraTheme.textMuted,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No botanical specimens found.',
                          style: TextStyle(color: ZelvoraTheme.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (ctx, index) {
                      final plant = filtered[index];
                      return FloraCard(
                        plant: plant,
                        onWater: () => floraService.waterPlant(plant.id),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plant.name}: ${plant.notes}'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: ZelvoraTheme.surfaceElevated,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
