import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  static Future<int> fetchRemainingTime(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://daram-gsm.kro.kr/api/times/remaintime'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['remaining_time'];
    } else {
      throw Exception('Failed to load remaining time');
    }
  }
}