import 'package:flutter/material.dart';
import 'package:lmbe/Auth/login.dart';
import 'package:lmbe/Auth/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/Home.dart'; // Adjust according to your file structure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
