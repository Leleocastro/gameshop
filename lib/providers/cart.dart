import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gameshop_supera/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final int quantity;
  final double price;
  final double frete;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.name,
    @required this.image,
    @required this.quantity,
    @required this.price,
    @required this.frete,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get subTotalAmount {
    double subTotal = 0.0;
    _items.forEach((key, cartItem) {
      subTotal += cartItem.price * cartItem.quantity;
    });
    return subTotal;
  }

  double get freteAmount {
    double frete = 0.0;
    if (subTotalAmount < 250) {
      _items.forEach((key, cartItem) {
        frete += cartItem.frete;
      });
    }
    return frete;
  }

  double get totalAmount {
    double total = 0.0;
    total = freteAmount + subTotalAmount;
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id.toString())) {
      _items.update(
        product.id.toString(),
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: product.id.toString(),
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          frete: existingItem.frete + 10,
          image: existingItem.image,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id.toString(),
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id.toString(),
          name: product.name,
          quantity: 1,
          price: product.price,
          image: product.image,
          frete: 10,
        ),
      );
    }

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
          image: existingItem.image,
          frete: existingItem.frete - 10,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
