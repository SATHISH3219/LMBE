class Product {
  final String id;
  final String producerId;
  final String productName;
  final String description;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.producerId,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      producerId: json['producerId'],
      productName: json['productName'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producerId': producerId,
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }
}
