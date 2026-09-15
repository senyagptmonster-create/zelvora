import 'package:flutter/material.dart';

class GreenhouseData {
  final double temperatureC;
  final double humidityPct;
  final int activeBloomsCount;

  const GreenhouseData({
    required this.temperatureC,
    required this.humidityPct,
    required this.activeBloomsCount,
  });
}

class GreenhouseScope extends InheritedWidget {
  final GreenhouseData data;

  const GreenhouseScope({
    super.key,
    required this.data,
    required super.child,
  });

  static GreenhouseData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GreenhouseScope>();
    assert(scope != null, 'No GreenhouseScope found in context');
    return scope!.data;
  }

  @override
  bool updateShouldNotify(covariant GreenhouseScope oldWidget) {
    return oldWidget.data.humidityPct != data.humidityPct;
  }
}
