import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/modules/register_ocr/view/presidencial_page.dart';
//import 'package:demo_filestack/modules/register_ocr/view/uninominal_page.dart';
import 'package:demo_filestack/modules/register_ocr/view/image_page.dart';


class RegistrarOcrPage extends StatefulWidget {
  final MesaModel mesa;
  const RegistrarOcrPage({super.key, required this.mesa});

  @override
  State<RegistrarOcrPage> createState() => _RegistrarOcrPageState();
}

class _RegistrarOcrPageState extends State<RegistrarOcrPage> {
  int currentTab = 0;
  late final List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();
    _tabViews = [
      PresidencialView(
        onNext: () {
          setState(() {
            currentTab = 1;
          });
        }, mesa: widget.mesa,
      ),
      /*UninominalView(
        onNext: () {
          setState(() {
            currentTab = 2;
          });
        }, mesa: widget.mesa,
      ),*/
      ImagenView(
        onNext: () {
          setState(() {
            currentTab = 2;
          });
        },mesa: widget.mesa,
      ),
    ];
  }

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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('Presidenciales', 0),
                      //_buildTabButton('Uninominales', 1),
                      _buildTabButton('Foto Acta', 1),
                    ],
                  ),
                ),
              ),

              // Contenido principal
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(currentTab),
                    decoration: BoxDecoration(
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
          });
        }, //tab deshabilitado
        child:  AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox( //Ajusta automáticamente el texto
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
