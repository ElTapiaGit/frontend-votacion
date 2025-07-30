import 'package:flutter/material.dart';
import 'package:demo_filestack/core/routes/app_routes.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Validación de email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es obligatorio';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  /// Validación de contraseña
  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contraseña es obligatoria';
    }

    return null;
  }

  void login(BuildContext context) {
    final user = usernameController.text.trim();
    final pass = passwordController.text.trim();

    final emailError = validateEmail(user);
    final passError = validatePassword(pass);

    if (emailError == null && passError == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Correo y/o contraseña inválidos"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}