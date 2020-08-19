import 'package:flutter/material.dart';
import 'package:online_shop/providers/products.dart';
import 'package:online_shop/screens/product_edit_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ProductEditScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Do you want to delete this product."),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text("No"),
                            ),
                            FlatButton(
                              onPressed: () async {
                                try {
                                  await Provider.of<Products>(context,
                                          listen: false)
                                      .deleteItem(id);
                                  Navigator.of(context).pop(true);
                                } catch (error) {
                                  Navigator.of(context).pop(true);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(error.toString())));
                                }
                              },
                              child: Text("Yes"),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
