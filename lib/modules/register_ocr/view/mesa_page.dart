import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/register_ocr/view/layout_page.dart';

class MesaPage extends StatefulWidget {
  const MesaPage({super.key});

  @override
  State<MesaPage> createState() => _MesaPageState();
}

class _MesaPageState extends State<MesaPage> {
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
        final code = barcodes.first.rawValue ?? 'Código no reconocido';
        setState(() {
          barcodeText = code;
        });
      } else {
        setState(() {
          barcodeText = 'No se detectó ningún código';
        });
      }

      await barcodeScanner.close();
    } else {
      setState(() {
        barcodeText = 'No se seleccionó ninguna imagen.';
      });
    }
  }

  Future<void> _continuar() async {
    final nroMesa = mesaController.text.trim();

    // Validar que al menos uno de los dos campos tenga información
    if ((barcodeText == null || barcodeText!.isEmpty || barcodeText == 'No se detectó ningún código') &&
        nroMesa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe ingresar el número de mesa o escanear un código')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); //espere 2 segundo de carga

    final datos = {
      if (barcodeText != null && barcodeText!.isNotEmpty && barcodeText != 'No se detectó ningún código')
        'codigo_barras': barcodeText,
      if (nroMesa.isNotEmpty) 'nro_mesa': nroMesa,
    };
    print('Datos para enviar: $datos');

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistrarOcrPage()),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1, 
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'ELECCIONES',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: _pickAndScanImage,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Escanear código de barras'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), 
                child: Text(
                  barcodeText != null ? 'Resultado: $barcodeText' : 'Esperando escaneo...',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), 
                child: const Text(
                  'Código Mesa:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: mesaController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Ingrese codigo mesa',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _continuar,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
