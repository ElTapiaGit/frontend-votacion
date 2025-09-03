import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/form_input.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/datos_mesa.dart';
import 'package:demo_filestack/modules/register_ocr/controller/uninominal_controller.dart';

class UninominalView extends StatefulWidget {
  final VoidCallback onNext;
  final MesaModel mesa;

  const UninominalView({super.key, required this.onNext, required this.mesa,});

  @override
  State<UninominalView> createState() => _UninominalViewState();
}

class _UninominalViewState extends State<UninominalView> {
  late UninominalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UninominalController(
      mesa: widget.mesa,
      onNext: widget.onNext,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.primary,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header datos mesa
                HeaderDatosMesa(
                  titulo: 'Datos de Boleta Uninominal',
                  mesa: widget.mesa,
                ),
                const SizedBox(height: 16),
                // Botón OCR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _controller.isProcessing ? null : () => _controller.capturarYProcesarImagen(context, setState),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(
                      _controller.isProcessing ? "Procesando..." : 'Tomar Foto para OCR',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campos partidos políticos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for (var label in [
                        'AP', 'ADN', 'SUMATE', 'LIBRE', 'FP', 
                        'MAS-IPSP', 'MORENA', 'UNIDAD', 'PDC'
                      ])
                        FormInput(key: _controller.inputKeys[label], label: label, controller: _controller.controllers[label]!,),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white70),
                const SizedBox(height: 24),
                // Campos totales
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for (var label in ['VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'])
                        FormInput(key: _controller.inputKeys[label], label: label, controller: _controller.controllers[label]!,),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Botón registrar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _controller.isSubmitting
                        ? null
                        : () => _controller.validarYContinuar(context, setState),
                      child:  _controller.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Registrar Votos',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}