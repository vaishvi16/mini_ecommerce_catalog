import 'package:flutter/material.dart';

import '../model_class/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Add product to cart
  void addToCart(CartItem item) {
    // Check if the product already exists
    final index = _cartItems.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      // If exists, increase quantity
      _cartItems[index].qty += item.qty;
    } else {
      // If not, add new
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.removeWhere((i) => i.name == item.name);
    notifyListeners();
  }

  void increaseQty(CartItem item) {
    final index = _cartItems.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      _cartItems[index].qty++;
      notifyListeners();
    }
  }

  void decreaseQty(CartItem item) {
    final index = _cartItems.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      if (_cartItems[index].qty > 1) {
        _cartItems[index].qty--;
      } else {
        // qty is 1, remove the product
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += int.parse(item.price) * item.qty;
    }
    return total;
  }
}