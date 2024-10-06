// import 'package:flutter/material.dart';
// import 'package:lmbe/Order/OrderItem.dart'; // Define OrderItem model

// class OrderDetailsScreen extends StatelessWidget {
//   final OrderItem orderItem;

//   OrderDetailsScreen({required this.orderItem});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//         backgroundColor: Colors.lightBlue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order ID: ${orderItem.id}',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Status: ${orderItem.status ?? "Unknown"}', // Handle null status
//               style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//             ),
//             SizedBox(height: 16),
//             // Products Section
//             Text(
//               'Products:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: orderItem.products.length,
//                 itemBuilder: (context, index) {
//                   final product = orderItem.products[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     elevation: 2,
//                     child: ListTile(
//                       title: Text(
//                         product.name,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         'Price: \$${product.price.toStringAsFixed(2)}', // Format price to 2 decimal places
//                         style: TextStyle(color: Colors.grey[700]),
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.info_outline),
//                         onPressed: () {
//                           // Optional: Add an action for additional product details
//                           _showProductDetails(context, product);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to show additional product details in a dialog
//   void _showProductDetails(BuildContext context, Product product) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(product.name),
//           content: Text('Price: \$${product.price.toStringAsFixed(2)}\n\nMore details about the product can be added here.'),
//           actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
