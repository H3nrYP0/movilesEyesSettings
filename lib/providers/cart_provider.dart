import 'package:flutter/material.dart';
import 'package:optica_app/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  
  CartItem({
    required this.product,
    this.quantity = 1,
  });
  
  double get total => product.precioVenta * quantity;
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get total => _items.fold(0, (sum, item) => sum + item.total);
  
  void addToCart(Product product, [int quantity = 1]) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
  }
  
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }
  
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}