import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/votacion/view/votacion_1.dart';
import 'package:demo_filestack/modules/votacion/view/votacion_2.dart';
import 'package:demo_filestack/modules/votacion/view/sincronizar_votos.dart';


class RegistrarVotacionPage extends StatefulWidget {
  const RegistrarVotacionPage({super.key});

  @override
  State<RegistrarVotacionPage> createState() => _RegistrarVotacionPageState();
}

class _RegistrarVotacionPageState extends State<RegistrarVotacionPage> {
  int currentTab = 0;

  final List<Widget> _tabViews = const [
    Votacion1View(),
    Votacion2View(),
    SincronizarView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Header estilo AppBar
              Container(
                width: double.infinity,
                color: AppColors.primary,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  children: [
                    const Text(
                      'ELECCIONES NACIONALES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menu TabBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('Presidenciales', 0),
                            _buildTabButton('Uninominales', 1),
                            _buildTabButton('Sincronizar votos', 2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contenido principal
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(currentTab),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      //color: Colors.white.withValues(alpha: 0.15), // Efecto cristalino
                      color: Colors.white.withAlpha(30), // Transparencia
                      borderRadius: BorderRadius.circular(0), // Sin borde superior redondeado
                      backgroundBlendMode: BlendMode.overlay,
                    ),
                    child: _tabViews[currentTab],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentTab = index;
            //resetCampos();
          });
        },
        child:  AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
