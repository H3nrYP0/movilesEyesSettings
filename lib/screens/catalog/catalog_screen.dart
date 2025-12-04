// screens/catalog/catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:optica_app/core/services/category_service.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart'; // Añade esta importación

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar categorías: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'monturas':
        return Icons.account_balance;
      case 'lentes contacto':
        return Icons.visibility;
      case 'accesorios':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String categoryName) {
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

  // Método para navegar a productos de la categoría
  void _navigateToCategoryProducts(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error al cargar categorías',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(_error, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadCategories,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay categorías disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catálogo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Selecciona una categoría para ver los productos',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final icon = _getCategoryIcon(category.nombre);
                final color = _getCategoryColor(category.nombre);

                return GestureDetector(
                  onTap: () => _navigateToCategoryProducts(category),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(icon, color: color),
                      ),
                      title: Text(
                        category.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(category.descripcion),
                      trailing: const Icon(Icons.chevron_right),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}