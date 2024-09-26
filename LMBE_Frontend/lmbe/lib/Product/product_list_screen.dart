import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final String producerId; // Producer ID passed from the previous screen

  ProductPage({required this.producerId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<dynamic> products = [];
  bool isLoading = true;
  bool noProductFound = false;

  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    print("Producer ID: ${widget.producerId}");
    String apiUrl = 'http://192.168.169.31:8080/api/products/producer/${widget.producerId}';
    print("Sending request to: $apiUrl");

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{ 'Content-Type': 'application/json' },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
          noProductFound = products.isEmpty;
        });
      } else if (response.statusCode == 204) {
        setState(() {
          noProductFound = true;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No products found')));
      } else {
        setState(() { isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch products')));
      }
    } catch (e) {
      print("Error: $e");
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _createProduct() async {
    String apiUrl = 'http://192.168.169.31:8080/api/products/create';
    var productData = jsonEncode({
      "producerId": widget.producerId,  // Assign producer ID to the product
      "productName": _productNameController.text,
      "description": _descriptionController.text,
      "price": double.parse(_priceController.text),
      "quantity": int.parse(_quantityController.text),
    });

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{ 'Content-Type': 'application/json' },
        body: productData,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product created successfully!')));
        _fetchProducts(); // Reload products after creating a new one
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create product')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : noProductFound
              ? Center(child: Text('No products found'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return ProductCard(
                            productName: product['productName'],
                            description: product['description'],
                            price: product['price'],
                            imageUrl: product['imageUrl'] ?? '',
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _showProductDialog(context),
                        child: Text("Add New Product"),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createProduct();
              },
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String description;
  final double price;
  final String imageUrl;

  ProductCard({
    required this.productName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 150,
                  color: Colors.grey[300],
                  width: double.infinity,
                  child: Center(
                    child: Text('No Image Available', style: TextStyle(color: Colors.grey)),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              productName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
