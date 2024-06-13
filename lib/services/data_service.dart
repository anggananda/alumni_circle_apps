import 'dart:io';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/dto/balances.dart';
import 'package:alumni_circle_app/dto/datas.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/dto/feedback.dart';
import 'package:alumni_circle_app/dto/issues.dart';
import 'package:alumni_circle_app/dto/list_event.dart';
import 'package:alumni_circle_app/dto/list_vacancy.dart';
import 'package:alumni_circle_app/dto/profile.dart';
import 'package:alumni_circle_app/dto/question.dart';
import 'package:alumni_circle_app/dto/reply.dart';
import 'package:alumni_circle_app/dto/spendings.dart';
import 'package:alumni_circle_app/dto/total.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
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

    var request =
        http.MultipartRequest('POST', Uri.parse('${Endpoints.datas}/$id'));
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

  // ? Praktikum Cubit

  // ! Get API Balance
  static Future<List<Balances>> fetchBalances() async {
    final response = await http.get(Uri.parse(Endpoints.balance));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Balances.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  // ! Get API Spending
  static Future<List<Spendings>> fetchSpendings() async {
    final response = await http.get(Uri.parse(Endpoints.spending));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Spendings.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  // ! Post Spending
  static Future<http.Response> sendSpendingData(int spending) async {
    final url = Uri.parse(Endpoints.spending);
    final data = {'spending': spending};

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    return response;
  }

  // ! Post Login
  // static Future<http.Response> sendLoginData(
  //     String email, String password) async {
  //   final url = Uri.parse(Endpoints.login);
  //   final data = {'email': email, 'password': password};

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(data),
  //   );

  //   return response;
  // }

// ? Login
  static Future<http.Response> sendLoginData(
      String username, String password) async {
    final url = Uri.parse(Endpoints.login);
    final data = {'username': username, 'password': password};

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

  // !Logout
  static Future<http.Response> logoutData() async {
    final url = Uri.parse(Endpoints.logout);
    final String? accessToken =
        await SecureStorageUtil.storage.read(key: tokenStoreName);
    debugPrint("Logout with $accessToken");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    return response;
  }

  // ! Data Service Project UAS

  // ? Register
  static Future<http.Response> sendRegister(
      String email, String username, String password) async {
    final url = Uri.parse(Endpoints.register);
    final data = {'email': email, 'username': username, 'password': password};
    final response = await http.post(
      url,
      body: data,
    );
    return response;
  }

  // ? Modul Alumni
  static Future<List<Alumni>> fetchAlumniAll(int page, String search) async {
    final uri = Uri.parse('${Endpoints.alumni}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Alumni.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<List<Alumni>> fetchAlumni(int idAlumni) async {
    final response =
        await http.get(Uri.parse('${Endpoints.alumni}/read/$idAlumni'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final alumniData = data['datas'];
      final alumni = Alumni.fromJson(alumniData as Map<String, dynamic>);
      return [alumni];
    } else {
      throw Exception(
          'Failed to load datas'); // Menampilkan pesan error dari respons API
    }
  }

  static Future<http.Response> updateAlumni(
      int idAlumni,
      String name,
      String gender,
      String address,
      String email,
      String graduateDate,
      String batch,
      String jobStatus,
      File? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.alumni}/update/$idAlumni'),
      );

      request.fields['nama_alumni'] = name;
      request.fields['jenis_kelamin'] = gender;
      request.fields['alamat'] = address;
      request.fields['email'] = email;
      request.fields['tanggal_lulus'] = graduateDate;
      request.fields['angkatan'] = batch;
      request.fields['status_pekerjaan'] = jobStatus;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_profile',
            imageFile.path,
          ),
        );
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to update alumni: $e');
    }
  }

  static Future<http.Response> deleteAlumni(int idAlumni) async {
    final url = Uri.parse('${Endpoints.alumni}/delete/$idAlumni');
    final response = await http.delete(url);
    return response;
  }

  // ? Modul Event
  static Future<List<Events>> fetchEvents(int page, String search) async {
    final uri = Uri.parse('${Endpoints.event}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Events.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<http.Response> sendEvent(String eventName, String eventDate,
      String eventLocation, String eventDescription, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Endpoints.event}/create'), // Ganti dengan URL endpoint Anda
      );

      request.fields['nama_event'] = eventName;
      request.fields['tanggal_event'] = eventDate;
      request.fields['lokasi'] = eventLocation;
      request.fields['deskripsi'] = eventDescription;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            imageFile.path,
          ),
        );
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  static Future<http.Response> updateEvent(
      int idEvent,
      String eventName,
      String eventDate,
      String eventLocation,
      String eventDescription,
      File? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.event}/update/$idEvent'),
      );

      request.fields['nama_event'] = eventName;
      request.fields['tanggal_event'] = eventDate;
      request.fields['lokasi'] = eventLocation;
      request.fields['deskripsi'] = eventDescription;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            imageFile.path,
          ),
        );
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  static Future<http.Response> deleteEvent(int idEvent) async {
    final url = Uri.parse('${Endpoints.event}/delete/$idEvent');
    final response = await http.delete(url);
    return response;
  }

  // ? Modul Vacancy
  static Future<List<Vacancies>> fetchVacancies(int page, String search) async {
    final uri =
        Uri.parse('${Endpoints.vacancy}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Vacancies.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Vacancy');
    }
  }

  static Future<http.Response> sendVacancy(
      String vacancyName, String vacancyDescription, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Endpoints.vacancy}/create'), // Ganti dengan URL endpoint Anda
      );

      request.fields['nama_vacancy'] = vacancyName;
      request.fields['deskripsi'] = vacancyDescription;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            imageFile.path,
          ),
        );
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to create Vacancy: $e');
    }
  }

  static Future<http.Response> updateVacancy(int idVacancy, String vacancyName,
      String vacancyDescription, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.vacancy}/update/$idVacancy'),
      );

      request.fields['nama_vacancy'] = vacancyName;
      request.fields['deskripsi'] = vacancyDescription;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            imageFile.path,
          ),
        );
      }

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  static Future<http.Response> deleteVacancy(int idVacancy) async {
    final url = Uri.parse('${Endpoints.vacancy}/delete/$idVacancy');
    final response = await http.delete(url);
    return response;
  }

  // ? Modul Profile
  static Future<Profile> fetchProfile(String? accessToken) async {
    accessToken ??= await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.get(
      Uri.parse(Endpoints.profile),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    debugPrint('Profile response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }

      try {
        return Profile.fromJson(jsonResponse);
      } catch (e) {
        throw Exception('Failed to parse Profile: $e');
      }
    } else {
      // Handle error
      throw Exception(
          'Failed to load Profile with status code: ${response.statusCode}');
    }
  }

  // ? Modul List Event
  static Future<List<ListEvents>> fetchListEvent(int idALumni) async {
    final response =
        await http.get(Uri.parse('${Endpoints.listEvent}/read/$idALumni'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => ListEvents.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load List Event');
    }
  }

  static Future<http.Response> sendListEvent(int idAlumni, int idEvent) async {
    final url = Uri.parse('${Endpoints.listEvent}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'id_event': idEvent.toString()
    };

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

  static Future<http.Response> deleteListEvent(int idListEvent) async {
    final url = Uri.parse('${Endpoints.listEvent}/delete/$idListEvent');
    final response = await http.delete(url);
    return response;
  }

  // ? Modul List Vacancy
  static Future<List<ListVacancy>> fetchListVacancy(int idALumni) async {
    final response =
        await http.get(Uri.parse('${Endpoints.listVacancy}/read/$idALumni'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => ListVacancy.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load List Event');
    }
  }

  static Future<http.Response> sendListVacancy(
      int idAlumni, int idVacancy) async {
    final url = Uri.parse('${Endpoints.listVacancy}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'id_vacancy': idVacancy.toString()
    };

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

  static Future<http.Response> deleteListVacancy(int idListVacancy) async {
    final url = Uri.parse('${Endpoints.listVacancy}/delete/$idListVacancy');
    final response = await http.delete(url);
    return response;
  }

  // ? Diskusi
  static Future<List<Diskusi>> fetchDiskusi(int page, String search) async {
    final uri =
        Uri.parse('${Endpoints.diskusi}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Diskusi.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<http.Response> sendDiskusi(
      int idAlumni, String subject, String content) async {
    final url = Uri.parse('${Endpoints.diskusi}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'subjek_diskusi': subject,
      'isi_diskusi': content
    };

    final response = await http.post(
      url,
      body: data,
    );
    return response;
  }

  static Future<http.Response> updateDiskusi(
      int idDiskusi, String subject, String content) async {
    final url = Uri.parse('${Endpoints.diskusi}/update/$idDiskusi');
    final data = {'subjek_diskusi': subject, 'isi_diskusi': content};

    final response = await http.put(
      url,
      body: data,
    );
    return response;
  }

  static Future<http.Response> deleteDiskusi(int idDiskusi) async {
    final url = Uri.parse('${Endpoints.diskusi}/delete/$idDiskusi');
    final response = await http.delete(url);
    return response;
  }

  // ?Reply
  static Future<List<Replies>> fetchReply(int idDiskusi) async {
    final response =
        await http.get(Uri.parse('${Endpoints.reply}/read/$idDiskusi'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Replies.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<List<Total>> fetchTotalReply(int idDiskusi) async {
    final response =
        await http.get(Uri.parse('${Endpoints.reply}/total/$idDiskusi'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Total.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<http.Response> sendReplies(
      int idAlumni, int idDiskusi, String isiReply) async {
    final url = Uri.parse('${Endpoints.reply}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'id_diskusi': idDiskusi.toString(),
      'isi_reply': isiReply,
    };

    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to send reply. Status code: ${response.statusCode}');
    }

    return response;
  }

  static Future<http.Response> updateReply(int idReply, String content) async {
    final url = Uri.parse('${Endpoints.reply}/update/$idReply');
    final data = {'isi_reply': content};

    final response = await http.put(
      url,
      body: data,
    );
    return response;
  }

  static Future<http.Response> deleteReply(int idReply) async {
    final url = Uri.parse('${Endpoints.reply}/delete/$idReply');
    final response = await http.delete(url);
    return response;
  }

  // ? Question
  static Future<http.Response> sendQuestion(
      int idAlumni, String question) async {
    final url = Uri.parse('${Endpoints.question}/create');
    final data = {'id_alumni': idAlumni.toString(), 'isi_pertanyaan': question};
    final response = await http.post(
      url,
      body: data,
    );
    return response;
  }

  static Future<List<Question>> fetchQuestion(int page, String search) async {
    final uri =
        Uri.parse('${Endpoints.question}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  // ? Feedback
  static Future<http.Response> sendFeedback(
      int idAlumni, String feedback) async {
    final url = Uri.parse('${Endpoints.feedback}/create');
    final data = {'id_alumni': idAlumni.toString(), 'isi_feedback': feedback};
    final response = await http.post(
      url,
      body: data,
    );
    return response;
  }

  static Future<List<FeedBacks>> fetchFeedback(int page, String search) async {
    final uri =
        Uri.parse('${Endpoints.feedback}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => FeedBacks.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load feedback');
    }
  }
}
