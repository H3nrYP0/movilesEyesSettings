import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optica_app/core/constants/api_endpoints.dart';

class ApiService {
  final String baseUrl = ApiEndpoints.baseUrl;
  
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al crear: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  Future<Map<String, dynamic>> put(String endpoint, int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  Future<bool> delete(String endpoint, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}