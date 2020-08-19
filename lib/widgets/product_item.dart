import 'package:flutter/material.dart';
import 'package:online_shop/providers/auth.dart';
import 'package:online_shop/providers/cart.dart';
import 'package:online_shop/providers/product.dart';
import 'package:online_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.imageUrl});

  void _selectProduct(String id, BuildContext context) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);

    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);
    print("hello1");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => _selectProduct(product.id, context),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (bctx, product, child) => IconButton(
              onPressed: () {
                product.toogleFavorite(auth.token);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: product.isFavorite
                      ? Text("Product added to favorite.")
                      : Text("Product removed from favorite."),
                ));
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () =>
                cart.addItem(product.id, product.title, product.price),
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
    ;
  }
}
