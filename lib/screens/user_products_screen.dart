import 'package:flutter/material.dart';
import 'package:online_shop/providers/products.dart';
import 'package:online_shop/screens/product_edit_screen.dart';
import 'package:online_shop/widgets/app_drawer.dart';
import 'package:online_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Manage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProductEditScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        return _refreshProducts(context);
                      },
                      child: Consumer<Products>(
                        builder: (ctx, products, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemBuilder: (bctx, index) {
                              return UserProductItem(
                                  products.items[index].id,
                                  products.items[index].title,
                                  products.items[index].price,
                                  products.items[index].imageUrl);
                            },
                            itemCount: products.items.length,
                          ),
                        ),
                      ),
                    )),
    );
  }
}
