import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:alumni_circle_app/dto/news.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';

class DataService {
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      // Handle error
      throw Exception('Failed to load news');
    }
  }

  // post data to endpoint news
  static Future<News> createNews(String title, String body) async {
    final response = await http.post(
      Uri.parse(Endpoints.news),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      // Check for creation success (201 Created)
      final jsonResponse = jsonDecode(response.body);
      return News.fromJson(jsonResponse);
    } else {
      // Handle error
      throw Exception('Failed to create post: ${response.statusCode}');
    }
  }

  // Skema Update
  static Future<void> updateNews(String id, String title, String body) async {
    final response = await http.put(
      Uri.parse('${Endpoints.news}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update news: ${response.statusCode}');
    }
  }

  // Skema Delete
  static Future<void> deleteNews(String id) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.news}/$id'), // Append id to the endpoint URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // Check for successful deletion (204 No Content)
      return;
    } else {
      // Handle error
      throw Exception('Failed to delete news: ${response.statusCode}');
    }
  }
}
