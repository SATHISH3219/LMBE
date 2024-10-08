import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmbe/Product/product_list_screen.dart';

class CreateProductScreen extends StatefulWidget {
  final String producerId;

  CreateProductScreen({required this.producerId});

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _productName, _description;
  double? _price;
  int? _quantity;

  Future<void> _addProduct() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    String apiUrl = 'http://192.168.169.31:8080/api/products/create'; // Replace with your API URL
    Map<String, dynamic> productData = {
      'producerId': widget.producerId,
      'productName': _productName!,
      'description': _description!,
      'price': _price!,
      'quantity': _quantity!,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
        
        // Reset the form fields
        _formKey.currentState!.reset(); // This will reset the form fields

        // Optionally, you can clear the saved values
        setState(() {
          _productName = null;
          _description = null;
          _price = null;
          _quantity = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(producerId: widget.producerId),
          ),
        ); // Navigate to ProductPage after product creation
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
        backgroundColor: const Color.fromARGB(255, 62, 153, 233),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () {
              // Navigate to the product list screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(producerId: widget.producerId),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                _buildTextField(
                  label: 'Product Name',
                  hint: 'Enter product name',
                  onSaved: (value) => _productName = value,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Description',
                  hint: 'Enter product description',
                  onSaved: (value) => _description = value,
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Price',
                        hint: 'Enter price',
                        onSaved: (value) => _price = double.parse(value!),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Quantity',
                        hint: 'Enter quantity',
                        onSaved: (value) => _quantity = int.parse(value!),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      backgroundColor: const Color.fromARGB(255, 33, 166, 255),
                    ),
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the product list screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                              producerId: widget.producerId),
                        ),
                      );
                    },
                    icon: Icon(Icons.view_list),
                    label: Text("View Products"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 77, 153, 253),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.teal),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
