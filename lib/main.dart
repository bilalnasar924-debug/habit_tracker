import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/home_screen.dart';
import 'package:habit_tracker/Screens/login_screen.dart';
import 'package:habit_tracker/Screens/sign_up_screen.dart';
import 'package:habit_tracker/auth_gate.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp( MultiProvider(
    providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    home: AuthGate(),
    );
  }
}
