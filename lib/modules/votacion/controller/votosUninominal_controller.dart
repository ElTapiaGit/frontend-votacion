import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:demo_filestack/core/api/api_service.dart';
import 'package:demo_filestack/data/models/votosUninominal_model.dart';

class VotosUninominalController {
  final ApiService apiService;

  VotosUninominalController(this.apiService);

  Future<void> enviarVotos({
    required String mesaId,
    required Map<String, TextEditingController> controllers,
    required VoidCallback onSuccess,
    required Function(String) onError,
    required VoidCallback onLoading,
    required VoidCallback onFinish,
  }) async {
    onLoading();

    try {
      final votos = <String, int>{};
      final partidos = [
        'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
        'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC'
      ];

      for (var partido in partidos) {
        final text = controllers[partido]?.text.trim() ?? '';
        votos[partido.replaceAll('-', '_')] = int.tryParse(text.isEmpty ? '0' : text) ?? 0;
      }

      final votosValidos = int.tryParse(controllers['VOTOS VALIDOS']?.text ?? '0') ?? 0;
      final votosBlancos = int.tryParse(controllers['VOTOS BLANCOS']?.text ?? '0') ?? 0;
      final votosNulos = int.tryParse(controllers['VOTOS NULOS']?.text ?? '0') ?? 0;

      final request = VotoUninominalRequest(
        mesa: mesaId,
        votos: votos,
        votosValidos: votosValidos,
        votosBlancos: votosBlancos,
        votosNulos: votosNulos,
      );

      await apiService.enviarVotoUninominal(request);

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      onFinish();
    }
  }
}
