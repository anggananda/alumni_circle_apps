import 'dart:io';
import 'package:alumni_circle_app/pages/datas_screen.dart';
import 'package:alumni_circle_app/pages/post_datas.dart';
import 'package:alumni_circle_app/pages/register/login_page.dart';
import 'package:alumni_circle_app/pages/register/signup_page.dart';
import 'package:alumni_circle_app/pages/routes/customerService/customer_service_screen.dart';
import 'package:alumni_circle_app/pages/routes/formDataCs/form_data_screen.dart';
import 'package:alumni_circle_app/pages/updateform/update_data.dart';
import 'package:alumni_circle_app/pages/vertical_pager.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/details/detail_event.dart';
import 'package:alumni_circle_app/details/detail_forum.dart';
import 'package:alumni_circle_app/details/detail_vacancy.dart';
import 'package:alumni_circle_app/newPost/news_post.dart';
import 'package:alumni_circle_app/pages/aboutus.dart';
import 'package:alumni_circle_app/pages/anniversery_category.dart';
import 'package:alumni_circle_app/pages/educare_category.dart';
import 'package:alumni_circle_app/pages/education_category.dart';
import 'package:alumni_circle_app/pages/discussiion_page.dart';
import 'package:alumni_circle_app/pages/event_page.dart';
import 'package:alumni_circle_app/pages/help_screen.dart';
import 'package:alumni_circle_app/pages/job_vacancy_page.dart';
import 'package:alumni_circle_app/pages/landing_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumni_circle_app/pages/list_event_page.dart';
import 'package:alumni_circle_app/pages/list_vacancy_page.dart';
import 'package:alumni_circle_app/pages/navigate.dart';
import 'package:alumni_circle_app/pages/news_screen.dart';
import 'package:alumni_circle_app/pages/post_screen.dart';
import 'package:alumni_circle_app/pages/routes/BookScreen/book_screen.dart';
import 'package:alumni_circle_app/pages/semweb_category.dart';
import 'package:alumni_circle_app/pages/sport_category.dart';
import 'package:alumni_circle_app/utils/constants.dart';
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
            scaffoldBackgroundColor: secondaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.soraTextTheme(),
          ),
          routes: {
            '/login': (context) =>  const LoginPage(),
            '/signup': (context) =>  const SignUpPage(),
            '/navigate': (context) =>  const NavigatorBarPage(),
            '/discussion': (context) =>  const DiscussionPage(),
            '/event': (context) =>  const EventPage(),
            '/jobvacancy': (context) =>  const JobVacancyPage(),
            '/listevent': (context) =>  const ListEventPage(),
            '/listvacancy': (context) =>  const ListVacancyPage(),
            '/aboutus': (context) =>  const AboutUs(),
            '/help': (context) =>  const HelpPage(),
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
            '/post': (context) =>  const PostPage(),
            '/book': (context) =>  const BooksScreen(),
            '/datas': (context) =>  const DatasScreen(),
            '/postdatas': (context) =>  const FormScreen(),
            '/verticalPage': (context) =>  const VerticalCardPagger(),
            '/customerService': (context) =>  const CustomerServiceScreen(),
            '/formData': (context) =>  const FormDataScreen(),
            // '/updateDatas': (context) =>  const UpdateFormDatas(),
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

