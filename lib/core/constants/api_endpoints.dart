class ApiEndpoints {
  static const String baseUrl = 'https://optica-api-vad8.onrender.com';
  
  // Autenticación
  static const String usuarios = '$baseUrl/usuarios';
  
  // Productos
  static const String productos = '$baseUrl/productos';
  static const String categorias = '$baseUrl/categorias';
  static const String marcas = '$baseUrl/marcas';
  
  // Clientes
  static const String clientes = '$baseUrl/clientes';
  
  // Empleados
  static const String empleados = '$baseUrl/empleados';
  
  // Citas
  static const String citas = '$baseUrl/citas';
  static const String servicios = '$baseUrl/servicios';
  static const String estadoCita = '$baseUrl/estado-cita';
  
  // Ventas
  static const String ventas = '$baseUrl/ventas';
  static const String detalleVenta = '$baseUrl/detalle-venta';
  
  // Otros
  static const String proveedores = '$baseUrl/proveedores';
  static const String roles = '$baseUrl/roles';
}