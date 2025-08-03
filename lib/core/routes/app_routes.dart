import 'package:flutter/material.dart';
import 'package:demo_filestack/modules/auth/view/login_page.dart';
import 'package:demo_filestack/modules/home/view/home_page.dart';
import 'package:demo_filestack/modules/votacion/view/filtrar_mesa.dart';
import 'package:demo_filestack/modules/register_ocr/view/layout_page.dart';
import 'package:demo_filestack/modules/votacion/view/layout_menu.dart';
import 'package:demo_filestack/modules/register_ocr/view/ocr_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String voting = '/votacion';
  static const String registrerOcr = '/registrer-ocr';
  static const String registrarVotacion = '/registrar-votacion';
  static const String registrarocr = '/registrar-ocr';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    voting: (_) => const FiltrarMesaPage(), 
    registrerOcr: (_) => const RegistrarOcrPage(),
    registrarVotacion: (_) => const RegistrarVotacionPage(),
    registrarocr: (_) => const OcrPage(),
  };
}