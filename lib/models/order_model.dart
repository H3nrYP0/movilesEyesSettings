// lib/models/order_model.dart - VERSIÓN CORREGIDA
import 'package:optica_app/models/cart_item_model.dart';

class Order {
  final String id;
  final DateTime date;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String pickupMethod;
  final String? deliveryAddress;
  final String paymentMethod;
  final String status;
  
  Order({
    required this.id,
    required this.date,
    required this.userId,
    required this.items,
    required this.total,
    required this.pickupMethod,
    this.deliveryAddress,
    required this.paymentMethod,
    this.status = 'pending',
  });
  
  Map<String, dynamic> toMap() {
    return {
      'cliente_id': userId, // ← CAMBIÉ: usar userId directamente como String
      'total_venta': total,
      'metodo_pago': _getPaymentMethodForAPI(),
      'detalles': _getDetailsForAPI(),
    };
  }
  
  String _getPaymentMethodForAPI() {
    if (paymentMethod == 'cash') return 'Efectivo';
    if (paymentMethod == 'transfer') return 'Transferencia';
    return 'Efectivo';
  }
  
  List<Map<String, dynamic>> _getDetailsForAPI() {
    return items.map((item) {
      return {
        'producto_id': item.product.id, // ← CAMBIÉ: usar id como String
        'cantidad': item.quantity,
        'precio_unitario': item.product.precioVenta,
        'descuento': 0.0,
      };
    }).toList();
  }
}