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
      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);
      await barcodeScanner.close();


      if (barcodes.isNotEmpty) {
        final raw = barcodes.first.rawValue;
        print('Código escaneado rawValue: $raw');

        if (raw != null) {
          barcodeText = raw;
          print('Código escaneado convertido a string: $barcodeText');
          return barcodeText; // ✅ Este valor se devuelve correctamente
        } else {
          print('El código escaneado es nulo');
          return null;
        }
      } else {
        print('No se detectó ningún código en la imagen');
        return null;
      }
    } else {
      print('No se seleccionó ninguna imagen');
    }
    return null;
  }

  /// Valida si hay un campo válido antes de buscar
  bool validarCampos(BuildContext context) {
    final nroMesa = mesaController.text.trim();

    if (barcodeText == null && nroMesa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe ingresar el número de mesa o escanear un código')),
      );
      return false;
    }

    if (nroMesa.isNotEmpty && int.tryParse(nroMesa) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El número de mesa debe ser un valor numérico')),
      );
      return false;
    }

    return true;
  }

  /// Obtiene la mesa desde la API dependiendo del tipo de entrada
  Future<MesaModel?> obtenerDatosMesa(BuildContext context, {String? scannedValue}) async {
    try {
      // Si se escaneó un código de barras (numMesa)
      if (scannedValue != null) {
        print('Buscando mesa con numero mesa escaneado: $scannedValue'); 
        return await _api.getMesaByNum(scannedValue);
      }
      // Si se ingresó manualmente un código (codigoMesa)
      final inputCode = mesaController.text.trim();
      if (inputCode.isNotEmpty) {
        final codigoMesa = int.parse(inputCode);
        print('Buscando mesa con codigo ingresado: $codigoMesa');
        return await _api.getMesaByCodigo(codigoMesa);
      }
      print('No se proporcionó ni código ni número de mesa');
      return null;
    } catch (e) {
      print('Error al obtener datos de mesa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró la mesa')),
      );
      return null;
    }
  }
}
