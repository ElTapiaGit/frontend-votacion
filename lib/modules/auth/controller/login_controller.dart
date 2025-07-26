import 'package:flutter/material.dart';
import 'package:demo_filestack/core/routes/app_routes.dart';

class LoginController {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login(BuildContext context) {
        final user = usernameController.text;
        final pass = passwordController.text;
        // Simulación: aceptar cualquier credencial válida no vacía
        if (user.isNotEmpty && pass.isNotEmpty) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Usuario o contraseña inválidos")),
            );
        }
    }
}