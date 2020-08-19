import 'package:flutter/material.dart';
import 'package:online_shop/providers/cart.dart' show CartItem;
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];

  String token;

  Orders(this._orders, this.token);

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://online-shop-app-71e8a.firebaseio.com/orders.json?auth=$token';
    final response = await http.get(url);
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];
    if (decodedData == null) {
      return;
    }
    print('orders data');
    print(decodedData);
    decodedData.forEach((key, orderedData) {
      loadedOrders.add(OrderItem(
          id: key,
          amount: orderedData['amount'],
          products: (orderedData['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  title: cartItem['title'],
                  price: cartItem['price'],
                  quantity: cartItem['quantity']))
              .toList(),
          dateTime: DateTime.parse(orderedData['dateTime'])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://online-shop-app-71e8a.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                })
            .toList(),
      }),
    );
    print(json.decode(response.body));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
