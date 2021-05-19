import 'package:flutter_test/flutter_test.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/providers/product.dart';

void main() {
  group('Testing Cart class', () {
    var cart = Cart();

    test('A new product should be added to the cart', () {
      var product = new Product(
        id: '1',
        image: 'testeImage',
        name: 'TesteNome',
        price: 10.00,
      );
      cart.addItem(product);
      expect(cart.items.containsKey(product.id.toString()), true);
    });

    test('A product should be removed at the cart', () {
      var product = new Product(
        id: '1',
        image: 'testeImage',
        name: 'TesteNome',
        price: 10.00,
      );
      cart.removeItem(product.id.toString());
      expect(cart.items.containsKey(product.id.toString()), false);
    });
  });
}
