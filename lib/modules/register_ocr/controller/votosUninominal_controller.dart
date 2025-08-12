import 'package:demo_filestack/core/api/api_service.dart';
import 'package:demo_filestack/data/models/votosUninominal_model.dart';

class VotosUninominalController {
  final ApiService apiService;

  VotosUninominalController(this.apiService);

  /// Envía votos uninominales al backend.
  Future<void> enviarVotos({
    required String mesaId,
    required Map<String, int> votos,
    required int votosValidos,
    required int votosBlancos,
    required int votosNulos,
  }) async {
    try {
      // Normalizar keys: reemplazar '-' por '_' (ej: 'MAS-IPSP' -> 'MAS_IPSP')
      final cleanedVotes = <String, int>{};
      votos.forEach((k, v) {
        final key = k.replaceAll('-', '_');
        cleanedVotes[key] = v;
      });

      final request = VotoUninominalRequest(
        mesa: mesaId,
        votos: cleanedVotes,
        votosValidos: votosValidos,
        votosBlancos: votosBlancos,
        votosNulos: votosNulos,
      );

      final response = await apiService.enviarVotoUninominal(request);

      // ignore: avoid_print
      print('✅ VotoUninominal registrado: id=${response.id} mesa=${response.mesa}');
    } catch (e) {
      print('❌ Error enviarVotos (uninominal): $e');
      rethrow;
    }
  }
}
