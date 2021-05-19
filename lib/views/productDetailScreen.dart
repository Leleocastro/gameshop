import 'package:flutter/material.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/providers/product.dart';
import 'package:gameshop_supera/widgets/badge.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;
    final Cart cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.6),
                          Color.fromRGBO(0, 0, 0, 0),
                        ],
                        begin: Alignment(0, 0.8),
                        end: Alignment(0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  'R\$ ${product.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1000),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: CircleAvatar(
          child: Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                cart.addItem(product);
              },
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
