import 'package:flutter/material.dart';
import 'package:demo_filestack/modules/auth/view/login_page.dart';
import 'package:demo_filestack/modules/home/view/home_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
  };
}