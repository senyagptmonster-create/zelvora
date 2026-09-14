import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ZelvoraStore extends ChangeNotifier {
  List<dynamic> schedule = [];
  Map<String, dynamic> environment = {};

  ZelvoraStore() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('zelvora_data');
    if (data != null) {
      final map = jsonDecode(data);
      schedule = map['schedule'] ?? [];
      environment = map['environment'] ?? {};
      notifyListeners();
    }
  }

  Future<void> addSchedule(String plant) async {
    schedule.add({"plant": plant, "date": DateTime.now().toIso8601String()});
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zelvora_data', jsonEncode({'schedule': schedule, 'environment': environment}));
  }
}
