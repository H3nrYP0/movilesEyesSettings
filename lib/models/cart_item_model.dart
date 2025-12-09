import 'package:optica_app/models/product_model.dart';
class CartItem {
  final String id;
  final Product product;
  int quantity;
  
  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });
  
  double get subtotal => product.precioVenta * quantity;
  
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}