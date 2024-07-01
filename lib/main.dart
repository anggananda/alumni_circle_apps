import 'package:alumni_circle_app/components/aunt_wrapper.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/category/cubit/category_cubit.dart';
import 'package:alumni_circle_app/cubit/diskusi/cubit/diskusi_cubit.dart';
import 'package:alumni_circle_app/cubit/event/cubit/event_cubit.dart';
import 'package:alumni_circle_app/cubit/feedback/cubit/feedback_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/question/cubit/question_cubit.dart';
import 'package:alumni_circle_app/cubit/reply/cubit/reply_cubit.dart';
import 'package:alumni_circle_app/cubit/vacancy/cubit/vacancy_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/change_password_page.dart';
import 'package:alumni_circle_app/pages/feedback_page.dart';
import 'package:alumni_circle_app/pages/input_url_page.dart';
import 'package:alumni_circle_app/pages/register/login_page.dart';
import 'package:alumni_circle_app/pages/register/register_page.dart';
import 'package:alumni_circle_app/pages/user_control_page.dart';
import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/pages/aboutus.dart';
import 'package:alumni_circle_app/pages/discussiion_page.dart';
import 'package:alumni_circle_app/pages/event_page.dart';
import 'package:alumni_circle_app/pages/help_page.dart';
import 'package:alumni_circle_app/pages/job_vacancy_page.dart';
import 'package:alumni_circle_app/pages/landing_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alumni_circle_app/pages/list_event_page.dart';
import 'package:alumni_circle_app/pages/list_vacancy_page.dart';
import 'package:alumni_circle_app/pages/navigate.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  _requestLocalNotifPermision();

  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request permission to receive notifications (Android only)
  if (defaultTargetPlatform == TargetPlatform.android) {
    NotificationSettings? settings = await messaging.requestPermission();
    debugPrint("${settings.authorizationStatus}");
  }

  // Listen to incoming messages in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint(
        "Received message in foreground: ${message.notification?.title}");
    // Use this data to display a notification or take other actions
    _showNotification(message);
    debugPrint("show notification here");
  });

  // Listen to incoming messages when the app is in background or terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint(
        "Received message when app was closed: ${message.notification?.title}");
    // Handle notification tap event (optional)
  });

  // Get the registration token for this device
  await Endpoints.initialize();
  String? token = await messaging.getToken();
  await SecureStorageUtil.storage.write(key: "device_token", value: token);
  debugPrint("Registration token: $token");
  runApp(const MyApp());
}

Future<void> _requestLocalNotifPermision() async {
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.requestNotificationsPermission();
}

void _showNotification(RemoteMessage message) {
  // Customize notification based on your needs
  RemoteNotification? notification = message.notification;
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('my_app_id', 'my_app_name',
          channelDescription: 'Only for demonstrate notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  if (notification != null) {
    flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, notificationDetails);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
              BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
              BlocProvider<DiskusiCubit>(create: (context) => DiskusiCubit()),
              BlocProvider<ReplyCubit>(create: (context) => ReplyCubit()),
              BlocProvider<AlumniCubit>(create: (context) => AlumniCubit()),
              BlocProvider<EventCubit>(create: (context) => EventCubit()),
              BlocProvider<VacancyCubit>(create: (context) => VacancyCubit()),
              BlocProvider<FeedbackCubit>(create: (context) => FeedbackCubit()),
              BlocProvider<QuestionCubit>(create: (context) => QuestionCubit()),
              BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Alumni Circle App",
              theme: ThemeData(
                scaffoldBackgroundColor: secondaryColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: GoogleFonts.soraTextTheme(),
              ),
              navigatorObservers: [routeObserver],
              // home: AuthCheck(),
              initialRoute: '/navigate',
              // initialRoute: '/landing_page',
              routes: {
                '/landing_page': (context) => const LandingPage(),
                '/login': (context) => const LoginPage(),
                '/signup': (context) => const RegisterPage(),
                '/change_password': (context) => const ChangePasswordPage(),
                '/navigate': (context) =>
                    const AuthWrapper(child: NavigatorBarPage()),
                '/discussion': (context) => const AuthWrapper(
                      child: DiscussionPage(),
                    ),
                '/event': (context) => const AuthWrapper(
                      child: EventPage(),
                    ),
                '/jobvacancy': (context) => const AuthWrapper(
                      child: JobVacancyPage(),
                    ),
                '/listevent': (context) => const AuthWrapper(
                      child: ListEventPage(),
                    ),
                '/listvacancy': (context) =>
                    const AuthWrapper(child: ListVacancyPage()),
                '/aboutus': (context) => const AboutUs(),
                '/help': (context) => const AuthWrapper(child: HelpPage()),
                '/feedback': (context) =>
                    const AuthWrapper(child: FeedbackPage()),
                '/user_control': (context) =>
                    const AuthWrapper(child: UserControlScreen()),
                '/input_url': (context) => const InputUrlPage(),
              },
            ));
      },
    );
  }
}
