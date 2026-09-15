import 'package:flutter/material.dart';
import 'screens/greenhouse_hub_screen.dart';
import 'state/greenhouse_scope.dart';
import 'theme/zelvora_theme.dart';

class ZelvoraApp extends StatelessWidget {
  const ZelvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    const data = GreenhouseData(
      temperatureC: 24.8,
      humidityPct: 78.0,
      activeBloomsCount: 12,
    );

    return GreenhouseScope(
      data: data,
      child: MaterialApp(
        title: 'Zelvora Greenhouse Hub',
        debugShowCheckedModeBanner: false,
        theme: ZelvoraTheme.themeData,
        home: const GreenhouseHubScreen(),
      ),
    );
  }
}
