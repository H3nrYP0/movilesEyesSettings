import 'package:flutter/material.dart';
import 'package:optica_app/screens/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Ir directo al HomeScreen (sin verificar autenticación)
    return const HomeScreen();
  }
}