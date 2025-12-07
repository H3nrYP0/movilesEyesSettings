// screens/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onItemSelected;
  
  const AppDrawer({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.visibility,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.isAuthenticated 
                    ? '¡Hola, ${authProvider.user?.nombre.split(' ').first}!' 
                    : 'Eyes Settings',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authProvider.isAuthenticated 
                    ? authProvider.user?.correo ?? ''
                    : 'Tu óptica de confianza',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Opciones del menú
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Inicio',
            onTap: () => onItemSelected('home'),
          ),
          
          _buildDrawerItem(
            icon: Icons.store,
            title: 'Catálogo',
            onTap: () => onItemSelected('catalog'),
          ),
          
          // Opciones que requieren autenticación
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Perfil',
            onTap: () => onItemSelected('profile'),
          ),
          
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            onTap: () => onItemSelected('orders'),
          ),
          
          _buildDrawerItem(
            icon: Icons.calendar_today,
            title: 'Agenda',
            onTap: () => onItemSelected('agenda'),
          ),
          
          const Divider(),
          
          // Botón de autenticación
          if (authProvider.isAuthenticated)
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              color: Colors.red,
              onTap: () {
                authProvider.logout();
                onItemSelected('home');
              },
            )
          else
            _buildDrawerItem(
              icon: Icons.login,
              title: 'Iniciar sesión',
              color: Colors.blue,
              onTap: () => onItemSelected('login'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}