// screens/catalog/catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:optica_app/core/services/category_service.dart';
import 'package:optica_app/models/category_model.dart';
import 'package:optica_app/screens/catalog/category_products_screen.dart';

class CatalogScreen extends StatefulWidget {
  final Function(Category)? onCategorySelected;
  
  const CatalogScreen({
    super.key,
    this.onCategorySelected,
  });

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

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'monturas':
        return const Color(0xFF2196F3); // Azul
      case 'lentes contacto':
        return const Color(0xFF4CAF50); // Verde
      case 'accesorios':
        return const Color(0xFFFF9800); // Naranja
      case 'gafas':
        return const Color(0xFF9C27B0); // Púrpura
      default:
        return const Color(0xFF673AB7); // Deep Purple
    }
  }

  String _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'monturas':
        return '👓';
      case 'lentes contacto':
        return '👁️';
      case 'accesorios':
        return '👜';
      case 'gafas':
        return '🕶️';
      default:
        return '📦';
    }
  }

  Widget _buildCategoryCard(Category category) {
    final categoryColor = _getCategoryColor(category.nombre);
    final categoryIcon = _getCategoryIcon(category.nombre);

    return GestureDetector(
      onTap: () {
  if (widget.onCategorySelected != null) {
    widget.onCategorySelected!(category);
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(category: category),
      ),
    );
  }
},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        height: 160,
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Fondo con degradado
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor.withOpacity(0.8),
                    categoryColor.withOpacity(0.95),
                  ],
                ),
              ),
            ),
            
            // Icono decorativo (opaco)
            Positioned(
              right: 20,
              top: 20,
              child: Text(
                categoryIcon,
                style: const TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
            
            // Contenido sobre la imagen
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  
                  // Nombre de la categoría
                  Text(
                    category.nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  
                  // Descripción
                  if (category.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      category.descripcion,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(); // ← CAMBIO CLAVE: Solo retorna el body
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error al cargar categorías',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 72,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay categorías disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Las categorías se agregarán próximamente',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título y descripción
        Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Selecciona una categoría para ver los productos',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        
        // Lista de categorías
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadCategories,
            color: const Color(0xFF2E7D32),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
        ),
      ],
    );
  }
}