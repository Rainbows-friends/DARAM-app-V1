import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/auth_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final tokens = await AuthService.signInWithOAuth(context);
              Navigator.pushReplacementNamed(context, '/home', arguments: tokens);
            } catch (e) {
              print("Error during login: $e");
            }
          },
          child: Text(
            '로그인',
            style: GoogleFonts.roboto(color: Colors.blue, fontSize: 18),
          ),
        ),
      ),
    );
  }
}