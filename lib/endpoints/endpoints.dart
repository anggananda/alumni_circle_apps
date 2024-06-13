class Endpoints {
  static const String baseURL =
      "https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1";
  static const String news = "$baseURL/news";

  static const String urlDatas = "https://simobile.singapoly.com";
  static const String datas = "$urlDatas/api/datas";

  // !UTS
  static const String urlIssues = "https://simobile.singapoly.com";
  static const String issues = '$urlIssues/api/customer-service/2215091060';

  // ? Praktikum Cubit
  static const String nim = "2215091060";
  static const String balance = '$urlDatas/api/balance/$nim';
  static const String spending = '$urlDatas/api/spending/$nim';

  // ? Aunt
  // static const String login = "$urlDatas/api/auth/login";
  static const String logout = "$urlDatas/api/auth/logout";

  // ! Project UAS
  // static const String host = "10.0.2.2";
  static const String host = "10.11.0.71";

  static const String urlUas = "http://$host:5000";

  static const String alumni = "$urlUas/api/v1/alumni";
  static const String event = "$urlUas/api/v1/event";
  static const String vacancy = "$urlUas/api/v1/vacancy";
  static const String feedback = "$urlUas/api/v1/feedback";
  static const String question = "$urlUas/api/v1/question";
  static const String diskusi = "$urlUas/api/v1/diskusi";
  static const String reply = "$urlUas/api/v1/reply";
  static const String listEvent = "$urlUas/api/v1/list_event";
  static const String listVacancy = "$urlUas/api/v1/list_vacancy";
  static const String discussion = "$urlUas/api/v1/discussion";
  static const String profile = "$urlUas/api/v1/private/profile";
  static const String login = "$urlUas/api/v1/auth/login";
  static const String register = "$urlUas/api/v1/auth/register";
}
