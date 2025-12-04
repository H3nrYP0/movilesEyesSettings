// core/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optica_app/core/constants/api_endpoints.dart';
import 'package:optica_app/models/product_model.dart';

class ProductService {
  final String baseUrl = ApiEndpoints.baseUrl;
  
  // Obtener todos los productos
  Future<List<Product>> getProducts() async {
    try {
      final url = Uri.parse('$baseUrl/productos');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Obtener productos por categoría
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final allProducts = await getProducts();
      return allProducts.where((product) => product.categoriaId == categoryId).toList();
    } catch (e) {
      throw Exception('Error al obtener productos por categoría: $e');
    }
  }
  
  // Obtener producto por ID
  Future<Product> getProduct(int id) async {
    try {
      final url = Uri.parse('$baseUrl/productos/$id');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Error al obtener producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}