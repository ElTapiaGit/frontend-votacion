import 'dart:async';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/register_ocr/controller/imagen_controller.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ImagenView extends StatefulWidget {
  final MesaModel mesa;
  const ImagenView({super.key, required this.mesa});

  @override
  State<ImagenView> createState() => _ImagenViewState();
}

class _ImagenViewState extends State<ImagenView> {
  File? _image;
  String? _uploadedUrl;
  bool _isUploading = false;
  bool _hasObservaciones = false;

  late ImagenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ImagenController(
      filestackApiKey: 'ABIM6pHDMRhydfHR0JwjGz',
      dio: Dio(),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickAndSetImage(ImageSource source) async {
    final file = await _controller.pickImage(source);
    if (file != null && mounted) {
      setState(() {
        _image = file;
        _uploadedUrl = null;
      });
    }
  }

  Future<void> _uploadToFilestack() async {
    if (_image == null) {
      _showMessage("Primero tome o seleccione una imagen.", isError: true);
      return;
    }

    setState(() => _isUploading = true); // Inicia el loading

    try {
      final url = await _controller.uploadToFilestack(_image!); //subir a filestack
      // Enviar al backend
      final acta = await _controller.enviarActa(
        mesaId: widget.mesa.id,
        fotoUrl: url,
        observado: _hasObservaciones,
      );
      setState(() {
        _isUploading = false;
        _uploadedUrl = url;
      });

      _showMessage("✅ Acta registrada con éxito.");
      Navigator.pop(context);

    } on TimeoutException catch (_) {
      setState(() => _isUploading = false);
      _showMessage(
        "⏳ Tiempo excedido. Intente mas tarde cuando tenga mejor señal.",
        isError: true,
      );
    } on DioError catch (dioError) {
      setState(() => _isUploading = false);

      // Si el backend envía un JSON con el mensaje
      if (dioError.response?.statusCode != null &&
          dioError.response?.data is Map &&
          dioError.response?.data['msg'] != null) {
        _showMessage("❌ ${dioError.response?.data['msg']}", isError: true);
      } else {
        _showMessage("❌ Error al comunicarse con el servidor.", isError: true);
      }

    } catch (e) {
      setState(() => _isUploading = false);
      _showMessage("❌ Error inesperado. Por favor intentelo mas tarde", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          color: AppColors.primary,
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            //padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Subida de Boleta',
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, height: 250, fit: BoxFit.cover),
                      )
                    : _placeholder(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _button(Icons.camera_alt, "Tomar Foto", () => _pickAndSetImage(ImageSource.camera), AppColors.accent),
                    const SizedBox(width: 12),
                    _button(Icons.photo_library, "Seleccionar", () => _pickAndSetImage(ImageSource.gallery), Colors.teal),
                  ],
                ),

                const SizedBox(height: 12),
                _observacionesCheckbox(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadToFilestack,
                  icon: const Icon(Icons.cloud_upload),
                  label: _isUploading
                      ? const SizedBox(
                          height: 40, width: 40,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Subir y Enviar", style: TextStyle(color: Colors.white)),
                  style: _buttonStyle(AppColors.secondary),
                ),
                const SizedBox(height: 20),
                if (_uploadedUrl != null)
                  SelectableText(
                    '✅ Imagen subida:\n$_uploadedUrl',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder() => Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text("No se ha tomado ninguna foto", style: TextStyle(color: Colors.white70)),
        ),
      );

  Widget _button(IconData icon, String label, VoidCallback onPressed, Color color) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: _buttonStyle(color),
      ),
    );
  }

  Widget _observacionesCheckbox() {
    return Row(
      children: [
        const Text(
          "Observaciones:",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        Checkbox(
          value: _hasObservaciones,
          onChanged: (value) => setState(() => _hasObservaciones = value ?? false),
          checkColor: Colors.white,
          activeColor: AppColors.secondary,
          side: BorderSide(color: Colors.white, width: 2),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      //padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
