import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _authUrl = "https://daram-gsm.kro.kr/gauth/authorization";
  static final String _tokenUrl = "https://daram-gsm.kro.kr/api/login/gauth/code";
  static final String _redirectUrl = "https://daram-gsm.kro.kr/page";

  static Future<Map<String, String>> signInWithOAuth(BuildContext context) async {
    String code = await _getAuthorizationCode(context);
    Map<String, String> tokens = await _getTokensFromCode(code);
    await _storeTokens(tokens);

    return tokens;
  }

  static Future<String> _getAuthorizationCode(BuildContext context) async {
    String code = "";

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("Login")),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(_authUrl)),
            onWebViewCreated: (controller) {},
            onLoadStart: (controller, url) {
              if (url.toString().startsWith(_redirectUrl)) {
                final Uri uri = Uri.parse(url.toString());
                code = uri.queryParameters['code'] ?? "";
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
    print('Authorization code: $code');
    return code;
  }

  static Future<Map<String, String>> _getTokensFromCode(String code) async {
    final body = jsonEncode({"code": "$code"});
    print('Sending POST request to $_tokenUrl');
    print('Request headers:');
    print({'Content-Type': 'application/json'});
    print('Request body:');
    print(body);
    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } else {
      throw Exception('Failed to obtain tokens');
    }
  }

  static Future<void> _storeTokens(Map<String, String> tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', tokens['accessToken'] ?? '');
    await prefs.setString('refreshToken', tokens['refreshToken'] ?? '');
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}

void signInAndNavigate(BuildContext context) async {
  try {
    Map<String, String> tokens = await AuthService.signInWithOAuth(context);
    Navigator.pushReplacementNamed(context, '/home', arguments: tokens);
  } catch (e) {
    print('Login failed: $e');
  }
}
