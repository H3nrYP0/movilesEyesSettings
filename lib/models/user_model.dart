class User {
  final int id;
  final String nombre;
  final String correo;
  final int rolId;
  final bool estado;
  
  User({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rolId,
    required this.estado,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      rolId: json['rol_id'] is int ? json['rol_id'] : int.parse(json['rol_id'].toString()),
      estado: json['estado'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rol_id': rolId,
      'estado': estado,
      // NOTA: contrasenia solo para registro, no para otros usos
    };
  }
  
  @override
  String toString() {
    return 'User(id: $id, nombre: $nombre, correo: $correo, rolId: $rolId)';
  }
}