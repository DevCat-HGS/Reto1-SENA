import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/home_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const HomePage(userRole: 'aprendiz'), // El rol se actualizará según el usuario autenticado
    };
  }
}