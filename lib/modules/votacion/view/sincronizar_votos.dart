
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/votacion/controller/sincronizar_controller.dart';
import 'package:dio/dio.dart';

class SincronizarView extends StatefulWidget {
  final MesaModel mesa;
  const SincronizarView({super.key, required this.mesa});

  @override
  State<SincronizarView> createState() => _SincronizarViewState();
}

class _SincronizarViewState extends State<SincronizarView> {
  File? _image;
  String? _uploadedUrl;
  bool _isUploading = false;
  bool _hasObservaciones = false;

  late SincronizarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SincronizarController(
      filestackApiKey: 'ABIM6pHDMRhydfHR0JwjGz',
      dio: Dio(),
    );
  }

  Future<void> _captureImage() async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.gallery); //para seleccionar
    final file = await _controller.captureImage(); //para tomar foto
    if (file != null) {
      setState(() {
        _image = file;
        _uploadedUrl = null;
      });
    }
  }

  Future<void> _selectImage() async {
    final file = await _controller.selectImage();
    if (file != null) {
      setState(() {
        _image = file;
        _uploadedUrl = null;
      });
    }
  }

  Future<void> _uploadToFilestack() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Primero tome o seleccione una imagen.")),
      );
      return;
    }

    setState(() => _isUploading = true); // Inicia el loading
    final url = await _controller.uploadToFilestack(_image!); //subir a filestack

    if (url != null) {
      setState(() {
        _uploadedUrl = url;
      });

      // Enviar al backend
      final acta = await _controller.enviarActa(
        mesaId: widget.mesa.id,
        fotoUrl: url,
        observado: _hasObservaciones,
      );

      setState(() => _isUploading = false);

      if (acta != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Acta registrada con éxito.")),
        );
        // Cierra esta vista y regresa a la anterior (FiltrarMesaPage)
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error al registrar el acta.")),
        );
      }
    } else {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al subir la imagen.")),
      );
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
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                    'Subida de Boleta',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, height: 250, fit: BoxFit.cover),
                      )
                    : Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "No se ha tomado ninguna foto",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _captureImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Tomar Foto", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _selectImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Seleccionar", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      "Observaciones:",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: _hasObservaciones,
                      onChanged: (value) {
                        setState(() {
                          _hasObservaciones = value ?? false;
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: AppColors.secondary,
                    ),
                  ],
                ),
                 const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadToFilestack,
                  icon: const Icon(Icons.cloud_upload),
                  label: _isUploading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Subir y Enviar", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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
}
