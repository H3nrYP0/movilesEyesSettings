import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optica_app/providers/auth_provider.dart';
import 'package:optica_app/models/pedido_model.dart';
import 'package:optica_app/core/services/pedido_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Pedido> _pedidos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;
      
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      print('👤 Cargando pedidos para usuario ID: ${user.id}');
      print('📧 Usuario: ${user.nombre} (${user.correo})');

      final pedidoService = PedidoService();
      
      // CAMBIO CLAVE AQUÍ: Pasamos null como token ya que AuthProvider no tiene token
      final pedidos = await pedidoService.obtenerPedidosUsuario(user.id, null);
      
      print('✅ Pedidos cargados: ${pedidos.length}');
      
      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error al cargar pedidos: $e');
      setState(() {
        _errorMessage = 'Error al cargar pedidos: $e';
        _isLoading = false;
      });
    }
  }

  Color _getEstadoColor(String estado) {
    final estadoLower = estado.toLowerCase();
    switch (estadoLower) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmado':
        return Colors.blue;
      case 'en_preparacion':
      case 'en preparación':
        return Colors.purple;
      case 'enviado':
        return Colors.indigo;
      case 'entregado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    final estadoLower = estado.toLowerCase();
    switch (estadoLower) {
      case 'pendiente':
        return Icons.pending;
      case 'confirmado':
        return Icons.check_circle_outline;
      case 'en_preparacion':
      case 'en preparación':
        return Icons.build;
      case 'enviado':
        return Icons.local_shipping;
      case 'entregado':
        return Icons.done_all;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarPedidos,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMessage.isNotEmpty
              ? _buildError()
              : _pedidos.isEmpty
                  ? _buildEmptyState()
                  : _buildPedidosList(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando pedidos...'),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _cargarPedidos,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No tienes pedidos aún',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            '¡Empieza a comprar en nuestra tienda!',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Ir a la tienda'),
          ),
        ],
      ),
    );
  }

  Widget _buildPedidosList() {
    // Ordenar pedidos por fecha (más reciente primero)
    final pedidosOrdenados = List.of(_pedidos)
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    
    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidosOrdenados.length,
        itemBuilder: (context, index) {
          final pedido = pedidosOrdenados[index];
          return _buildPedidoCard(pedido);
        },
      ),
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _mostrarDetallesPedido(pedido);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con ID y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pedido #${pedido.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getEstadoColor(pedido.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getEstadoColor(pedido.estado),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getEstadoIcon(pedido.estado),
                          size: 14,
                          color: _getEstadoColor(pedido.estado),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pedido.estado.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getEstadoColor(pedido.estado),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Fecha y hora
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '${pedido.fecha.day.toString().padLeft(2, '0')}/'
                    '${pedido.fecha.month.toString().padLeft(2, '0')}/'
                    '${pedido.fecha.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '${pedido.fecha.hour.toString().padLeft(2, '0')}:'
                    '${pedido.fecha.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Método de entrega y pago
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: pedido.metodoEntrega == 'domicilio' 
                        ? Icons.home 
                        : Icons.store,
                    text: pedido.metodoEntrega == 'domicilio' 
                        ? 'Entrega a domicilio' 
                        : 'Recoger en tienda',
                    color: Colors.blue,
                  ),
                  _buildInfoChip(
                    icon: pedido.metodoPago == 'transferencia'
                        ? Icons.account_balance
                        : Icons.money,
                    text: pedido.metodoPago == 'transferencia'
                        ? 'Transferencia'
                        : 'Efectivo',
                    color: pedido.metodoPago == 'transferencia'
                        ? Colors.purple
                        : Colors.green,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Resumen de productos
              if (pedido.items.isNotEmpty) ...[
                const Text(
                  'Productos:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                ...pedido.items.take(2).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '• ${item.productoNombre ?? "Producto ${item.productoId}"}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '${item.cantidad} x \$${item.precioUnitario.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                
                if (pedido.items.length > 2) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+ ${pedido.items.length - 2} producto(s) más',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ],
                
                const SizedBox(height: 12),
              ],
              
              // Dirección si es entrega a domicilio
              if (pedido.metodoEntrega == 'domicilio' && pedido.direccionEntrega != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📦 Dirección:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pedido.direccionEntrega!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              
              // Total y botón ver detalles
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${pedido.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarDetallesPedido(pedido);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, size: 16),
                        SizedBox(width: 4),
                        Text('Ver Detalles'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetallesPedido(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Título
                    Center(
                      child: Text(
                        'Pedido #${pedido.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Estado
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getEstadoColor(pedido.estado).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getEstadoColor(pedido.estado),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getEstadoIcon(pedido.estado),
                              color: _getEstadoColor(pedido.estado),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              pedido.estado.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getEstadoColor(pedido.estado),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Información básica
                    _buildDetalleItem(
                      icon: Icons.calendar_today,
                      title: 'Fecha y hora',
                      value: '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year} '
                             '${pedido.fecha.hour.toString().padLeft(2, '0')}:'
                             '${pedido.fecha.minute.toString().padLeft(2, '0')}',
                    ),
                    
                    _buildDetalleItem(
                      icon: Icons.payment,
                      title: 'Método de pago',
                      value: _capitalize(pedido.metodoPago),
                    ),
                    
                    _buildDetalleItem(
                      icon: pedido.metodoEntrega == 'domicilio' 
                          ? Icons.home 
                          : Icons.store,
                      title: 'Método de entrega',
                      value: pedido.metodoEntrega == 'domicilio' 
                          ? 'Entrega a domicilio' 
                          : 'Recoger en tienda',
                    ),
                    
                    if (pedido.metodoEntrega == 'domicilio' && pedido.direccionEntrega != null)
                      _buildDetalleItem(
                        icon: Icons.location_on,
                        title: 'Dirección de entrega',
                        value: pedido.direccionEntrega!,
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Productos
                    const Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    ...pedido.items.map((item) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.shopping_bag, color: Colors.blue),
                          ),
                          title: Text(
                            item.productoNombre ?? 'Producto ${item.productoId}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Cantidad: ${item.cantidad}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${(item.precioUnitario * item.cantidad).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$${item.precioUnitario.toStringAsFixed(0)} c/u',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 24),
                    
                    // Total
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              '\$${pedido.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetalleItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}