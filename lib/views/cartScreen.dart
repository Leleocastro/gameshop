import 'package:flutter/material.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:gameshop_supera/providers/orders.dart';
import 'package:gameshop_supera/widgets/cartItemWidget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Container(
            height: 230,
            child: Card(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 25),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Sub-Total',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(width: 10),
                        Chip(
                          label: Text(
                            'R\$ ${cart.subTotalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Frete',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(width: 10),
                        Chip(
                          label: Text(
                            'R\$ ${cart.freteAmount}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Chip(
                          label: Text(
                            'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        Spacer(),
                        OrderButton(cart: cart)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CartItemWidget(cartItems[i]),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: isLoading ? CircularProgressIndicator() : Text('COMPRAR'),
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart);
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Compra realizada com sucesso!',
                  ),
                  duration: Duration(
                    seconds: 2,
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
    );
  }
}
