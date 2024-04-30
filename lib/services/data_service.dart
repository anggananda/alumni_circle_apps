import 'dart:io';
import 'package:alumni_circle_app/dto/datas.dart';
import 'package:alumni_circle_app/dto/issues.dart';
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

  static Future<List<Datas>> fetchDatas() async {
    final response = await http.get(Uri.parse(Endpoints.datas));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Datas.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  // Delete data to endpoint datas
  static Future<void> deleteDatas(int id) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.datas}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      // Handle error
      throw Exception('Failed to delete news : ${response.statusCode}');
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

  // !Update Datas
  static Future<void> updateDatas(String name, File imageFile, int id) async {
    if (imageFile == null) {
      return; // Handle case where no image is selected
    }
    
    var request = http.MultipartRequest('POST', Uri.parse('${Endpoints.datas}/$id'));
    request.fields['name'] = name; // Add other data fields

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      // Check for success response (200 OK)
      print('Data and image updated successfully!');
    } else {
      // Handle error
      throw Exception('Error updating data: ${response.statusCode}');
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


  // !create Datas
  static Future<Datas> createDatas(String name, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Endpoints.datas),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );

    request.fields['name'] = name;

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      // Check for creation success (201 Created)
      final jsonResponse = jsonDecode(response.body);
      return Datas.fromJson(jsonResponse);
    } else {
      // Handle error
      throw Exception('Failed to create datas: ${response.statusCode}');
    }
  }


  //! untuk UTS
  // ? GET 
  static Future<List<Issues>> fetchIssues() async {
    final response = await http.get(Uri.parse(Endpoints.issues));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Issues.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  // ? Delete
  static Future<void> deleteIssues(int id) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.issues}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      // Handle error
      throw Exception('Failed to delete news : ${response.statusCode}');
    }
  }
}
