import 'package:flutter/material.dart';
import 'package:demo_filestack/core/routes/app_routes.dart';

void main() {
  runApp(const VotacionApp());
}

class VotacionApp extends StatelessWidget {
  const VotacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Votación',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
