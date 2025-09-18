import 'package:flutter/material.dart';
import 'package:time_planner/src/core/app/app_pages.dart';

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Time Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routerConfig: AppPages.router,
    );
  }
}