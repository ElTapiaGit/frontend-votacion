import 'package:flutter/material.dart';
import 'package:demo_filestack/modules/auth/view/login_page.dart';
import 'package:demo_filestack/modules/home/view/home_page.dart';
import 'package:demo_filestack/modules/votacion/view/layout_menu.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String voting = '/votacion';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    voting: (_) => const RegistrarVotacionPage(), 
  };
}