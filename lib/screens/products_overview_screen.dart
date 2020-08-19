import 'package:flutter/material.dart';
import 'package:online_shop/providers/product.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/widgets/app_drawer.dart';
import 'package:online_shop/widgets/product_item.dart';
import 'package:online_shop/providers/products.dart';
import 'package:provider/provider.dart';

enum FilterOptions { All, Favorite }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isFavoriteOnly = false;

  bool _isInit = true;

  bool _isLoading = false;

  void _selectPopupOption(value) {
    if (value == FilterOptions.Favorite) {
      setState(() {
        _isFavoriteOnly = true;
      });
    } else {
      setState(() {
        _isFavoriteOnly = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    List<Product> _loadedProducts =
        _isFavoriteOnly ? products.favoriteItems : products.items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Shop"),
        actions: [
          PopupMenuButton(
            onSelected: _selectPopupOption,
            icon: Icon(Icons.more_vert),
            itemBuilder: (bctx) => [
              PopupMenuItem(
                child: Text("All"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Favorite"),
                value: FilterOptions.Favorite,
              )
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _loadedProducts.length,
              itemBuilder: (bctx, index) {
                return ChangeNotifierProvider.value(
                  value: _loadedProducts[index],
                  child: ProductItem(
                      // id: _loadedProducts[index].id,
                      // title: _loadedProducts[index].title,
                      // imageUrl: _loadedProducts[index].imageUrl,
                      ),
                );
              },
            ),
    );
  }
}
