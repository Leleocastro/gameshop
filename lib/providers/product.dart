import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String image;

  Product({
    this.id,
    this.name,
    this.price,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['nome'],
      price: double.parse(json['preco'].toString()),
      image: json['imageUrl'],
    );
  }
}
