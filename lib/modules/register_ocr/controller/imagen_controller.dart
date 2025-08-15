import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:demo_filestack/data/models/acta_model.dart';
import 'package:demo_filestack/core/api/api_service.dart';
import 'package:dio/dio.dart';

class ImagenController {
  final String filestackApiKey;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService;

  ImagenController({
    required this.filestackApiKey,
    required Dio dio,
  }) : _apiService = ApiService(dio);

  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String> uploadToFilestack(File image) async {
    final uri = Uri.parse(
      'https://www.filestackapi.com/api/store/S3?key=$filestackApiKey',
    );

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('fileUpload', image.path));

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('Tiempo excedido al subir'),
    );

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Error al subir imagen: ${response.statusCode}");
    }

    final data = json.decode(response.body);
    return data['url'];
  }

  Future<ActaModel> enviarActa({
    required String mesaId,
    required String fotoUrl,
    required bool observado,
  }) async {
    final request = ActaRequest(
      mesaId: mesaId,
      foto: fotoUrl,
      observado: observado,
    );
    return await _apiService.crearActa(request);
  }
}
