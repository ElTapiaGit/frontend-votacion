import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/votacion/view/registrar_votos.dart';

class Votacion2View extends StatefulWidget {
  const Votacion2View({super.key});

  @override
  State<Votacion2View> createState() => _Votacion2ViewState();
}

class _Votacion2ViewState extends State<Votacion2View> {
  String? barcodeText;
  final TextEditingController mesaController = TextEditingController();
  bool isLoading = false;

  Future<void> _pickAndScanImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);

      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final code = barcodes.first.rawValue ?? 'Codigo no reconocido';
        setState(() {
          barcodeText = code;
        });
        print('Codigo detectado: $code');
      } else {
        setState(() {
          barcodeText = 'No se detecto ningun codigo';
        });
        print('No se detecto ningun codigo de barras.');
      }

      await barcodeScanner.close();
    } else {
      print('No se selecciono ninguna imagen.');
    }
  }

  Future<void> _continuar() async {
    final nroMesa = mesaController.text.trim();
    if (barcodeText == null || nroMesa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe escanear el código y llenar el número de mesa')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simula proceso y validación (futuro POST al backend)
    await Future.delayed(const Duration(seconds: 2));

    final datos = {
      'codigo_barras': barcodeText,
      'nro_mesa': nroMesa,
    };
    print('Datos listos para enviar: $datos');

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistrarVotosPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickAndScanImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  //formulario
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Escanear codigo de barras'),
                ),
                const SizedBox(height: 20),
                Text(
                  barcodeText != null ? 'Resultado: $barcodeText' : 'Esperando escaneo...',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24,),
                const Text(
                  'Nro. Mesa',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: mesaController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Ingrese nro. mesa',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Continuar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}