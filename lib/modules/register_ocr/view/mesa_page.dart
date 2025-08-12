import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/register_ocr/view/layout_page.dart';
import 'package:demo_filestack/modules/register_ocr/controller/mesa_controller.dart';

class MesaPage extends StatefulWidget {
  const MesaPage({super.key});

  @override
  State<MesaPage> createState() => _MesaPageState();
}

class _MesaPageState extends State<MesaPage> {
  final FiltrarMesaController _controller = FiltrarMesaController();
  bool isLoading = false;
  String? _barcodeText;
  String _scanStatusMessage = 'Esperando escaneo...';

  Future<void> _pickAndScanImage() async {
    final scanned = await _controller.pickAndScanImage();
    setState(() {
      _barcodeText = scanned;

      if (scanned != null) {
        _scanStatusMessage = 'Resultado: $scanned';
      } else if (_controller.barcodeText == null) {
        _scanStatusMessage = 'No se pudo escanear el código. Intente nuevamente.';
      }
    });

    if (scanned == null) {
      //en caso de no encontrar codigo
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo escanear el codigo. Intente nuevamente'),
          ),
        );
      }
    }
  }

  Future<void> _continuar() async {
    if (!_controller.validarCampos(context)) return;

    setState(() => isLoading = true);
    try {
      final mesa = await _controller.obtenerDatosMesa(context, scannedValue: _barcodeText);
      
      if (mesa != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegistrarOcrPage(mesa: mesa)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
                  _scanStatusMessage,
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
                  controller: _controller.mesaController,
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
