import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:demo_filestack/data/models/acta_model.dart';
import 'package:demo_filestack/core/api/api_service.dart';
import 'package:dio/dio.dart';

class SincronizarController {
  final String filestackApiKey;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService; // URL de tu backend

  SincronizarController({required this.filestackApiKey, required Dio dio,}): _apiService = ApiService(dio);

  Future<File?> captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadToFilestack(File image) async {
    final uri = Uri.parse('https://www.filestackapi.com/api/store/S3?key=$filestackApiKey');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('fileUpload', image.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        return data['url'] ?? null;
      }
    } catch (e) {
      // Aquí puedes loguear o manejar el error si quieres
      print("Error al subir a Filestack: $e");
    }
    return null;
  }

  Future<ActaModel?> enviarActa({
    required String mesaId,
    required String fotoUrl,
    required bool observado,
  }) async {
    try {
      final request = ActaRequest(
        mesaId: mesaId,
        foto: fotoUrl,
        observado: observado,
      );
      return await _apiService.crearActa(request);
    } catch (e) {
      print("Error al enviar acta: $e");
      return null;
    }
  }
}
