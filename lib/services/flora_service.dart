import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloraItem {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String lightRequirement;
  final int wateringIntervalDays;
  DateTime lastWatered;
  double soilMoisture; // 0 to 100
  String bloomStage;
  double bloomProgress; // 0.0 to 1.0
  final String notes;

  FloraItem({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.lightRequirement,
    required this.wateringIntervalDays,
    required this.lastWatered,
    required this.soilMoisture,
    required this.bloomStage,
    required this.bloomProgress,
    required this.notes,
  });

  bool get needsWater {
    final daysSince = DateTime.now().difference(lastWatered).inDays;
    return daysSince >= wateringIntervalDays || soilMoisture < 35.0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'scientificName': scientificName,
        'category': category,
        'lightRequirement': lightRequirement,
        'wateringIntervalDays': wateringIntervalDays,
        'lastWatered': lastWatered.toIso8601String(),
        'soilMoisture': soilMoisture,
        'bloomStage': bloomStage,
        'bloomProgress': bloomProgress,
        'notes': notes,
      };

  factory FloraItem.fromJson(Map<String, dynamic> json) => FloraItem(
        id: json['id'] as String,
        name: json['name'] as String,
        scientificName: json['scientificName'] as String,
        category: json['category'] as String,
        lightRequirement: json['lightRequirement'] as String,
        wateringIntervalDays: json['wateringIntervalDays'] as int,
        lastWatered: DateTime.parse(json['lastWatered'] as String),
        soilMoisture: (json['soilMoisture'] as num).toDouble(),
        bloomStage: json['bloomStage'] as String,
        bloomProgress: (json['bloomProgress'] as num).toDouble(),
        notes: json['notes'] as String,
      );
}

class FloraService extends ChangeNotifier {
  static const String _storageKey = 'zelvora_flora_plants_v1';
  static const String _envKey = 'zelvora_greenhouse_env_v1';

  List<FloraItem> _plants = [];
  double _currentTemp = 23.4;
  double _targetTemp = 22.0;
  double _currentHumidity = 68.0;
  double _targetHumidity = 72.0;
  bool _ventilationActive = false;
  bool _mistingActive = false;
  bool _isInitialized = false;

  List<FloraItem> get plants => List.unmodifiable(_plants);
  double get currentTemp => _currentTemp;
  double get targetTemp => _targetTemp;
  double get currentHumidity => _currentHumidity;
  double get targetHumidity => _targetHumidity;
  bool get ventilationActive => _ventilationActive;
  bool get mistingActive => _mistingActive;
  bool get isInitialized => _isInitialized;

  int get pendingWaterCount => _plants.where((p) => p.needsWater).length;
  double get averageMoisture => _plants.isEmpty
      ? 0.0
      : _plants.map((p) => p.soilMoisture).reduce((a, b) => a + b) / _plants.length;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final plantsJson = prefs.getString(_storageKey);
      if (plantsJson != null && plantsJson.isNotEmpty) {
        final decoded = jsonDecode(plantsJson) as List<dynamic>;
        _plants = decoded.map((e) => FloraItem.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _plants = _defaultBotanicalData();
        await _savePlants();
      }

      final envJson = prefs.getString(_envKey);
      if (envJson != null && envJson.isNotEmpty) {
        final env = jsonDecode(envJson) as Map<String, dynamic>;
        _currentTemp = (env['currentTemp'] as num?)?.toDouble() ?? 23.4;
        _targetTemp = (env['targetTemp'] as num?)?.toDouble() ?? 22.0;
        _currentHumidity = (env['currentHumidity'] as num?)?.toDouble() ?? 68.0;
        _targetHumidity = (env['targetHumidity'] as num?)?.toDouble() ?? 72.0;
        _ventilationActive = env['ventilationActive'] as bool? ?? false;
        _mistingActive = env['mistingActive'] as bool? ?? false;
      }
    } catch (e) {
      debugPrint('Error loading Zelvora flora data: $e');
      _plants = _defaultBotanicalData();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _savePlants() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_plants.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> _saveEnv() async {
    final prefs = await SharedPreferences.getInstance();
    final env = {
      'currentTemp': _currentTemp,
      'targetTemp': _targetTemp,
      'currentHumidity': _currentHumidity,
      'targetHumidity': _targetHumidity,
      'ventilationActive': _ventilationActive,
      'mistingActive': _mistingActive,
    };
    await prefs.setString(_envKey, jsonEncode(env));
  }

  Future<void> waterPlant(String id) async {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plants[index].lastWatered = DateTime.now();
      _plants[index].soilMoisture = 85.0;
      await _savePlants();
      notifyListeners();
    }
  }

  Future<void> updateMoisture(String id, double moisture) async {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plants[index].soilMoisture = moisture.clamp(0.0, 100.0);
      await _savePlants();
      notifyListeners();
    }
  }

  Future<void> updateBloomProgress(String id, double progress, String stage) async {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _plants[index].bloomProgress = progress.clamp(0.0, 1.0);
      _plants[index].bloomStage = stage;
      await _savePlants();
      notifyListeners();
    }
  }

  Future<void> addPlant({
    required String name,
    required String scientificName,
    required String category,
    required String lightRequirement,
    required int wateringIntervalDays,
    required String notes,
  }) async {
    final newPlant = FloraItem(
      id: 'flora_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      scientificName: scientificName,
      category: category,
      lightRequirement: lightRequirement,
      wateringIntervalDays: wateringIntervalDays,
      lastWatered: DateTime.now(),
      soilMoisture: 75.0,
      bloomStage: 'Budding',
      bloomProgress: 0.35,
      notes: notes,
    );
    _plants.add(newPlant);
    await _savePlants();
    notifyListeners();
  }

  Future<void> removePlant(String id) async {
    _plants.removeWhere((p) => p.id == id);
    await _savePlants();
    notifyListeners();
  }

  Future<void> toggleVentilation() async {
    _ventilationActive = !_ventilationActive;
    if (_ventilationActive) {
      _currentTemp = (_currentTemp - 0.6).clamp(15.0, 35.0);
      _currentHumidity = (_currentHumidity - 3.0).clamp(30.0, 95.0);
    }
    await _saveEnv();
    notifyListeners();
  }

  Future<void> toggleMisting() async {
    _mistingActive = !_mistingActive;
    if (_mistingActive) {
      _currentHumidity = (_currentHumidity + 5.0).clamp(30.0, 95.0);
    }
    await _saveEnv();
    notifyListeners();
  }

  Future<void> setTargetTemp(double val) async {
    _targetTemp = val;
    await _saveEnv();
    notifyListeners();
  }

  Future<void> setTargetHumidity(double val) async {
    _targetHumidity = val;
    await _saveEnv();
    notifyListeners();
  }

  List<FloraItem> _defaultBotanicalData() {
    return [
      FloraItem(
        id: 'flora_1',
        name: 'Moon Orchid',
        scientificName: 'Phalaenopsis amabilis',
        category: 'Orchid',
        lightRequirement: 'Bright Indirect',
        wateringIntervalDays: 7,
        lastWatered: DateTime.now().subtract(const Duration(days: 3)),
        soilMoisture: 58.0,
        bloomStage: 'Full Bloom',
        bloomProgress: 0.90,
        notes: 'Keep in ventilated conservatory with bark substrate.',
      ),
      FloraItem(
        id: 'flora_2',
        name: 'Swiss Cheese Plant',
        scientificName: 'Monstera deliciosa',
        category: 'Tropical',
        lightRequirement: 'Medium Indirect',
        wateringIntervalDays: 5,
        lastWatered: DateTime.now().subtract(const Duration(days: 6)),
        soilMoisture: 28.0,
        bloomStage: 'Vegetative',
        bloomProgress: 0.15,
        notes: 'Aerial roots misted twice weekly.',
      ),
      FloraItem(
        id: 'flora_3',
        name: 'Boston Fern',
        scientificName: 'Nephrolepis exaltata',
        category: 'Fern',
        lightRequirement: 'Filtered Shade',
        wateringIntervalDays: 3,
        lastWatered: DateTime.now().subtract(const Duration(days: 1)),
        soilMoisture: 72.0,
        bloomStage: 'Spore Fronds',
        bloomProgress: 0.50,
        notes: 'High ambient humidity required. Prone to dry tip burn.',
      ),
      FloraItem(
        id: 'flora_4',
        name: 'Jade Plant',
        scientificName: 'Crassula ovata',
        category: 'Succulent',
        lightRequirement: 'Direct Sunlight',
        wateringIntervalDays: 14,
        lastWatered: DateTime.now().subtract(const Duration(days: 10)),
        soilMoisture: 42.0,
        bloomStage: 'Dormant',
        bloomProgress: 0.05,
        notes: 'Drainage essential, coarse gritty soil mix.',
      ),
      FloraItem(
        id: 'flora_5',
        name: 'Silver Calathea',
        scientificName: 'Calathea orbifolia',
        category: 'Tropical',
        lightRequirement: 'Dappled Shade',
        wateringIntervalDays: 4,
        lastWatered: DateTime.now().subtract(const Duration(days: 4)),
        soilMoisture: 32.0,
        bloomStage: 'Budding',
        bloomProgress: 0.45,
        notes: 'Sensitive to fluoride in tap water. Use rainwater.',
      ),
    ];
  }
}
