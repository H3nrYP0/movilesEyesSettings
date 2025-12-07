// lib/screens/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/screens/widgets/app_drawer.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/screens/home/home_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart';
import 'package:optica_app/screens/catalog/product_datail_screen.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/appointments/agenda_screen.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/models/product_model.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  Widget _currentScreen = const HomeScreen();
  String _currentTitle = 'Eyes Settings';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _changeScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _onDrawerItemSelected(String route) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    switch (route) {
      case 'home':
        _changeScreen(const HomeScreen(), 'Eyes Settings');
        break;
      case 'catalog':
        _changeScreen(
          CatalogScreen(
            onCategorySelected: _navigateToCategoryProducts,
          ),
          'Catálogo',
        );
        break;
      case 'login':
        _changeScreen(const LoginScreen(), 'Iniciar Sesión');
        break;
      case 'register':
        _changeScreen(const RegisterScreen(), 'Registrarse');
        break;
      case 'profile':
        if (authProvider.isAuthenticated) {
          _changeScreen(const ProfileScreen(), 'Perfil');
        } else {
          _changeScreen(const LoginScreen(), 'Iniciar Sesión');
        }
        break;
      case 'orders':
        if (authProvider.isAuthenticated) {
          _changeScreen(const OrdersScreen(), 'Pedidos');
        } else {
          _changeScreen(const LoginScreen(), 'Iniciar Sesión');
        }
        break;
      case 'agenda':
        if (authProvider.isAuthenticated) {
          _changeScreen(const AgendaScreen(), 'Agenda');
        } else {
          _changeScreen(const LoginScreen(), 'Iniciar Sesión');
        }
        break;
    }
  }

  // Función para navegar a productos de categoría
  void _navigateToCategoryProducts(Category category) {
    _changeScreen(
      CategoryProductsScreen(
        category: category,
        onProductSelected: _navigateToProductDetail,
      ),
      category.nombre,
    );
  }

  // Función para navegar a detalle de producto
  void _navigateToProductDetail(Product product) {
    _changeScreen(
      ProductDetailScreen(product: product),
      'Detalle del Producto',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_currentTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Botones de autenticación en el AppBar
          if (!authProvider.isAuthenticated) ...[
            TextButton(
              onPressed: () => _changeScreen(const LoginScreen(), 'Iniciar Sesión'),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _changeScreen(const RegisterScreen(), 'Registrarse'),
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
            // Avatar del usuario autenticado
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
      drawer: AppDrawer(
        onItemSelected: _onDrawerItemSelected,
      ),
      body: _currentScreen,
    );
  }
}