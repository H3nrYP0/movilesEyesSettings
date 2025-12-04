// models/category_model.dart
class Category {
  final int id;
  final String nombre;
  final String descripcion;
  final bool estado;
  
  Category({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });
  
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? true,
    );
  }
  
  @override
  String toString() {
    return 'Category(id: $id, nombre: $nombre)';
  }
}