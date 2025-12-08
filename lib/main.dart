// main.dart - VERSIÓN CORREGIDA
import 'package:flutter/material.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/providers/category_provider.dart';
import 'package:optica_app/screens/main_layout_screen.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart';
import 'package:optica_app/screens/catalog/product_datail_screen.dart'; // ← Corregí el nombre del archivo
import 'package:optica_app/screens/profile/profile_screen.dart';
import 'package:optica_app/screens/orders/orders_screen.dart';
import 'package:optica_app/screens/appointments/agenda_screen.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/models/product_model.dart';
import 'package:provider/provider.dart';

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
          useMaterial3: true, // ← Añade esta línea
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
          '/agenda': (context) => const AgendaScreen(),
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