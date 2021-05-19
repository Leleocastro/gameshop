import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:path_provider/path_provider.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  Orders([this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/orders.json');
  }

  Future<String> _carregaOrderJson() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return empty.
      return '';
    }
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];

    String jsonString = await _carregaOrderJson();
    final data = json.decode(jsonString);

    loadedItems.clear();
    if (data != null) {
      data.forEach((orderData) {
        loadedItems.add(
          Order(
            id: orderData['id'],
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                image: item['image'],
                quantity: item['quantity'],
                price: item['price'].toDouble(),
                frete: item['frete'].toDouble(),
              );
            }).toList(),
          ),
        );
      });
      notifyListeners();
    }

    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final file = await _localFile;
    final date = DateTime.now();
    final response = json.encode([
      {
        'id': Random().toString(),
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'image': cartItem.image,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                  'frete': cartItem.frete,
                })
            .toList(),
      }
    ]);
    String jsonString = await _carregaOrderJson();
    String jsonStringFirst = "";
    String responseSecond = "";
    if (jsonString.isNotEmpty) {
      jsonStringFirst = jsonString.substring(0, jsonString.length - 1);
      responseSecond = response.substring(1, response.length - 1);
    }

    await file.writeAsString(jsonString.isNotEmpty
        ? jsonStringFirst + ',' + responseSecond + ']'
        : response);

    notifyListeners();
  }
}
