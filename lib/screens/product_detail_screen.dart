import 'package:flutter/material.dart';
import 'package:online_shop/providers/product.dart';
import 'package:online_shop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final selectedProductId = ModalRoute.of(context).settings.arguments;
    Product product =
        Provider.of<Products>(context).findById(selectedProductId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
