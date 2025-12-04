// screens/catalog/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/core/services/product_service.dart';
import 'package:optica_app/models/product_model.dart';
import 'package:optica_app/screens/catalog/product_datail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;
  
  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final products = await _productService.getProductsByCategory(widget.category.id);
      setState(() {
        _products = products;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar productos: $e';
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

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.category.nombre);
    final categoryIcon = _getCategoryIcon(widget.category.nombre);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.nombre),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(categoryColor, categoryIcon),
    );
  }

  Widget _buildBody(Color categoryColor, IconData categoryIcon) {
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
                'Error al cargar productos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(_error, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos en ${widget.category.nombre}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Prueba más tarde o contacta al administrador',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header informativo
        Container(
          padding: const EdgeInsets.all(20),
          color: categoryColor.withOpacity(0.1),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.category.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Contador de productos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '${_products.length} producto${_products.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Lista de productos
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = _products[index];
              return _buildProductCard(product, categoryColor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, Color categoryColor) {
    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
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
        child: Row(
          children: [
            // Espacio para imagen (placeholder)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  product.nombre.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
            ),
            
            // Información del producto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Precio
                    Text(
                      '\$${product.precioVenta.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Stock
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: product.stock > product.stockMinimo ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stock: ${product.stock} unidades',
                          style: TextStyle(
                            fontSize: 14,
                            color: product.stock > product.stockMinimo ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    
                    // Descripción corta
                    if (product.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        product.descripcion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Flecha indicadora
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}