// core/services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optica_app/core/constants/api_endpoints.dart';
import 'package:optica_app/models/category_model.dart';

class CategoryService {
  final String baseUrl = ApiEndpoints.baseUrl;
  
  Future<List<Category>> getCategories() async {
    try {
      final url = Uri.parse('$baseUrl/categorias');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Métodos adicionales si los necesitas
  Future<Category> getCategory(int id) async {
    try {
      final url = Uri.parse('$baseUrl/categorias/$id');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Category.fromJson(data);
      } else {
        throw Exception('Error al obtener categoría: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}