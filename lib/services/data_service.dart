import 'dart:io';
import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/dto/category.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/dto/event.dart';
import 'package:alumni_circle_app/dto/feedback.dart';
import 'package:alumni_circle_app/dto/list_event.dart';
import 'package:alumni_circle_app/dto/list_vacancy.dart';
import 'package:alumni_circle_app/dto/profile.dart';
import 'package:alumni_circle_app/dto/question.dart';
import 'package:alumni_circle_app/dto/reply.dart';
import 'package:alumni_circle_app/dto/vacancy.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alumni_circle_app/endpoints/endpoints.dart';

class DataService {
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
    final url = Uri.parse(Endpoints.login.toString());
    final data = {'username': username, 'password': password};

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

  // !Logout
  // static Future<http.Response> logoutData() async {
  //   final url = Uri.parse(Endpoints.logout);
  //   final String? accessToken =
  //       await SecureStorageUtil.storage.read(key: tokenStoreName);
  //   debugPrint("Logout with $accessToken");

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $accessToken'
  //     },
  //   );

  //   return response;
  // }

  static Future<http.Response> logoutData() async {
    final url = Uri.parse(Endpoints.logout.toString());
    final String? accessToken =
        await SecureStorageUtil.storage.read(key: tokenStoreName);
    debugPrint("Logout with $accessToken");

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    return response;
  }

  // ! Data Service Project UAS

  // ? Register
  static Future<http.Response> sendRegister(
      String email, String username, String password) async {
    final url = Uri.parse(Endpoints.register.toString());
    final data = {'email': email, 'username': username, 'password': password};
    final response = await http.post(
      url,
      body: data,
    );
    return response;
  }

  // ? Modul Alumni
  static Future<List<Alumni>> fetchAlumniAll(
      int page, String search, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri = Uri.parse('${Endpoints.alumni}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Alumni.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<List<Alumni>> fetchAlumni(
      int idAlumni, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      if (accessToken.isEmpty) {
        throw Exception('Access token is missing');
      }
    }

    final idAlumniString =
        await SecureStorageUtil.storage.read(key: 'idAlumni');

    // Cek apakah idAlumniString bukan null dan konversi ke int
    if (idAlumniString != null) {
      final parsedIdAlumni = int.tryParse(idAlumniString);
      if (parsedIdAlumni != null) {
        idAlumni = parsedIdAlumni;
      } else {
        debugPrint('Error: idAlumniString is not a valid integer');
      }
    } else {
      debugPrint('Error: idAlumniString is null');
    }

    final response = await http.get(
      Uri.parse('${Endpoints.alumni}/read/$idAlumni'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      if (data == null || data['datas'] == null) {
        throw Exception('Invalid data format');
      }
      final alumniData = data['datas'];
      final alumni = Alumni.fromJson(alumniData as Map<String, dynamic>);
      return [alumni];
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      final errorMessage = errorData?['message'] ?? 'Failed to load data';
      throw Exception(errorMessage);
    }
  }

  static Future<http.Response> updateAlumni(
      int idAlumni,
      String name,
      String username,
      String gender,
      String address,
      String email,
      String graduateDate,
      String batch,
      String jobStatus,
      File? imageFile,
      String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.alumni}/update/$idAlumni'),
      );

      if (accessToken.isEmpty) {
        accessToken =
            (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      }

      request.headers.addAll({'Authorization': 'Bearer $accessToken'});

      request.fields['nama_alumni'] = name;
      request.fields['username'] = username;
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

  static Future<http.Response> deleteAlumni(
      int idAlumni, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.alumni}/delete/$idAlumni');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ? Modul Event
  static Future<List<Events>> fetchEvents(
      int page, String search, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri = Uri.parse('${Endpoints.event}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Events.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<List<Events>> fetchEventCategory(
      int idCategory, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri = Uri.parse('${Endpoints.event}/read_cate/$idCategory');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Events.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<http.Response> sendEvent(
      int idCategory,
      String eventName,
      String eventDate,
      String eventLocation,
      String eventDescription,
      File? imageFile,
      String latitude,
      String longitude,
      String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Endpoints.event}/create'),
      );

      if (accessToken.isEmpty) {
        accessToken =
            (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      }

      request.headers.addAll({'Authorization': 'Bearer $accessToken'});

      request.fields['id_kategori'] = idCategory.toString();
      request.fields['nama_event'] = eventName;
      request.fields['tanggal_event'] = eventDate;
      request.fields['lokasi'] = eventLocation;
      request.fields['deskripsi'] = eventDescription;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;

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
      int idCategory,
      String eventName,
      String eventDate,
      String eventLocation,
      String eventDescription,
      File? imageFile,
      String latitude,
      String longitude,
      String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.event}/update/$idEvent'),
      );

      if (accessToken.isEmpty) {
        accessToken =
            (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      }

      request.headers.addAll({'Authorization': 'Bearer $accessToken'});

      request.fields['id_kategori'] = idCategory.toString();
      request.fields['nama_event'] = eventName;
      request.fields['tanggal_event'] = eventDate;
      request.fields['lokasi'] = eventLocation;
      request.fields['deskripsi'] = eventDescription;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;

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

  static Future<http.Response> deleteEvent(
      int idEvent, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.event}/delete/$idEvent');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ? Modul Vacancy
  static Future<List<Vacancies>> fetchVacancies(
      int page, String search, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri =
        Uri.parse('${Endpoints.vacancy}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Vacancies.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Vacancy');
    }
  }

  static Future<http.Response> sendVacancy(String vacancyName,
      String vacancyDescription, File? imageFile, String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Endpoints.vacancy}/create'), // Ganti dengan URL endpoint Anda
      );

      if (accessToken.isEmpty) {
        accessToken =
            (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      }

      request.headers.addAll({'Authorization': 'Bearer $accessToken'});

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
      String vacancyDescription, File? imageFile, String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Endpoints.vacancy}/update/$idVacancy'),
      );

      if (accessToken.isEmpty) {
        accessToken =
            (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
      }

      request.headers.addAll({'Authorization': 'Bearer $accessToken'});

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

  static Future<http.Response> deleteVacancy(
      int idVacancy, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.vacancy}/delete/$idVacancy');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  static Future<bool> checkVerifyToken() async {
    final url = Uri.parse(Endpoints.checkToken.toString());
    final accessToken =
        await SecureStorageUtil.storage.read(key: tokenStoreName);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // Check status code for successful response (200)
    return response.statusCode == 200;
  }

  // ? Modul Profile
  static Future<Profile> fetchProfile(String? accessToken) async {
    accessToken ??= await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.get(
      Uri.parse(Endpoints.profile.toString()),
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
  static Future<List<ListEvents>> fetchListEvent(
      int idALumni, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final response = await http.get(
      Uri.parse('${Endpoints.listEvent}/read/$idALumni'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => ListEvents.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load List Event');
    }
  }

  static Future<http.Response> sendListEvent(
      int idAlumni, int idEvent, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.listEvent}/create');
    final data = {
      'id_alumni': idAlumni == 0
          ? (await SecureStorageUtil.storage.read(key: 'idAlumni'))!
          : idAlumni.toString(),
      'id_event': idEvent.toString()
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );

    return response;
  }

  static Future<http.Response> deleteListEvent(
      int idListEvent, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.listEvent}/delete/$idListEvent');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ? Modul List Vacancy
  static Future<List<ListVacancy>> fetchListVacancy(
      int idALumni, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final response = await http.get(
      Uri.parse('${Endpoints.listVacancy}/read/$idALumni'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
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
      int idAlumni, int idVacancy, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.listVacancy}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'id_vacancy': idVacancy.toString()
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );

    return response;
  }

  static Future<http.Response> deleteListVacancy(
      int idListVacancy, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.listVacancy}/delete/$idListVacancy');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ? Diskusi
  static Future<List<Diskusi>> fetchDiskusi(
      int page, String search, String? accessToken) async {
    if (accessToken!.isEmpty) {
      accessToken = await SecureStorageUtil.storage.read(key: tokenStoreName);
    }
    final uri =
        Uri.parse('${Endpoints.diskusi}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

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
      int idAlumni, String subject, String content, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.diskusi}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'subjek_diskusi': subject,
      'isi_diskusi': content
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );
    return response;
  }

  static Future<http.Response> updateDiskusi(
      int idDiskusi, String subject, String content, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.diskusi}/update/$idDiskusi');
    final data = {'subjek_diskusi': subject, 'isi_diskusi': content};

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );
    return response;
  }

  static Future<http.Response> deleteDiskusi(
      int idDiskusi, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.diskusi}/delete/$idDiskusi');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ?Reply
  static Future<List<Replies>> fetchReply(
      int idDiskusi, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }

    final response = await http.get(
      Uri.parse('${Endpoints.reply}/read/$idDiskusi'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Replies.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  // static Future<List<Total>> fetchTotalReply(
  //     int idDiskusi, String accessToken) async {
  //   if (accessToken.isEmpty) {
  //     accessToken =
  //         (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
  //   }
  //   final response = await http.get(
  //     Uri.parse('${Endpoints.reply}/total/$idDiskusi'),
  //     headers: {'Authorization': 'Bearer $accessToken'},
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     return (data['datas'] as List<dynamic>)
  //         .map((item) => Total.fromJson(item as Map<String, dynamic>))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load datas');
  //   }
  // }

  static Future<http.Response> sendReplies(
      int idAlumni, int idDiskusi, String isiReply, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.reply}/create');
    final data = {
      'id_alumni': idAlumni.toString(),
      'id_diskusi': idDiskusi.toString(),
      'isi_reply': isiReply,
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to send reply. Status code: ${response.statusCode}');
    }

    return response;
  }

  static Future<http.Response> updateReply(
      int idReply, String content, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.reply}/update/$idReply');
    final data = {'isi_reply': content};

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );
    return response;
  }

  static Future<http.Response> deleteReply(
      int idReply, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.reply}/delete/$idReply');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  // ? Question
  static Future<http.Response> sendQuestion(
      int idAlumni, String question, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.question}/create');
    final data = {'id_alumni': idAlumni.toString(), 'isi_pertanyaan': question};
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );
    return response;
  }

  static Future<List<Question>> fetchQuestion(
      int page, String search, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri =
        Uri.parse('${Endpoints.question}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
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
      int idAlumni, String feedback, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final url = Uri.parse('${Endpoints.feedback}/create');
    final data = {'id_alumni': idAlumni.toString(), 'isi_feedback': feedback};
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: data,
    );
    return response;
  }

  static Future<List<FeedBacks>> fetchFeedback(
      int page, String search, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri =
        Uri.parse('${Endpoints.feedback}/read').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => FeedBacks.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  // ? Modul Category
  static Future<List<Categories>> fetchCategory(String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    final uri = Uri.parse('${Endpoints.category}/read');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Categories.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  // ? Notification
  static Future<http.Response> sendNotification(String title, String body,
      String fcmToken, String auxData, String accessToken) async {
    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    if (fcmToken.isEmpty) {
      fcmToken = (await SecureStorageUtil.storage.read(key: "device_token"))!;
    }
    final url = Uri.parse('${Endpoints.notification}/send');
    final data = {
      'title': title,
      'body': body,
      'aux_data': auxData,
      'fcm_token': fcmToken,
    };

    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $accessToken'}, body: data);

    return response;
  }

  // ? forgot_password
  static Future<http.Response> sendForgotPassword(
      String username, String email) async {
    final url = Uri.parse(Endpoints.forgotPassword);
    final data = {'username': username, 'email': email};
    final response = await http.post(url, body: data);
    return response;
  }

  // ? forgot_password
  static Future<http.Response> sendVerification(
      String token) async {
    final url = Uri.parse(Endpoints.verification);
    final data = {'token': token};
    final response = await http.post(url, body: data);
    return response;
  }

  // ? forgot_password
  static Future<http.Response> sendChangePassword(
      String username, String password) async {
    final url = Uri.parse(Endpoints.changePassword);
    final data = {'username': username, 'password': password};
    final response = await http.post(url, body: data);
    return response;
  }
}
