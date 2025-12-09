import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/screens/orders/cart_screen.dart';

class CartFloatingButton extends StatefulWidget {
  const CartFloatingButton({super.key});

  @override
  State<CartFloatingButton> createState() => _CartFloatingButtonState();
}

class _CartFloatingButtonState extends State<CartFloatingButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    // Solo mostrar si el usuario está autenticado
    if (!authProvider.isAuthenticated || cartProvider.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 80, right: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
          heroTag: 'cart_button',
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          label: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Badge(
                  label: Text(
                    cartProvider.itemCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  alignment: Alignment.topRight,
                  child: const Icon(Icons.shopping_cart),
                ),
                if (_isHovering || cartProvider.itemCount > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '\$${cartProvider.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}