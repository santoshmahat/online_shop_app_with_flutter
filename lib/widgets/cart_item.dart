import 'package:flutter/material.dart';
import 'package:online_shop/providers/cart.dart' show Cart;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text("You want to delete this product from the cart"),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              )
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red,
        child: IconButton(
          alignment: Alignment.centerRight,
          onPressed: () {},
          icon: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: \$${price * quantity}"),
            trailing: Text('$quantity\X'),
          ),
        ),
      ),
    );
  }
}
