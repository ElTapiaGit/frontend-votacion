import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/modules/register_ocr/controller/ocr_controller.dart';
import 'package:demo_filestack/modules/register_ocr/widgets/form_input.dart';
import 'package:demo_filestack/modules/register_ocr/controller/votosUninominal_controller.dart';
import 'package:demo_filestack/core/api/api_service.dart';

class UninominalController {
  final MesaModel mesa;
  final VoidCallback onNext;

  final Map<String, TextEditingController> controllers = {};
  final Map<String, GlobalKey<FormInputState>> inputKeys = {};
  late OcrController ocrController;
  late VotosUninominalController votacionController;

  bool isProcessing = false; // para OCR
  bool isSubmitting = false; // para envío de votos

  UninominalController({required this.mesa, required this.onNext}) {
    _initControllers();
    ocrController = OcrController(controllers);
    final dio = Dio();
    votacionController = VotosUninominalController(ApiService(dio));
  }

  void _initControllers() {
    for (var label in [
      'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS-IPSP', 'MORENA', 'UNIDAD', 'PDC',
      'VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
    ]) {
      controllers[label] = TextEditingController();
      inputKeys[label] = GlobalKey<FormInputState>();
    }
  }

  /// Captura imagen desde la cámara y envía al backend OCR
  Future<void> capturarYProcesarImagen(BuildContext context, Function setState) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedImage != null) {
      setState(() => isProcessing = true);
      try {
        await ocrController.sendImageToBackend(File(pickedImage.path));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Imagen procesada correctamente.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al procesar la imagen: $e")),
        );
      } finally {
        setState(() => isProcessing = false);
      }
    }
  }

  /// Valida campos antes de continuar
  Future<void> validarYContinuar(BuildContext context, Function setState) async {
    if (isSubmitting) return; // Evita doble click

    bool todosValidos = true;

    // Validar campos individuales
    for (var key in inputKeys.values) {
      key.currentState?.validarExterno();
      if (!(key.currentState?.esValido ?? false)) {
        todosValidos = false;
      }
    }

    // Si hay campos inválidos
    if (!todosValidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Corrige los campos inválidos')),
      );
      return;
    }

    // Validar sumas máximas
    if (!_validarLimites(context)) return;

    // Construir payload
    final votosPartidos = <String, int>{};
    for (var label in [
      'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS-IPSP', 'MORENA', 'UNIDAD', 'PDC'
    ]) {
      votosPartidos[label] = int.tryParse(controllers[label]?.text ?? '0') ?? 0;
    }

    final votosValidos = int.tryParse(controllers['VOTOS VÁLIDOS']?.text ?? '0') ?? 0;
    final votosBlancos = int.tryParse(controllers['VOTOS BLANCOS']?.text ?? '0') ?? 0;
    final votosNulos = int.tryParse(controllers['VOTOS NULOS']?.text ?? '0') ?? 0;

    setState(() => isSubmitting = true);

    try {
      await votacionController.enviarVotos(
        mesaId: mesa.id ?? '',
        votos: votosPartidos,
        votosValidos: votosValidos,
        votosBlancos: votosBlancos,
        votosNulos: votosNulos,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Votación registrada correctamente')),
      );
      onNext();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al enviar: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  bool _validarLimites(BuildContext context) {
    // Validación de partidos
    final partidos = [
      'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS-IPSP', 'MORENA', 'UNIDAD', 'PDC'
    ];
    final sumaPartidos = partidos.fold<int>(
      0,
      (acum, partido) => acum + (int.tryParse(controllers[partido]?.text ?? '0') ?? 0),
    );
    if (sumaPartidos > 240) {
      _mostrarSnack(context, '⚠️ Suma de partidos ($sumaPartidos) supera el límite de 240');
      return false;
    }

    // Validación de totales
    final totales = ['VOTOS VÁLIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'];
    final sumaTotales = totales.fold<int>(
      0,
      (acum, campo) => acum + (int.tryParse(controllers[campo]?.text ?? '0') ?? 0),
    );
    if (sumaTotales > 240) {
      _mostrarSnack(context, '⚠️ Suma de Votos (Validos, Blancos y Nulos) supera el límite de 240');
      return false;
    }

    return true;
  }

  void _mostrarSnack(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }
}

  
