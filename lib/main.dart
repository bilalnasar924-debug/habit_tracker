import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/login_screen.dart';
import 'package:habit_tracker/Screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
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
      },
      debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    );
  }
}
