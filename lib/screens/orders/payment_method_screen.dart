import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/models/pedido_model.dart';
import 'package:optica_app/core/services/pedido_service.dart';

class PaymentMethodScreen extends StatelessWidget {
  final String pickupMethod;
  final String? deliveryAddress;
  
  const PaymentMethodScreen({
    super.key,
    required this.pickupMethod,
    this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Pago'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Método de Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 24),
            
            // Efectivo
            GestureDetector(
              onTap: () => _processOrder(context, 'efectivo'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.money, color: Colors.green),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Efectivo', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Pagar al recoger el pedido', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Transferencia
            GestureDetector(
              onTap: () => _processOrder(context, 'transferencia'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.account_balance, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transferencia', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Pago por transferencia bancaria', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total a pagar:', style: TextStyle(fontSize: 18)),
                  Text(
                    '\$${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botón Confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _processOrder(context, 'efectivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Confirmar Pedido',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processOrder(BuildContext context, String paymentMethod) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      
      if (authProvider.user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // CORRECCIÓN: Obtener el ID del usuario directamente como int
      // Si user.id es String, convertirlo a int
      dynamic userId = authProvider.user!.id;
      int clienteId;
      int usuarioId;
      
      if (userId is String) {
        clienteId = int.tryParse(userId) ?? 1;
        usuarioId = clienteId;
      } else if (userId is int) {
        clienteId = userId;
        usuarioId = userId;
      } else {
        clienteId = 1;
        usuarioId = 1;
      }
      
      // Crear pedido
      final pedido = Pedido(
        id: 0,
        clienteId: clienteId,
        usuarioId: usuarioId,
        fecha: DateTime.now(),
        total: cartProvider.totalAmount,
        metodoPago: paymentMethod,
        metodoEntrega: pickupMethod,
        direccionEntrega: deliveryAddress,
        estado: 'pendiente',
        items: cartProvider.items.map((cartItem) {
          // Convertir product.id a int
          dynamic productId = cartItem.product.id;
          int productoId;
          
          if (productId is String) {
            productoId = int.tryParse(productId) ?? 1;
          } else if (productId is int) {
            productoId = productId;
          } else {
            productoId = 1;
          }
          
          return DetallePedido(
            id: 0,
            pedidoId: 0,
            productoId: productoId,
            cantidad: cartItem.quantity,
            precioUnitario: cartItem.product.precioVenta,
            subtotal: cartItem.subtotal,
          );
        }).toList(),
      );
      
      // Enviar a la API
      final pedidoService = PedidoService();
      final pedidoCreado = await pedidoService.crearPedido(pedido);
      
      // Mostrar confirmación
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡Pedido Confirmado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pedido #${pedidoCreado.id}'),
              Text('Total: \$${pedidoCreado.total.toStringAsFixed(0)}'),
              Text('Estado: ${pedidoCreado.estado}'),
              const SizedBox(height: 8),
              const Text('Te contactaremos para coordinar.', style: TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}