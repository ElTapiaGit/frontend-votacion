// sincronizar_view.dart
import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class SincronizarView extends StatelessWidget {
  const SincronizarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Sincronización de votos en desarrollo...',
          style: TextStyle(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
