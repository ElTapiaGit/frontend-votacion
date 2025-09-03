// lib/modules/ocr/view/ocr_page.dart
import 'dart:io';
import 'package:demo_filestack/modules/register_ocr/controller/ocr_controller.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/form_input.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/registrar_button.dart';
import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart'; 
import 'package:image_picker/image_picker.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  final Map<String, TextEditingController> _controllers = {};
  late OcrController _ocrController;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    for (var label in [
      'LIBRE', 'PDC', 'VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
    ]) {
      _controllers[label] = TextEditingController();
    }
    _ocrController = OcrController(_controllers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('Registro de Votación'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await _ocrController.selectImage((pickedImage) {
                    setState(() {
                      _image = pickedImage;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Seleccionar Imagen para OCR',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.file(
                  File(_image!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                      for (var label in [
                        'LIBRE', 'PDC'
                      ])
                        FormInput(label: label, controller: _controllers[label]!),
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
                      for (var label in [
                        'VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
                      ])
                        FormInput(label: label, controller: _controllers[label]!),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RegistrarButton(onPressed: () {
                // Puedes mostrar datos o guardar aquí
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
