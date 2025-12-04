import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/appointments/agenda_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'Eyes Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Botones de autenticación SOLO si NO está autenticado
          if (!authProvider.isAuthenticated) ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            // Si está autenticado, mostrar avatar o nombre
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                authProvider.user?.nombre.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      body: Center(
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
              
              // ÚNICO botón principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CatalogScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text(
                    'Ver Catálogo',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
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
      ),
    );
  }

  // Método para construir el drawer
  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
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
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
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
          
          // Opciones que requieren autenticación
          _buildDrawerItem(
            context,
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {
              Navigator.pop(context);
              _navigateIfAuthenticated(
                context,
                authProvider,
                const ProfileScreen(),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            onTap: () {
              Navigator.pop(context);
              _navigateIfAuthenticated(
                context,
                authProvider,
                const OrdersScreen(),
              );
            },
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today,
            title: 'Agenda',
            onTap: () {
              Navigator.pop(context);
              _navigateIfAuthenticated(
                context,
                authProvider,
                const AgendaScreen(),
              );
            },
          ),
          
          const Divider(),
          
          if (authProvider.isAuthenticated)
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Cerrar sesión',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                authProvider.logout();
              },
            )
          else
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

  // Función simplificada para navegar si está autenticado
  void _navigateIfAuthenticated(
    BuildContext context,
    AuthProvider authProvider,
    Widget screen,
  ) {
    if (authProvider.isAuthenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      // Redirige directamente a login sin diálogo
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // Función para acceso rápido (simula login)
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
}