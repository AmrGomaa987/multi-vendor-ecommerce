import 'package:blocapp/presintation/screens/auth/login_screen.dart';
import 'package:blocapp/presintation/screens/auth/register_screen.dart';
import 'package:blocapp/presintation/screens/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ECommerce());
}

class ECommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          background: Colors.black,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
