import 'package:flutter/material.dart';
import 'package:gameshop_supera/providers/orders.dart';
import 'package:gameshop_supera/widgets/appDrawer.dart';
import 'package:gameshop_supera/widgets/orderWidget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  // bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<Orders>(context, listen: false).loadOrders().then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  // Future<void> _refreshOrders(BuildContext context) {
  //   return Provider.of<Orders>(context, listen: false).loadOrders();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            print(snapshot.error);
            return Center(child: Text('Ocorreu um erro!'));
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
                  itemCount: orders.itemsCount,
                );
              },
            );
          }
        },
      ),
      // _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: () => _refreshOrders(context),
      //         child: ListView.builder(
      //           itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      //           itemCount: orders.itemsCount,
      //         ),
      //       ),
    );
  }
}
