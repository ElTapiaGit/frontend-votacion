import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/core/api/api_service.dart';

class FiltrarMesaController {
  final TextEditingController mesaController = TextEditingController();
  String? barcodeText;
  bool isLoading = false;

  final ApiService _api = ApiService(Dio());

  /// Escanea una imagen desde la cámara para leer el código de barras
  Future<String?> pickAndScanImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      // Configurar para aceptar varios formatos de código de barras
      final barcodeScanner = BarcodeScanner(
        formats: [
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upca,
          BarcodeFormat.upca,
          BarcodeFormat.itf,
          BarcodeFormat.qrCode, // por si acaso
          BarcodeFormat.pdf417,
        ],
      );
      final barcodes = await barcodeScanner.processImage(inputImage);
      await barcodeScanner.close();

      if (barcodes.isNotEmpty) {
        final raw = barcodes.first.rawValue;

        if (raw != null) {
          final raw = barcodes.first.rawValue;

          if (raw != null) {
            barcodeText = raw.trim();
            return barcodeText;
          }
        } 
        return null;
      } else {
        return null;
      }
    } 
    return null;
  }

  /// Valida si hay un campo válido antes de buscar
  bool validarCampos(BuildContext context) {
    final nroMesa = mesaController.text.trim();

    if (barcodeText == null && nroMesa.isEmpty) {
      _showSnackBar(context, 'Debe ingresar el codigo de mesa o escanear codigo de barras', bgColor: Colors.orange);
      return false;
    }

    if (nroMesa.isNotEmpty && int.tryParse(nroMesa) == null) {
      _showSnackBar(context, 'El codigo de mesa debe ser un valor numérico', bgColor: Colors.orange);
      return false;
    }

    return true;
  }

  /// Obtiene la mesa desde la API dependiendo del tipo de entrada
  Future<MesaModel?> obtenerDatosMesa(BuildContext context, {String? scannedValue}) async {
    try {
      // 1 Si se escaneó un código de barras (numMesa)
      if (scannedValue != null) {
        // Validar si es codigoMesa o numMesa
        final onlyDigits = RegExp(r'^\d+$');
        if (onlyDigits.hasMatch(scannedValue)) {
          if (scannedValue.length <= 8) {
            // Probablemente es codigoMesa
            final codigoMesa = int.parse(scannedValue);
            return await _buscarPorCodigo(context, codigoMesa);
          } else {
            // Probablemente es numMesa
            return await _buscarPorNum(context, scannedValue);
          }
        } else {
          // Si no es numérico, lo tratamos como numMesa (string)
          return await _buscarPorNum(context, scannedValue);
        }
      }
      // Si se ingresó manualmente un código (codigoMesa)
      final inputCode = mesaController.text.trim();
      if (inputCode.isNotEmpty) {
        final codigoMesa = int.parse(inputCode);
        final mesa = await _api.getMesaByCodigo(codigoMesa);
        if (mesa == null) {
          _showSnackBar(context, 'Mesa no encontrada', bgColor: const Color(0xFFFF7300));
        }
        return mesa;
      }

      _showSnackBar(context, 'Debe ingresar un código o escanear codigo de barras', bgColor: Colors.orange);
      return null;

    }  on DioError catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response?.statusCode == 404) {
        // Mostrar el mensaje que envía la API si lo manda
        final msg = dioError.response?.data is Map && dioError.response?.data['msg'] != null
            ? dioError.response?.data['msg']
            : 'Mesa no encontrada';
        _showSnackBar(context, msg, bgColor: const Color(0xFFFF7300));
        return null;
      }

      _showSnackBar(context, 'Error de conexión con el servidor. Espere un momento antes de volver a intentar...', bgColor: Colors.redAccent);
      return null;

    }catch (e) {
      _showSnackBar(context, 'Error inesperado', bgColor: Colors.redAccent);
      return null;
    }
  }

  /// Helper para buscar por codigoMesa
  Future<MesaModel?> _buscarPorCodigo(BuildContext context, int codigo) async {
    final mesa = await _api.getMesaByCodigo(codigo);
    if (mesa == null) {
      _showSnackBar(context, 'Mesa no encontrada', bgColor: const Color(0xFFFF7300));
    }
    return mesa;
  }

  /// Helper para buscar por numMesa
  Future<MesaModel?> _buscarPorNum(BuildContext context, String num) async {
    final mesa = await _api.getMesaByNum(num);
    if (mesa == null) {
      _showSnackBar(context, 'Mesa no encontrada', bgColor: const Color(0xFFFF7300));
    }
    return mesa;
  }

  void _showSnackBar(BuildContext context, String message, {Color bgColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}


