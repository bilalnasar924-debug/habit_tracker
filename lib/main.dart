import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/Screens/configure_habit.dart';
import 'package:habit_tracker/Screens/forget_password_screen.dart';
import 'package:habit_tracker/Screens/home_screen.dart';
import 'package:habit_tracker/Screens/login_screen.dart';
import 'package:habit_tracker/Screens/notification_screen.dart';
import 'package:habit_tracker/Screens/personal_info_screen.dart';
import 'package:habit_tracker/Screens/report_screen.dart';
import 'package:habit_tracker/Screens/sign_up_screen.dart';
import 'package:habit_tracker/auth_gate.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/notification_provider.dart';
import 'package:habit_tracker/providers/quote_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotification() async{
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await notificationsPlugin.initialize(settings: initSettings);

}
void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
    try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  await initNotification();  
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => QuoteProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/forgetpassword' : (context) => ForgetPasswordScreen(),
        '/notification_screen' : (context) => NotificationScreen(),
        '/personal_info' : (context) => PersonalInfoScreen(),
        '/report_screen' : (context) => ReportScreen(),
        '/configurehabit' :(context) => ConfigureHabit(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    home: AuthGate(),
    );
  }
}
