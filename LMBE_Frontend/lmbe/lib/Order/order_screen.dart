import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmbe/Order/OrderItem.dart'; // Import OrderItem model
import 'package:lmbe/Payment/Payment.dart'; // Import PaymentScreen

class OrderScreen extends StatefulWidget {
  final String userId;
  final double totalamount;

  OrderScreen({required this.userId, required this.totalamount});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderItem> orderItems = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    String apiUrl = 'http://192.168.141.31:8080/order/${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        print('Fetched Orders: $jsonResponse'); // Debugging line
        setState(() {
          orderItems = jsonResponse.map((item) => OrderItem.fromJson(item)).toList();
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        _showSnackBar('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _navigateToPayment(OrderItem orderItem) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          orderId: orderItem.id,
          amount: orderItem.totalAmount,
          userId: orderItem.userId,
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Error loading orders.', style: TextStyle(fontSize: 18, color: Colors.red)))
              : ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final orderItem = orderItems[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Order ID: ${orderItem.id}'),
                        subtitle: Text('Total: ₹${orderItem.totalAmount}\nStatus: ${orderItem.status}'),
                        onTap: () => _navigateToPayment(orderItem), // Navigate to PaymentScreen
                      ),
                    );
                  },
                ),
    );
  }
}
