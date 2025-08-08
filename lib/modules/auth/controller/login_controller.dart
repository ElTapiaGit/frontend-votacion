import 'package:flutter/material.dart';
import 'package:demo_filestack/core/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:demo_filestack/core/api/api_service.dart';
import 'package:demo_filestack/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ApiService _apiService = ApiService(Dio());

  Future<void> login(BuildContext context, Function(bool) setLoading) async {
    final user = usernameController.text.trim();
    final pass = passwordController.text.trim();

    setLoading(true);
    try {
      final response = await _apiService.login(LoginRequest(correo: user, password: pass));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on DioException catch (e) {
      String errorMsg = "Error al iniciar sesión";
      if (e.response?.statusCode == 401) {
        errorMsg = "Correo o contraseña incorrectos";
      } else if (e.response != null) {
        errorMsg = e.response?.data["message"] ?? errorMsg;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error inesperado al iniciar sesión"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setLoading(false);
    }
  }
}