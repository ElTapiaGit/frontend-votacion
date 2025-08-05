class Api {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; //URL a la API

  // Rutas de los endpoints
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  
  static const String user = '$baseUrl/users';
  static const String roles = '$baseUrl/roles';
  static const String mesas = '$baseUrl/mesas';

  static const String votosPresidenciales = '$baseUrl/votos-presidenciales';
  static const String votosUninominales = '$baseUrl/votos-uninominales';
  static const String actas = '$baseUrl/actas';
}
