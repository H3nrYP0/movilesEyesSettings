class Pedido {
  final int id;
  final int clienteId;
  final int usuarioId;
  final DateTime fecha;
  final double total;
  final String metodoPago;
  final String metodoEntrega;
  final String? direccionEntrega;
  final String estado;
  final String? transferenciaComprobante;
  final int? ventaId;
  final String? clienteNombre;
  final List<DetallePedido> items;
  
  Pedido({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.fecha,
    required this.total,
    required this.metodoPago,
    required this.metodoEntrega,
    this.direccionEntrega,
    required this.estado,
    this.transferenciaComprobante,
    this.ventaId,
    this.clienteNombre,
    required this.items,
  });
  
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as int,
      clienteId: json['cliente_id'] as int,
      usuarioId: json['usuario_id'] as int,
      fecha: DateTime.parse(json['fecha']),
      total: (json['total'] as num).toDouble(),
      metodoPago: json['metodo_pago'] as String,
      metodoEntrega: json['metodo_entrega'] as String,
      direccionEntrega: json['direccion_entrega'],
      estado: json['estado'] as String,
      transferenciaComprobante: json['transferencia_comprobante'],
      ventaId: json['venta_id'],
      clienteNombre: json['cliente_nombre'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => DetallePedido.fromJson(item))
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'cliente_id': clienteId,
      'usuario_id': usuarioId,
      'total': total,
      'metodo_pago': metodoPago,
      'metodo_entrega': metodoEntrega,
      'direccion_entrega': direccionEntrega,
      'estado': estado,
      'transferencia_comprobante': transferenciaComprobante,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class DetallePedido {
  final int id;
  final int pedidoId;
  final int productoId;
  final String? productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  
  DetallePedido({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
  
  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'] as int,
      pedidoId: json['pedido_id'] as int,
      productoId: json['producto_id'] as int,
      productoNombre: json['producto_nombre'],
      cantidad: json['cantidad'] as int,
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    };
  }
}