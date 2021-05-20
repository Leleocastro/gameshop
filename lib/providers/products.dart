import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameshop_supera/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:gameshop_supera/providers/product.dart';

class Products with ChangeNotifier {
  final String _url = Constants.BASE_API_URL;
  final String _urlJogos = Constants.BASE_API_JOGOS;

  Products([this._items = const []]);

  List<Product> _items = [];

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final jsonString = await http.get(Uri.https(_url, _urlJogos));
    final data = json.decode(jsonString.body);

    if (data != null) {
      _items = data.map<Product>((json) => Product.fromJson(json)).toList();

      notifyListeners();
    }
    return Future.value();
  }

  bool alphabeticOrderBy(bool isAscending) {
    if (isAscending) {
      _items.sort((a, b) {
        var aName = a.name;
        var bName = b.name;
        return aName.compareTo(bName);
      });
      notifyListeners();
      return false;
    } else {
      _items.sort((a, b) {
        var aName = a.name;
        var bName = b.name;
        return -aName.compareTo(bName);
      });
      notifyListeners();
      return true;
    }
  }

  bool priceOrderBy(bool isAscending) {
    if (isAscending) {
      _items.sort((a, b) {
        var aPrice = a.price;
        var bPrice = b.price;
        return aPrice.compareTo(bPrice);
      });
      notifyListeners();
      return false;
    } else {
      _items.sort((a, b) {
        var aPrice = a.price;
        var bPrice = b.price;
        return -aPrice.compareTo(bPrice);
      });
      notifyListeners();
      return true;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final body = json.encode({
      "nome": newProduct.name,
      "preco": newProduct.price,
      "imageUrl": newProduct.image
    });

    print(body);
    final response = await http.post(
      Uri.https(_url, _urlJogos),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "*/*"
      },
      body: body,
    );
    _items.add(Product(
      name: newProduct.name,
      price: newProduct.price,
      image: newProduct.image,
    ));

    print(response.body);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null && product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      final response = await http.put(
        Uri.https(_url, "$_urlJogos/${product.id}"),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          "nome": product.name,
          "preco": product.price,
          "imageUrl": product.image
        }),
      );
      print(response.body);

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete(Uri.https(_url, '$_urlJogos/${product.id}'));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw Exception('Ocorreu um erro na exclusão do produto!');
      }
    }
  }
}
