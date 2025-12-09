import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/cart_provider.dart';
import 'package:optica_app/screens/orders/delivery_address_screen.dart';
import 'package:optica_app/screens/orders/payment_method_screen.dart';

class PickupMethodScreen extends StatelessWidget {
  const PickupMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Pedido'),
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
              '¿Deseas recoger el pedido en tienda física?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 24),
            
            // Opción 1: Recoger en tienda
            _buildOptionCard(
              context: context,
              title: 'Sí, recoger en tienda',
              subtitle: 'Sin costo de envío',
              value: 'store',
            ),
            
            const SizedBox(height: 16),
            
            // Opción 2: Envío a domicilio
            _buildOptionCard(
              context: context,
              title: 'No, envío a domicilio',
              subtitle: 'Entrega en tu dirección',
              value: 'delivery',
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
                  const Text('Total del pedido:', style: TextStyle(fontSize: 18)),
                  Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botón (deshabilitado hasta seleccionar)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Por ahora vamos directo a pago
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(
                        pickupMethod: 'store',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        if (value == 'delivery') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeliveryAddressScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentMethodScreen(pickupMethod: value),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}