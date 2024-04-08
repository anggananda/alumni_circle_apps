import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/details/detail_event.dart';
import 'package:my_app/details/detail_forum.dart';
import 'package:my_app/details/detail_vacancy.dart';
import 'package:my_app/newPost/news_post.dart';
import 'package:my_app/pages/aboutus.dart';
import 'package:my_app/pages/anniversery_category.dart';
import 'package:my_app/pages/educare_category.dart';
import 'package:my_app/pages/education_category.dart';
import 'package:my_app/pages/discussiion_page.dart';
import 'package:my_app/pages/event_page.dart';
import 'package:my_app/pages/job_vacancy_page.dart';
import 'package:my_app/pages/landing_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/pages/list_event_page.dart';
import 'package:my_app/pages/list_vacancy_page.dart';
import 'package:my_app/pages/navigate.dart';
import 'package:my_app/pages/news_screen.dart';
import 'package:my_app/pages/postingan_crud_screen.dart';
import 'package:my_app/pages/semweb_category.dart';
import 'package:my_app/pages/sport_category.dart';
import 'package:my_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Alumni Circle App",
          home: const LandingPage(),
          theme: ThemeData(
            scaffoldBackgroundColor: primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.soraTextTheme(),
          ),
          routes: {
            '/navigate': (context) =>  const NavigatorBarPage(),
            '/discussion': (context) =>  const DiscussionPage(),
            '/event': (context) =>  const EventPage(),
            '/jobvacancy': (context) =>  const JobVacancyPage(),
            '/listevent': (context) =>  const ListEventPage(),
            '/listvacancy': (context) =>  const ListVacancyPage(),
            '/aboutus': (context) =>  const AboutUs(),
            '/cateducation': (context) =>  const CategoryEducation(),
            '/catsport': (context) =>  const CategorySport(),
            '/semiwebi': (context) =>  const CategorySemiWebi(),
            '/anniversery': (context) =>  const CategoryAnniversery(),
            '/educare': (context) =>  const CategoryEducare(),
            '/detailforum': (context) =>  const DetailForum(),
            '/detailevent': (context) =>  const DetailEvent(),
            '/detailvacancy': (context) =>  const DetailVacancy(),
            '/newsscreen': (context) =>  const NewsScreen(),
            '/newpost': (context) =>  const NewsPostScreen(),
            '/postingan': (context) =>  const PostinganPage(),
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

