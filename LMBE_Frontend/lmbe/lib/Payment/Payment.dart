// Import necessary packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmbe/Home/Home.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId; // Order ID parameter
  final double amount;
  final String userId;

  PaymentScreen({required this.orderId, required this.amount, required this.userId}); // Constructor

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String upiId = 'dineshm8870449432@oksbi'; // Payee UPI ID
  final String payeeName = 'Sathish'; // Payee Name
  late String transactionNote; // Transaction note
  String? generatedTransactionId; // Store generated transaction ID
  List<String> transactionDetails = []; // Store extracted transaction details
  bool isPaymentValid = false; // Flag to check payment validity

  @override
  void initState() {
    super.initState();
    transactionNote = widget.orderId; // Assign orderId to transactionNote
  }

  void setTransactionId(String id) {
    generatedTransactionId = id; // Assign a custom transaction ID
  }

  String generateUpiString() {
    if (generatedTransactionId == null) {
      setTransactionId(DateTime.now().millisecondsSinceEpoch.toString()); // Set the transaction ID only once
    }
    return 'upi://pay?pa=$upiId&pn=$payeeName&am=${widget.amount.toStringAsFixed(2)}&tn=$transactionNote&cu=INR&tid=$generatedTransactionId';
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      analyzeImage(File(image.path)); // Analyze the selected image
    }
  }

  Future<void> analyzeImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    List<String> details = [];
    String extractedTransactionNote = ''; // Store extracted transaction note

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains(transactionNote)) {
          extractedTransactionNote = line.text.trim();
          details.add(extractedTransactionNote); // Store only the matching transaction note
        }
      }
    }

    print("Extracted Transaction Note: $extractedTransactionNote"); // Debugging line

    setState(() {
      transactionDetails = details;
      isPaymentValid = (extractedTransactionNote == transactionNote); // Validate transaction note
    });

    textRecognizer.close(); // Close the text recognizer
  }

  // Proceed to the next page if payment is valid
  void proceedIfValid() async {
    if (isPaymentValid) {
      // Prepare the payment data
      final paymentData = {
        'orderId': transactionNote,
        'amount': widget.amount,
        'transactionNote': transactionNote,
        'transactionId': generatedTransactionId,
      };

      // Send data to Spring Boot backend
      final response = await http.post(
        Uri.parse('http://192.168.141.31:8080/api/payments'), // Update with your server IP and port
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      if (response.statusCode == 201) {
        await deleteOrder(widget.orderId); // Call deleteOrder function
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentSuccessPage(userId: widget.userId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment verification failed!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment verification failed: Transaction note mismatch!')),
      );
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.141.31:8080/api/orders/$orderId'), // Update with your API endpoint
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204) {
      // Order deleted successfully
      print('Order deleted successfully: $orderId');
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment via QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: generateUpiString(), // Generate the UPI string for the QR code
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImage, // Button to pick an image
            child: Text('Upload Transaction Screenshot'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: proceedIfValid, // Button to verify payment
            child: Text('Verify Payment'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactionDetails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transactionDetails[index]), // Display extracted transaction details
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessPage extends StatefulWidget {
  final String userId; // Add userId parameter

  PaymentSuccessPage({required this.userId});
  
  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Navigate back after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)), // Change to your home route
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Successful'),
      ),
      body: Container(
        color: Colors.white, // Set a background color
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Your payment was successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Thank you for your purchase!',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
