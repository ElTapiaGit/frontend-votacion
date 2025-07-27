// votacion_2_view.dart
import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class Votacion2View extends StatelessWidget {
  const Votacion2View({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Formulario de Votación 2',
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ),
        );
      },
    );
  }
}