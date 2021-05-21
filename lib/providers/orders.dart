import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/utils/constants.dart';
import 'package:http/http.dart' as http;
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
  final String _url = Constants.BASE_API_URL;
  final String _urlOrders = Constants.BASE_API_ORDERS;
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

    final jsonString = await http.get(Uri.https(_url, _urlOrders));
    final data = json.decode(jsonString.body);

    print(data);

    loadedItems.clear();
    if (data != null) {
      data.forEach((orderData) {
        loadedItems.add(
          Order(
            id: orderData['id'],
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['jogos'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['jogoId'],
                name: item['nome'],
                image: item['imageUrl'],
                quantity: item['quantidade'],
                price: item['preco'].toDouble(),
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
    final date = DateTime.now();
    final response = await http.post(
      Uri.https(_url, _urlOrders),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "*/*"
      },
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'jogos': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'jogoId': cartItem.productId,
                  'nome': cartItem.name,
                  'imageUrl': cartItem.image,
                  'quantidade': cartItem.quantity,
                  'preco': cartItem.price,
                  'frete': cartItem.frete,
                })
            .toList(),
      }),
    );
    print(response.body);
    print(_items);

    notifyListeners();
  }
}
