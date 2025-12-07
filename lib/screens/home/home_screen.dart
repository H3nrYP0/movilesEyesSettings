// lib/screens/home/home_screen.dart - MODIFICADO
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/auth_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _quickAccess(BuildContext context, AuthProvider authProvider) async {
    // Crear usuario de prueba
    final mockUser = {
      'id': 99,
      'nombre': 'Usuario Demo',
      'correo': 'demo@eyessettings.com',
      'rol_id': 2,
      'estado': true,
    };

    // Simular login exitoso
    await authProvider.saveMockUser(mockUser);
    
    // Mostrar snackbar de confirmación
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Acceso rápido activado. Todas las rutas desbloqueadas.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen/logo
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: const Icon(
                Icons.visibility,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            
            // Texto de bienvenida
            const Text(
              'Bienvenido a',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Eyes Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu óptica de confianza. Encuentra las mejores gafas, monturas y accesorios.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            // ÚNICO botón principal - AHORA DEBE NAVEGAR DENTRO DEL LAYOUT
            // (Esto se manejará desde MainLayoutScreen)
            const SizedBox(height: 16),
            
            // Botón de acceso rápido (SOLO para desarrollo/testing)
            if (!authProvider.isAuthenticated)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Simular login rápido con usuario de prueba
                    _quickAccess(context, authProvider);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.green),
                  ),
                  child: const Text(
                    'Acceso Rápido (Demo)',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}