class OrderItem {
  final String id;
  final String userId;
  final List<Item> items; // Assuming you have an Item class
  final String status;
  final DateTime timestamp;

  // Assuming totalAmount is calculated from items
  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  OrderItem({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.timestamp,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<Item> itemList = itemsFromJson.map((i) => Item.fromJson(i)).toList();

    return OrderItem(
      id: json['id'],
      userId: json['userId'],
      items: itemList,
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Item {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  Item({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
