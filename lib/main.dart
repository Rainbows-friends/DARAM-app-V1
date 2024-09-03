import 'package:flutter/material.dart';
import 'package:daramappv1/screens/home_page.dart';
import 'package:daramappv1/screens/login_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io'; // Platform을 사용하기 위해 추가

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 초기화 필요
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DARAM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) {
          final tokens = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return HomePage(tokens: tokens);
        },
      },
    );
  }
}