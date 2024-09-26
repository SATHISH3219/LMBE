import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = true;  // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    String apiUrl = 'http://192.168.169.31:8080/consumer/allproducts'; // Use backend IP address here

    try {
      var response = await http.get(Uri.parse(apiUrl));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          isLoading = false; // Set loading to false even if there's an error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Ensure loading is stopped on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching
          : products.isEmpty
              ? Center(child: Text('No products available.')) // Show message if no products
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 4, // Adding elevation for better UI
                      margin: EdgeInsets.all(8.0), // Margin around each card
                      child: ListTile(
                        title: Text(product['productName'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Price: \$${product['price']}', style: TextStyle(color: Colors.grey[700])),
                        trailing: Text('Quantity: ${product['quantity']}', style: TextStyle(color: Colors.green)),
                      ),
                    );
                  },
                ),
    );
  }
}
