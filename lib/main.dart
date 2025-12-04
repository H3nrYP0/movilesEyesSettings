import 'package:flutter/material.dart';
import 'package:optica_app/app.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/screens/auth/login_screen.dart';
import 'package:optica_app/screens/auth/register_screen.dart';
import 'package:optica_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/category_provider.dart';
import 'package:optica_app/screens/catalog/catalog_screen.dart';
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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const App(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
           '/catalog': (context) => const CatalogScreen(),
        },
      ),
    );
  }
}