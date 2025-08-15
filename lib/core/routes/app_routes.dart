import 'package:flutter/material.dart';
import 'package:demo_filestack/modules/auth/view/login_page.dart';
import 'package:demo_filestack/modules/home/view/home_page.dart';
import 'package:demo_filestack/modules/register_ocr/view/mesa_page.dart';
import 'package:demo_filestack/modules/register_ocr/view/ocr_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String registrerOcr = '/registrer-ocr';
  static const String registrarVotacion = '/registrar-votacion';
  static const String mesaocr = '/mesa-ocr';
  static const String registrarocr = '/registrar-ocr';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    mesaocr: (_) => const MesaPage(),
    registrarocr: (_) => const OcrPage(),
  };
}