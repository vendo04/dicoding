import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String imageAsset;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.imageAsset,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(CartItem item) {
    final existingItemIndex = _items.indexWhere((prod) => prod.id == item.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void decreaseItemQuantity(String productId) {
    final existingItemIndex = _items.indexWhere((prod) => prod.id == productId);
    if (existingItemIndex >= 0 && _items[existingItemIndex].quantity > 1) {
      _items[existingItemIndex].quantity--;
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
