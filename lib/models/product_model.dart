// models/product_model.dart
class Product {
  final int id;
  final String nombre;
  final double precioVenta;
  final double precioCompra;
  final int stock;
  final int stockMinimo;
  final String descripcion;
  final bool estado;
  final int categoriaId;
  final int marcaId;
  
  Product({
    required this.id,
    required this.nombre,
    required this.precioVenta,
    required this.precioCompra,
    required this.stock,
    required this.stockMinimo,
    required this.descripcion,
    required this.estado,
    required this.categoriaId,
    required this.marcaId,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      precioVenta: (json['precio_venta'] as num?)?.toDouble() ?? 0.0,
      precioCompra: (json['precio_compra'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      stockMinimo: json['stock_minimo'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? true,
      categoriaId: json['categoria_id'] is int ? json['categoria_id'] : int.parse(json['categoria_id'].toString()),
      marcaId: json['marca_id'] is int ? json['marca_id'] : int.parse(json['marca_id'].toString()),
    );
  }
  
  @override
  String toString() {
    return 'Product(id: $id, nombre: $nombre, precio: $precioVenta)';
  }
}