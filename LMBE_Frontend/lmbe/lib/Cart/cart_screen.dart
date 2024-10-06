import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmbe/Cart/cart_item.dart';
import 'package:lmbe/Order/order_screen.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  CartScreen({required this.userId});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    String apiUrl = 'http://192.168.141.31:8080/cart/${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          cartItems = (jsonResponse['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        _showSnackBar('Failed to load cart items: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _showSnackBar('Error: $e');
    }
  }

  void _removeFromCart(String productId) async {
    String apiUrl = 'http://192.168.141.31:8080/cart/${widget.userId}/remove';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'productId': productId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) => item.productId == productId);
        });
        _showSnackBar('Item removed from cart');
      } else {
        _showSnackBar('Failed to remove item: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _placeOrder() async {
    String apiUrl = 'http://192.168.141.31:8080/order/place';

    // Calculate the total amount
    double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'items': cartItems.map((item) => item.toJson()).toList(),
          'amount': totalAmount, // Add amount in the request body
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Order placed successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(userId: widget.userId, totalamount: totalAmount),
          ),
        );
      } else {
        _showSnackBar('Failed to place order: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error placing order: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.lightBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Error loading cart items.'))
              : Column(
                  children: [
                    Expanded(
                      child: cartItems.isEmpty
                          ? Center(child: Text('No items in cart.'))
                          : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartItems[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(cartItem.productName),
                                    subtitle: Text(
                                        'Price: ₹${cartItem.price} x ${cartItem.quantity}'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove, color: Colors.red),
                                      onPressed: () {
                                        _removeFromCart(cartItem.productId);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : _placeOrder,
                        child: Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
