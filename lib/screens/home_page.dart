import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  final Map<String, String> tokens;

  HomePage({required this.tokens});

  Future<Map<String, int>> fetchRemainingTime() async {
    final response = await http.get(
      Uri.parse('https://daram-gsm.kro.kr/api/times/remaintime'),
      headers: {
        'Authorization': 'Bearer ${tokens['accessToken']}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return {
        'hours': data['hoursUntilLimit'],
        'minutes': data['minutesUntilLimit'],
        'seconds': data['secondsUntilLimit'],
      };
    } else {
      throw Exception('Failed to load remaining time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              '쉽고 빠르게\n기숙사 입소 관리',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder<Map<String, int>>(
            future: fetchRemainingTime(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final time = snapshot.data!;
                return Text(
                  '${time['hours']}시간 ${time['minutes']}분 ${time['seconds']}초 남음',
                  style: GoogleFonts.roboto(
                    color: Colors.green,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            },
          ),
          // 여기에 다른 UI 요소들 추가
        ],
      ),
    );
  }
}
