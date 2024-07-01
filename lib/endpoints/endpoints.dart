// class Endpoints {
//   // ! Project UAS

//   static const String host = "10.0.2.2";
//   // static const String host = "192.168.87.236";
//   // static const String urlUas = "http://$host:5000";
//   static const String urlUas = "https://73f8-103-76-173-196.ngrok-free.app";

//   static const String alumni = "$urlUas/api/v1/alumni";
//   static const String event = "$urlUas/api/v1/event";
//   static const String category = "$urlUas/api/v1/kategori";
//   static const String vacancy = "$urlUas/api/v1/vacancy";
//   static const String feedback = "$urlUas/api/v1/feedback";
//   static const String question = "$urlUas/api/v1/question";
//   static const String diskusi = "$urlUas/api/v1/diskusi";
//   static const String reply = "$urlUas/api/v1/reply";
//   static const String listEvent = "$urlUas/api/v1/list_event";
//   static const String listVacancy = "$urlUas/api/v1/list_vacancy";
//   static const String discussion = "$urlUas/api/v1/discussion";
//   static const String profile = "$urlUas/api/v1/private/profile";
//   static const String login = "$urlUas/api/v1/auth/login";
//   static const String logout = "$urlUas/api/v1/auth/logout";
//   static const String register = "$urlUas/api/v1/auth/register";
//   static const String notification = "$urlUas/api/v1/private/fcm";
//   static const String checkToken = "$urlUas/api/v1/private/check-token";
// }

import 'package:alumni_circle_app/utils/secure_storage_util.dart';

class Endpoints {
  static late String urlUas;
  
  // Panggil metode ini selama inisialisasi aplikasi
  static Future<void> initialize() async {
    final urlInput = await SecureStorageUtil.storage.read(key: 'url_setting');
    urlUas = urlInput ?? "default_url_if_not_found";
  }

  static String get alumni => "$urlUas/api/v1/alumni";
  static String get event => "$urlUas/api/v1/event";
  static String get category => "$urlUas/api/v1/kategori";
  static String get vacancy => "$urlUas/api/v1/vacancy";
  static String get feedback => "$urlUas/api/v1/feedback";
  static String get question => "$urlUas/api/v1/question";
  static String get diskusi => "$urlUas/api/v1/diskusi";
  static String get reply => "$urlUas/api/v1/reply";
  static String get listEvent => "$urlUas/api/v1/list_event";
  static String get listVacancy => "$urlUas/api/v1/list_vacancy";
  static String get discussion => "$urlUas/api/v1/discussion";
  static String get profile => "$urlUas/api/v1/private/profile";
  static String get login => "$urlUas/api/v1/auth/login";
  static String get logout => "$urlUas/api/v1/auth/logout";
  static String get register => "$urlUas/api/v1/auth/register";
  static String get notification => "$urlUas/api/v1/private/fcm";
  static String get checkToken => "$urlUas/api/v1/private/check-token";
  static String get forgotPassword => "$urlUas/api/v1/auth/forgot_password";
  static String get verification => "$urlUas/api/v1/auth/verification";
  static String get changePassword => "$urlUas/api/v1/auth/change_password";

}
