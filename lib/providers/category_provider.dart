// providers/category_provider.dart
import 'package:flutter/material.dart';
import 'package:optica_app/core/services/category_service.dart';
import 'package:optica_app/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  
  List<Category> _categories = [];
  bool _isLoading = false;
  String _error = '';
  
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _categories = await _categoryService.getCategories();
      _error = '';
    } catch (e) {
      _error = 'Error al cargar categorías: $e';
      _categories = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
  
  // Obtener icono según el nombre de la categoría
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'monturas':
        return Icons.account_balance; // O Icons.frame
      case 'lentes contacto':
        return Icons.visibility;
      case 'accesorios':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
  
  // Obtener color según el nombre de la categoría
  Color getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'monturas':
        return Colors.blue;
      case 'lentes contacto':
        return Colors.green;
      case 'accesorios':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}