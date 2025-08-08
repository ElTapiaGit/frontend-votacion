import 'package:demo_filestack/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      // No hay token, redirigir al login
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

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
                      onPressed: () => _controller.logout(context),
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
