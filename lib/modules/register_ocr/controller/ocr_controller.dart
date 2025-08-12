// lib/modules/ocr/controller/ocr_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class OcrController {
  XFile? image;
  String ocrText = "";
  final Map<String, TextEditingController> controllers;

  OcrController(this.controllers);

  Future<void> selectImage(Function(XFile) onImageSelected) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = pickedImage;
      onImageSelected(pickedImage);
      await sendImageToBackend(File(pickedImage.path));
    }
  }

  Future<void> sendImageToBackend(File imageFile) async {
    final uri = Uri.parse('https://api-ocr-google.onrender.com/ocr');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path, filename: basename(imageFile.path)),
    );

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        ocrText = data['text'] ?? '';
        _fillFormWithVotes(ocrText);
      }
    } else {
      throw Exception('Error al procesar imagen');
    }
  }

  void _fillFormWithVotes(String text) {
    List<String> lines = text.split('\n').map((e) => e.trim()).toList();

    Map<String, String> votes = {
      'AP': '', 'LYP': '', 'ADN': '', 'APB': '', 'SUMATE': '', 'NGP': '',
      'LIBRE': '', 'FP': '', 'MAS-IPSP': '', 'MORENA': '', 'UNIDAD': '',
      'PDC': '', 'VOTOS VÁLIDOS': '', 'VOTOS BLANCOS': '', 'VOTOS NULOS': '',
    };

    for (int i = 0; i < lines.length - 1; i++) {
      final key = lines[i].toUpperCase();
      final next = lines[i + 1];

      if (votes.containsKey(key)) {
        final value = next.replaceAll(RegExp(r'[^\d]'), '');
        if (value.isNotEmpty) {
          votes[key] = value;
        }
      }
    }

    /*votes.forEach((party, vote) {
      if (controllers.containsKey(party)) {
        controllers[party]?.text = vote;
      }
    });*/
    //datos parse para quitar 0 de la izquierda
    votes.forEach((party, vote) {
      if (controllers.containsKey(party)) {
        final numero = int.tryParse(vote);
        controllers[party]?.text = numero != null ? numero.toString() : '';
      }
    });
  }
}
