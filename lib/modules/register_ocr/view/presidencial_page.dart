import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/register_ocr/controller/ocr_controller.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/form_input.dart';

class PresidencialView extends StatefulWidget {
  final VoidCallback onNext;

  const PresidencialView({super.key, required this.onNext});

  @override
  State<PresidencialView> createState() => _PresidencialViewState();
}

class _PresidencialViewState extends State<PresidencialView> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormInputState>> _inputKeys = {};
  late OcrController _ocrController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    for (var label in [
      'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP', 'LIBRE', 'FP', 'MAS-IPSP',
      'MORENA', 'UNIDAD', 'PDC', 'VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
    ]) {
      _controllers[label] = TextEditingController();
      _inputKeys[label] = GlobalKey<FormInputState>();
    }
    _ocrController = OcrController(_controllers);
  }

  Future<void> _capturarYProcesarImagen() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 100,);//imageQuality para max calidad

    if (pickedImage != null) {
      setState(() => _isProcessing = true);
      try {
        await _ocrController.sendImageToBackend(
          File(pickedImage.path),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Imagen procesada correctamente.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al procesar la imagen: $e")),
        );
      } finally {
        setState(() => _isProcessing = false);
      }
    }
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
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Datos de Boleta Presidenciales',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _InfoText(label: 'Departamento', value: 'Cochabamba'),
                      _InfoText(label: 'Provincia', value: 'Cercado'),
                      _InfoText(label: 'Municipio', value: 'Cochabamba'),
                      _InfoText(label: 'Localidad', value: 'Cochabamba'),
                      _InfoText(label: 'Recinto', value: 'Colegio Marista'),
                      _InfoText(label: 'Nro. Mesa', value: '9', highlighted: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _capturarYProcesarImagen,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(
                      _isProcessing ? "Procesando..." : 'Tomar Foto para OCR',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for (var label in [
                        'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
                        'LIBRE', 'FP', 'MAS-IPSP', 'MORENA', 'UNIDAD', 'PDC'
                      ])
                        FormInput(key: _inputKeys[label], label: label, controller: _controllers[label]!),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white70),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for (var label in ['VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'])
                        FormInput(key: _inputKeys[label], label: label, controller: _controllers[label]!),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _RegistrarButton(onNext: widget.onNext, inputKeys: _inputKeys,),
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

class _InfoText extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _InfoText({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: highlighted ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlighted ? Colors.amberAccent : Colors.white,
              fontWeight: highlighted ? FontWeight.w900 : FontWeight.bold,
              fontSize: highlighted ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrarButton extends StatelessWidget {
  final VoidCallback onNext;
  final Map<String, GlobalKey<FormInputState>> inputKeys;
  const _RegistrarButton({required this.onNext, required this.inputKeys,});
  
  void _validarYContinuar(BuildContext context) {
    bool todosValidos = true;

    for (var key in inputKeys.values) {
      key.currentState?.validarExterno();
      if (!(key.currentState?.esValido ?? false)) {
        todosValidos = false;
      }
    }

    if (todosValidos) {
      onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Corrige los campos inválidos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _validarYContinuar(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Registrar Votos',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
