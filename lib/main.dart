import 'dart:io';
import 'package:alumni_circle_app/CounterScreen/counter_screen.dart';
import 'package:alumni_circle_app/WelcomeScreen/welcome_screen.dart';
import 'package:alumni_circle_app/components/aunt_wrapper.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/balance/cubit/balance_cubit.dart';
import 'package:alumni_circle_app/cubit/counter_cubit.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/cubit/feedback/cubit/feedback_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/question/cubit/question_cubit.dart';
import 'package:alumni_circle_app/cubit/reply/cubit/reply_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/pages/datas_screen.dart';
import 'package:alumni_circle_app/pages/feedback_page.dart';
import 'package:alumni_circle_app/pages/post_datas.dart';
import 'package:alumni_circle_app/pages/register/login_page.dart';
import 'package:alumni_circle_app/pages/register/register_page.dart';
import 'package:alumni_circle_app/pages/routes/BalanceScreen/balance_screen.dart';
import 'package:alumni_circle_app/pages/routes/SpendingScreen/spending_screen.dart';
import 'package:alumni_circle_app/pages/routes/customerService/customer_service_screen.dart';
import 'package:alumni_circle_app/pages/routes/formDataCs/form_data_screen.dart';
import 'package:alumni_circle_app/pages/user_control_page.dart';
import 'package:alumni_circle_app/pages/vertical_pager.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
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


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
        return MultiBlocProvider(
          providers:[
            BlocProvider<CounterCubit>(create: (context) => CounterCubit()),
            BlocProvider<BalanceCubit>(create: (context) => BalanceCubit()),
            BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
            BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
            BlocProvider<DiskusiCubit>(create: (context) => DiskusiCubit()),
            BlocProvider<ReplyCubit>(create: (context) => ReplyCubit()),
            BlocProvider<AlumniCubit>(create: (context) => AlumniCubit()),
            BlocProvider<EventCubit>(create: (context) => EventCubit()),
            BlocProvider<VacancyCubit>(create: (context) => VacancyCubit()),
            BlocProvider<FeedbackCubit>(create: (context) => FeedbackCubit()),
            BlocProvider<QuestionCubit>(create: (context) => QuestionCubit()),
            ], 
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Alumni Circle App",
          // home: const NavigatorBarPage(),
          theme: ThemeData(
            scaffoldBackgroundColor: secondaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.soraTextTheme(),
          ),
          navigatorObservers: [routeObserver],
          initialRoute: '/landing_page',
          routes: {
            '/landing_page': (context) =>  const LandingPage(),
            '/login': (context) =>  const LoginPage(),
            '/signup': (context) =>  const RegisterPage(),
            '/navigate': (context) =>  const AuthWrapper(child: NavigatorBarPage()),
            '/discussion': (context) =>  const AuthWrapper(child:DiscussionPage() ,) ,
            '/event': (context) =>  const AuthWrapper(child: EventPage(),) ,
            '/jobvacancy': (context) =>  const AuthWrapper(child: JobVacancyPage(),) ,
            '/listevent': (context) =>  const ListEventPage(),
            '/listvacancy': (context) =>  const ListVacancyPage(),
            '/aboutus': (context) =>  const AboutUs(),
            '/help': (context) =>  const HelpPage(),
            '/feedback': (context) =>  const FeedbackPage(),
            '/cateducation': (context) =>  const CategoryEducation(),
            '/catsport': (context) =>  const CategorySport(),
            '/semiwebi': (context) =>  const CategorySemiWebi(),
            '/anniversery': (context) =>  const CategoryAnniversery(),
            '/educare': (context) =>  const CategoryEducare(),
            '/newsscreen': (context) =>  const NewsScreen(),
            '/newpost': (context) =>  const NewsPostScreen(),
            '/post': (context) =>  const PostPage(),
            '/book': (context) =>  const BooksScreen(),
            '/datas': (context) =>  const DatasScreen(),
            '/postdatas': (context) =>  const FormScreen(),
            '/verticalPage': (context) =>  const VerticalCardPagger(),
            '/customerService': (context) =>  const CustomerServiceScreen(),
            '/formData': (context) =>  const FormDataScreen(),
            '/welcome': (context) =>  const WelcomeScreen(),
            '/counter': (context) =>  const CounterScreen(),
            '/balance_screen': (context) =>  const AuthWrapper(child: BalanceScreen()) ,
            '/spending_screen': (context) =>  const AuthWrapper(child: SpendingScreen()) ,
            '/user_control': (context) =>  const AuthWrapper(child: UserControlScreen()) ,
          },
        ));
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

