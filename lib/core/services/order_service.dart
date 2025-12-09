import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optica_app/core/constants/api_endpoints.dart';
import 'package:optica_app/models/order_model.dart';


class OrderService {
  final String _baseUrl = ApiEndpoints.baseUrl;
  
  Future<String> createOrder(Order order, String authToken) async {
    try {
      final url = Uri.parse('$_baseUrl/ventas');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(order.toMap()),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['id']?.toString() ?? order.id;
      } else {
        throw Exception('Error al crear pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  Future<void> uploadTransferProof(String orderId, String filePath, String authToken) async {
    try {
      final url = Uri.parse('$_baseUrl/ventas/$orderId/transfer-proof');
      final headers = {
        'Authorization': 'Bearer $authToken',
      };
      
      // Aquí normalmente harías una petición multipart para subir el archivo
      // Por ahora simularemos que se subió correctamente
      await Future.delayed(const Duration(seconds: 1));
      print('Comprobante subido para orden: $orderId');
    } catch (e) {
      throw Exception('Error al subir comprobante: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getUserOrders(String userId, String authToken) async {
    try {
      // En tu API no hay un endpoint específico para órdenes de usuario
      // Podrías filtrar las ventas por cliente_id
      final url = Uri.parse('$_baseUrl/ventas');
      final headers = {
        'Authorization': 'Bearer $authToken',
      };
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final userOrders = data.where((venta) => 
          venta['cliente_id'].toString() == userId
        ).toList();
        
        return userOrders.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener órdenes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}