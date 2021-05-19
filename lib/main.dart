import 'package:flutter/material.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/providers/orders.dart';
import 'package:gameshop_supera/providers/products.dart';
import 'package:gameshop_supera/utils/appRoutes.dart';
import 'package:gameshop_supera/views/cartScreen.dart';
import 'package:gameshop_supera/views/ordersScreen.dart';
import 'package:gameshop_supera/views/productDetailScreen.dart';
import 'package:gameshop_supera/views/productsOverviewScreen.dart';
import 'package:gameshop_supera/views/productsScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Supera GameShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.purple,
          accentColor: Colors.green,
          brightness: Brightness.dark,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrderScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
        },
      ),
    );
  }
}
