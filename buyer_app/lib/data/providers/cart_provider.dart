import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get count => _items.length;
  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void add(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
      notifyListeners();
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
      notifyListeners();
    }
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;
}
