// lib/screens/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/screens/widgets/app_drawer.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/screens/home/home_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart';
import 'package:optica_app/screens/catalog/product_datail_screen.dart'; // ← Nombre corregido
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/appointments/agenda_screen.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/models/product_model.dart';
import 'package:optica_app/screens/widgets/cart_floating_button.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  Widget _currentScreen = const HomeScreen();
  String _currentTitle = 'Eyes Settings';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Timer para controlar rapidos cambios de pantalla
  DateTime? _lastScreenChangeTime;

  void _changeScreen(Widget screen, String title) {
    final now = DateTime.now();
    
    // Prevenir cambios demasiado rápidos (menos de 200ms)
    if (_lastScreenChangeTime != null && 
        now.difference(_lastScreenChangeTime!).inMilliseconds < 200) {
      return;
    }
    
    _lastScreenChangeTime = now;
    
    if (mounted) {
      setState(() {
        _currentScreen = screen;
        _currentTitle = title;
      });
    }
    
    // Cerrar drawer con delay para evitar bloqueo
    Future.delayed(const Duration(milliseconds: 50), () {
      _scaffoldKey.currentState?.closeDrawer();
    });
  }

  void _onDrawerItemSelected(String route) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Usar switch con async para mejor performance
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

  // Función optimizada para navegar a productos de categoría
  void _navigateToCategoryProducts(Category category) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CategoryProductsScreen(category: category),
    ),
  );
}

  // Función optimizada para navegar a detalle de producto
  void _navigateToProductDetail(Product product) {
    // Usar un Future para no bloquear la UI
    Future.microtask(() {
      _changeScreen(
        ProductDetailScreen(product: product),
        'Detalle del Producto',
      );
    });
  }

  // Método para manejar el botón de retroceso
  Future<bool> _onWillPop() async {
    // Si no estamos en Home, volver a Home
    if (_currentScreen is! HomeScreen) {
      _changeScreen(const HomeScreen(), 'Eyes Settings');
      return false; // Evita que la app se cierre
    }
    return true; // Permite cerrar la app si ya estamos en Home
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            _currentTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Evitar múltiples toques rápidos
              _scaffoldKey.currentState?.openDrawer();
            },
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
        body: _buildBody(),
        floatingActionButton: const CartFloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
  

  // Widget optimizado para el body
  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(
        key: ValueKey<String>(_currentTitle),
        child: _currentScreen,
      ),
    );
  }
}