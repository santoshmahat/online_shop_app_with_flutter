import 'package:flutter/material.dart';
import 'package:online_shop/models/http_exception.dart';
import 'dart:convert';
import 'package:online_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String token;
  final String userId;

  Products(this._items, this.token, this.userId);

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items {
    print('Products token $token');
    print('Products items $_items');
    return _items.map((i) => i).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://online-shop-app-71e8a.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> products = [];
      print(decodedData);
      if (decodedData == null) {
        return;
      }
      decodedData.forEach((key, product) {
        products.add(
          Product(
            id: key,
            title: product['title'],
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            isFavorite: product['isFavorite'],
          ),
        );
      });

      _items = products;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url =
          'https://online-shop-app-71e8a.firebaseio.com/products.json?auth=$token';
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
          'creatorId': userId
        }),
      );
      print(response);
      print(json.decode(response.body));
      _items.add(
        Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    try {
      final url =
          'https://online-shop-app-71e8a.firebaseio.com/products/$id.json?auth=$token';
      final productIndex = _items.indexWhere((item) => item.id == id);

      final response = await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite
        }),
      );

      print('product title ${json.decode(response.body)}');
      _items[productIndex] = product;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteItem(String id) async {
    final url =
        'https://online-shop-app-71e8a.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((item) => item.id == id);

    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Unable to delete the product");
    }
    existingProduct = null;
  }

  Product findById(id) {
    return _items.firstWhere((i) => i.id == id);
  }
}
