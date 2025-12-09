import 'package:flutter/material.dart';
import 'package:optica_app/models/order_model.dart';
import 'package:optica_app/core/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;
  String _error = '';
  
  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String get error => _error;
  
  Future<void> createOrder(Order order, String authToken) async {
    _setLoading(true);
    _error = '';
    
    try {
      await _orderService.createOrder(order, authToken);
      _orders.add(order);
      notifyListeners();
    } catch (e) {
      _error = 'Error al crear pedido: $e';
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> loadUserOrders(String userId, String authToken) async {
    _setLoading(true);
    _error = '';
    
    try {
      final ordersData = await _orderService.getUserOrders(userId, authToken);
      
      // Convertir datos de la API a modelos Order
      _orders = ordersData.map((data) {
        return Order(
          id: data['id'].toString(),
          date: DateTime.parse(data['fecha']),
          userId: data['cliente_id'].toString(),
          items: [], // Necesitarías cargar los detalles
          total: (data['total_venta'] as num).toDouble(),
          pickupMethod: data['info_adicional']?['pickup_method'] ?? 'store',
          deliveryAddress: data['info_adicional']?['delivery_address'],
          paymentMethod: data['info_adicional']?['payment_method'] ?? 'cash',
          status: data['info_adicional']?['status'] ?? 'pending',
        );
      }).toList();
      
      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar pedidos: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}