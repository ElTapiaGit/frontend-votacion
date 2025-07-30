
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:demo_filestack/core/constants/app_colors.dart';

class SincronizarView extends StatefulWidget {
  const SincronizarView({super.key});

  @override
  State<SincronizarView> createState() => _SincronizarViewState();
}

class _SincronizarViewState extends State<SincronizarView> {
  File? _image;
  String? _uploadedUrl;
  bool _isUploading = false;
  bool _hasObservaciones = false;
  final ImagePicker _picker = ImagePicker();
  final String filestackApiKey = 'ABIM6pHDMRhydfHR0JwjGz';

  Future<void> _captureImage() async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.gallery); //para seleccionar
    final pickedFile = await _picker.pickImage(source: ImageSource.camera); //para tomar foto
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadedUrl = null;
      });
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadedUrl = null;
      });
    }
  }


  Future<void> _uploadToFilestack() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Primero tome una imagen.")),
      );
      return;
    }

    setState(() => _isUploading = true); // Inicia el loading

    final uri = Uri.parse('https://www.filestackapi.com/api/store/S3?key=$filestackApiKey');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('fileUpload', _image!.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        final url = data['url'] ?? 'Sin URL';

        setState(() {
          _uploadedUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Imagen subida con éxito.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al subir: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error inesperado: $e")),
      );
    } finally {
      setState(() => _isUploading = false); // Finaliza el loading
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
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadToFilestack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cloud_upload),
                            SizedBox(width: 10),
                            Text("Subir a Filestack", style: TextStyle(color: Colors.white)),
                          ],
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
