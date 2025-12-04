// screens/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/appointments/agenda_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.visibility,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Eyes Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tu óptica de confianza',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Opciones del menú
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Inicio',
            onTap: () => Navigator.pop(context),
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.store,
            title: 'Ver Catálogo',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CatalogScreen()),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today,
            title: 'Agenda',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgendaScreen()),
              );
            },
          ),
          
          const Divider(),
          
          // Sección de autenticación
          _buildDrawerItem(
            context,
            icon: Icons.login,
            title: 'Iniciar sesión',
            color: Colors.blue,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.person_add,
            title: 'Registrarse',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
          ),
          
          const Divider(),
          
          // Información adicional
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contacto',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text('📞 (123) 456-7890'),
                Text('✉️ info@eyessettings.com'),
                Text('📍 Calle Principal #123'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}