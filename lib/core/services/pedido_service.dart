import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optica_app/core/constants/api_endpoints.dart';
import 'package:optica_app/models/pedido_model.dart';

class PedidoService {
  final String _baseUrl = ApiEndpoints.baseUrl;
  
  // Nota: token es ahora opcional con parámetro posicional opcional []
  Future<Pedido> crearPedido(Pedido pedido, [String? token]) async {
    try {
      final url = Uri.parse('$_baseUrl/pedidos');
      
      // Headers base
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      // Solo agregar Authorization si hay token
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      print('📤 Enviando pedido a: $url');
      print('📋 Headers: $headers');
      print('📦 Body: ${json.encode(pedido.toJson())}');
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(pedido.toJson()),
      );
      
      print('📥 Respuesta status: ${response.statusCode}');
      print('📄 Respuesta body: ${response.body}');
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Manejar diferentes formatos de respuesta
        if (data.containsKey('pedido')) {
          return Pedido.fromJson(data['pedido']);
        } else {
          // Si no hay clave 'pedido', asumimos que el objeto completo es el pedido
          return Pedido.fromJson(data);
        }
      } else {
        throw Exception('Error al crear pedido: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en crearPedido: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Nota: token es ahora opcional con parámetro posicional opcional []
  Future<List<Pedido>> obtenerPedidosUsuario(int usuarioId, [String? token]) async {
    try {
      // Usamos el endpoint general de pedidos y filtramos
      final url = Uri.parse('$_baseUrl/pedidos');
      
      // Headers base
      final headers = <String, String>{};
      
      // Solo agregar Authorization si hay token
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      print('📤 Obteniendo pedidos de: $url');
      print('👤 ID usuario: $usuarioId');
      
      final response = await http.get(url, headers: headers);
      
      print('📥 Respuesta status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        print('📊 Total de pedidos recibidos: ${data.length}');
        
        // Filtrar pedidos por usuario_id O cliente_id
        final userPedidos = data.where((json) {
          final isUsuarioMatch = json['usuario_id'] == usuarioId;
          final isClienteMatch = json['cliente_id'] == usuarioId;
          
          if (isUsuarioMatch || isClienteMatch) {
            print('✅ Pedido #${json['id']} pertenece al usuario');
          }
          
          return isUsuarioMatch || isClienteMatch;
        }).toList();
        
        print('👤 Pedidos del usuario: ${userPedidos.length}');
        
        return userPedidos.map((json) => Pedido.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener pedidos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerPedidosUsuario: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Nota: token es ahora opcional con parámetro posicional opcional []
  Future<Pedido> obtenerPedido(int id, [String? token]) async {
    try {
      final url = Uri.parse('$_baseUrl/pedidos/$id');
      
      // Headers base
      final headers = <String, String>{};
      
      // Solo agregar Authorization si hay token
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Pedido.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Pedido no encontrado');
      } else {
        throw Exception('Error al obtener pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en obtenerPedido: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Nota: token es ahora opcional con parámetro posicional opcional []
  Future<void> subirComprobanteTransferencia(
    int pedidoId, 
    String comprobanteUrl, 
    [String? token]
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/pedidos/$pedidoId/comprobante');
      
      // Headers base
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      // Solo agregar Authorization si hay token
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      final body = json.encode({
        'transferencia_comprobante': comprobanteUrl,
      });
      
      final response = await http.put(url, headers: headers, body: body);
      
      if (response.statusCode != 200) {
        throw Exception('Error al subir comprobante: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en subirComprobanteTransferencia: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}