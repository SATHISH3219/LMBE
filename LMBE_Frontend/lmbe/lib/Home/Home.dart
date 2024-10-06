import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmbe/Cart/cart_item.dart';
import 'package:lmbe/Cart/cart_screen.dart'; // Import the CartScreen for viewing the cart

class HomePage extends StatefulWidget {
  final String userId; // Add userId as a parameter

  HomePage({required this.userId}); // Update the constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  List<CartItem> cartItems = []; // List to hold cart items
  bool isLoading = true; // Track loading state
  bool isError = false; // Track error state

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    String apiUrl = 'http://192.168.141.31:8080/api/consumer/allproducts';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        _showSnackBar('Failed to load products: ${response.statusCode}');
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

  Future<void> _addToCart(String productId, String productName, double price) async {
    // Check if the item already exists in the cart
    final existingItem = cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(productId: productId, productName: productName, price: price, quantity: 0),
    );

    // If it exists, increase quantity; if not, add to the cart
    if (existingItem.quantity > 0) {
      setState(() {
        existingItem.quantity++;
      });
    } else {
      setState(() {
        cartItems.add(CartItem(productId: productId, productName: productName, price: price, quantity: 1));
      });
    }

    // Call the API to add the item to the cart in the database
    try {
      final response = await http.post(
        Uri.parse('http://192.168.141.31:8080/cart/${widget.userId}/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'productId': productId,
          'productName': productName,
          'price': price,
          'quantity': 1,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Added to cart: $productName');
      } else {
        _showSnackBar('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _viewCart() {
    // Pass the userId when navigating to the CartScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(userId: widget.userId), // Navigate to CartScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List'),
        backgroundColor: const Color.fromARGB(255, 0, 110, 235),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _viewCart, // Navigate to cart on icon press
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Error loading products.'))
              : products.isEmpty
                  ? Center(child: Text('No products available.'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in grid
                        childAspectRatio: 0.7, // Aspect ratio of each card
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      padding: EdgeInsets.all(8.0),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            // You can add navigation to product details if needed
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                  child: product['imageUrl'] != null && product['imageUrl'].isNotEmpty
                                      ? Image.network(
                                          product['imageUrl'],
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 120,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          color: Colors.grey[300], // Placeholder background color
                                          child: Text(
                                            'No Image Available',
                                            style: TextStyle(color: Colors.black54),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['productName'],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '₹${product['price'].toStringAsFixed(0)}', // Indian Rupees
                                        style: TextStyle(color: const Color.fromARGB(255, 0, 157, 255), fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 0, 119, 255), // Button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      _addToCart(product['id'], product['productName'], product['price']);
                                    },
                                    child: Text('Add to Cart'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
