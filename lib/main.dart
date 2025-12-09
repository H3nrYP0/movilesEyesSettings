// main.dart - VERSIÓN ACTUALIZADA CON CARRITO
import 'package:flutter/material.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/providers/category_provider.dart';
import 'package:optica_app/screens/main_layout_screen.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart';
import 'package:optica_app/screens/catalog/product_datail_screen.dart';
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/orders/cart_screen.dart'; // ← NUEVA IMPORTACIÓN
import 'package:optica_app/screens/appointments/agenda_screen.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/order_provider.dart'; // ← Nuev
import 'package:optica_app/screens/orders/pickup_method_screen.dart';
import 'package:optica_app/screens/orders/delivery_address_screen.dart';
import 'package:optica_app/screens/orders/payment_method_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()), // ← Nuevo
      ],
      child: MaterialApp(
        title: 'Eyes Settings',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          useMaterial3: true,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        initialRoute: '/',
        routes: {
  '/': (context) => const MainLayoutScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/catalog': (context) => const CatalogScreen(),
  '/category-products': (context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;
    return CategoryProductsScreen(category: category);
  },
  '/product-detail': (context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return ProductDetailScreen(product: product);
  },
  '/profile': (context) => const ProfileScreen(),
  '/orders': (context) => const OrdersScreen(),
  '/cart': (context) => const CartScreen(),
  '/pickup-method': (context) => const PickupMethodScreen(),
  '/delivery-address': (context) => const DeliveryAddressScreen(),
  '/payment-method': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    return PaymentMethodScreen(
      pickupMethod: args['pickupMethod'] ?? 'store',
      deliveryAddress: args['deliveryAddress'],
    );
  },
},
        // Manejo de rutas no definidas
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Página no encontrada'),
              ),
            ),
          );
        },
      ),
    );
  }
}