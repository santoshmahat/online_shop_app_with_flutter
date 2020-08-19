import 'package:flutter/material.dart';
import 'package:online_shop/providers/orders.dart' show Orders;
import 'package:online_shop/widgets/app_drawer.dart';
import 'package:online_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : orderData.orders.length < 1
              ? Center(
                  child: Text("No order item "),
                )
              : ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (bctx, index) {
                    return OrderItem(orderData.orders[index]);
                  }),
    );
  }
}
