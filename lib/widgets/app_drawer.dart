import 'package:flutter/material.dart';
import 'package:online_shop/providers/auth.dart';
import 'package:online_shop/screens/order_screen.dart';
import 'package:online_shop/screens/products_overview_screen.dart';
import 'package:online_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      appBar: AppBar(title: Text("Drawer")),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.routeName);
            },
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Shop"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Manage product"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Logout"),
          ),
          Divider(),
        ],
      ),
    ));
  }
}
