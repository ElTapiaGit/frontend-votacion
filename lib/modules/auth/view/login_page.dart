import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/auth/controller/login_controller.dart';
import 'package:demo_filestack/widgets/custom_input.dart';
import 'package:demo_filestack/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final LoginController _controller = LoginController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                            children: [
                                const Text(
                                    "CONTROL DE VOTACIÓN",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                                const SizedBox(height: 20),
                                Image.asset('assets/images/logo.png', height: 120),
                                const SizedBox(height: 30),
                                CustomInputField(
                                    controller: _controller.usernameController,
                                    hintText: 'Usuario',
                                    icon: Icons.person,
                                ),
                                const SizedBox(height: 20),
                                CustomInputField(
                                    controller: _controller.passwordController,
                                    hintText: 'Contraseña',
                                    icon: Icons.lock,
                                    isPassword: true,
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                    text: 'Ingresar',
                                    onPressed: () {
                                      _controller.login(context);
                                    },
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
