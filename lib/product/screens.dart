import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';

class BloomScheduleScreen extends StatelessWidget {
  const BloomScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Bloom Schedule', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Schedule', style: AppTheme.text(cInk))),
    );
  }
}

class GreenhouseEnvironmentScreen extends StatelessWidget {
  const GreenhouseEnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Environment', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Environment', style: AppTheme.text(cInk))),
    );
  }
}

class SoilHumidityGuideScreen extends StatelessWidget {
  const SoilHumidityGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Humidity Guide', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Guide', style: AppTheme.text(cInk))),
    );
  }
}

class FloraCatalogScreen extends StatelessWidget {
  const FloraCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Flora Catalog', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Catalog', style: AppTheme.text(cInk))),
    );
  }
}
