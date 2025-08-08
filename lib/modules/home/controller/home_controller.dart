import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Elimina todo, incluido el token

    // Navega al login y elimina historial de navegación
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
