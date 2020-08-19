import 'package:flutter/material.dart';
import 'package:online_shop/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat("dd-MM-YYYY hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: _toggleExpand,
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          _isExpanded
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: min(widget.order.products.length * 20.0 + 10, 100),
                  child: ListView(
                    children: widget.order.products
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${prod.quantity}x \$${prod.price}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                )
              : Text(""),
        ],
      ),
    );
  }
}
