import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/providers/products.dart';
import 'package:gameshop_supera/utils/appRoutes.dart';
import 'package:gameshop_supera/widgets/appDrawer.dart';
import 'package:gameshop_supera/widgets/badge.dart';
import 'package:gameshop_supera/widgets/productGrid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isLoading = true;
  bool _isAscUsed = false;
  bool _isPriUsed = false;
  bool _isScoUsed = false;
  bool _isAscending = true;
  bool _isPrice = true;
  bool _isScore = true;

  @override
  void initState() {
    super.initState();
    // carregar os produtos
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameShop'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _isAscUsed
                  ? Text(
                      _isAscending ? '↑' : '↓',
                      textAlign: TextAlign.end,
                    )
                  : Text(''),
              IconButton(
                alignment: Alignment.centerLeft,
                iconSize: _isAscUsed ? 15 : 20,
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  setState(() {
                    _isAscending = Provider.of<Products>(context, listen: false)
                        .alphabeticOrderBy(_isAscending);
                    _isAscUsed = true;
                    _isPriUsed = false;
                    _isScoUsed = false;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              _isPriUsed
                  ? Text(
                      _isPrice ? '↑' : '↓',
                      textAlign: TextAlign.end,
                    )
                  : Text(''),
              IconButton(
                alignment: Alignment.centerLeft,
                iconSize: _isPriUsed ? 15 : 20,
                icon: Icon(Icons.attach_money),
                onPressed: () {
                  setState(() {
                    _isPrice = Provider.of<Products>(context, listen: false)
                        .priceOrderBy(_isPrice);
                    _isPriUsed = true;
                    _isAscUsed = false;
                    _isScoUsed = false;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Consumer<Cart>(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
              ),
              builder: (_, cart, child) => Badge(
                value: cart.itemsCount.toString(),
                child: child,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ProductGrid(),
            ),
      drawer: AppDrawer(),
    );
  }
}
