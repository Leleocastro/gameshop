import 'package:flutter/material.dart';
import 'package:gameshop_supera/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem certeza?'),
            content: Text('Quer remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'Não',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Sim',
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Produto removido com sucesso!',
            ),
            duration: Duration(
              seconds: 2,
            ),
          ),
        );
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cartItem.image),
              radius: 40,
            ),
            title: Text(cartItem.name),
            subtitle: Row(
              children: [
                Text(
                    'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
                cartItem.quantity > 1
                    ? IconButton(
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          size: 15,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Produto removido com sucesso!',
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                          Provider.of<Cart>(context, listen: false)
                              .removeSingleItem(cartItem.productId);
                        },
                      )
                    : Text(''),
              ],
            ),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
