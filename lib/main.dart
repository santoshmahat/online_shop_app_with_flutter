import 'package:flutter/material.dart';
import 'package:online_shop/providers/auth.dart';
import 'package:online_shop/providers/cart.dart';
import 'package:online_shop/providers/orders.dart';
import 'package:online_shop/providers/products.dart';
import 'package:online_shop/screens/auth_screen.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/screens/order_screen.dart';
import 'package:online_shop/screens/product_detail_screen.dart';
import 'package:online_shop/screens/product_edit_screen.dart';
import 'package:online_shop/screens/products_overview_screen.dart';
import 'package:online_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products([], null, null),
          update: (_, auth, previousProduct) => Products(
              previousProduct == null ? [] : previousProduct.items,
              auth.token,
              auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders([], null, null),
          update: (_, auth, previousOrders) => Orders(
              previousOrders == null ? [] : previousOrders.orders,
              auth.token,
              auth.userId),
        )
      ],
      child: Consumer<Auth>(
          builder: (consumerCtx, auth, child) => MaterialApp(
                title: "OnlineShop",
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: "Lato",
                ),
                home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  ProductEditScreen.routeName: (ctx) => ProductEditScreen(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                },
              )),
    );
  }
}
