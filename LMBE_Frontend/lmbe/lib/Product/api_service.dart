import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.169.31:8080/api/products";

  Future<List<Product>> getProducts(String producerId, String productName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/producer/$producerId/product/$productName'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product?> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
}
