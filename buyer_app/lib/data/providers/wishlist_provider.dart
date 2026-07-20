import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;
  bool isInWishlist(Product product) => _items.any((p) => p.id == product.id);

  void toggle(Product product) {
    if (isInWishlist(product)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
