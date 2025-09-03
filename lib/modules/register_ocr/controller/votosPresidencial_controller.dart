import 'package:demo_filestack/data/models/votosPresidencial_model.dart';
import 'package:demo_filestack/core/api/api_service.dart';

class VotacionController {
  final ApiService apiService;

  VotacionController(this.apiService);

  Future<void> enviarVotacionPresidencial({
    required String mesaId,
    required Map<String, int> votos,
    required int votosValidos,
    required int votosBlancos,
    required int votosNulos,
  }) async {
    // Normalizar keys: reemplazar '-' por '_' (ej: 'MAS-IPSP' -> 'MAS_IPSP')
      final cleanedVotes = <String, int>{};
      votos.forEach((k, v) {
        final key = k.replaceAll('-', '_');
        cleanedVotes[key] = v;
      }); 
    final request = VotoPresidencialRequest(
      mesa: mesaId,
      votos: cleanedVotes,
      votosValidos: votosValidos,
      votosBlancos: votosBlancos,
      votosNulos: votosNulos,
    );

    try {
      final response = await apiService.enviarVotosPresidenciales(request);
      // ignore: avoid_print
      print('✅ Votación registrada: ${response.id}');
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error al enviar votación: $e');
      rethrow;
    }
  }
}
