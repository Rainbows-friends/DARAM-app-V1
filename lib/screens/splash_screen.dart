import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'DARAM',
          style: TextStyle(
            fontFamily: 'SUIT-Heavy',
            fontWeight: FontWeight.bold,
            fontSize: 48,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}