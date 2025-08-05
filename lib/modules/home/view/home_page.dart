import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'SISTEMA DE VOTACIÓN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 60),

            // Botones centrados
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context: context,
                      label: 'Registro con IA',
                      onPressed: () {
                        Navigator.pushNamed(context, '/mesa-ocr');
                      },
                      description: 'Registra votaciones mediante (OCR).',
                    ),
                    const SizedBox(height: 20),

                    _buildActionButton(
                      context: context,
                      label: 'Registrar Votación',
                      onPressed: () {
                        Navigator.pushNamed(context, '/votacion');
                      },
                      description: 'Registrar votaciones de forma manual.',
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      context: context,
                      label: 'Sincronizar',
                      onPressed: () {
                        //Agregar funcionalidad de sincronización
                      },
                      description: 'Envía los datos registrados a la base de datos.',
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      context: context,
                      label: 'Salir',
                      onPressed: () {
                        // Regresar al login
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      color: Colors.redAccent,
                      description: 'Cierra la sesión y regresa al inicio.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    Color? color,
    required String description,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,  // Un poco mayor para asegurar mayor legibilidad
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6), // Espaciado entre el texto y la descripción
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,  // Tamaño de texto más pequeño para la descripción
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
