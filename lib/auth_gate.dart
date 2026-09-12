import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/home_screen.dart';
import 'package:habit_tracker/Screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        if(snapshot.hasError){
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if(snapshot.hasData){
          return FutureBuilder(
            future: context.read<AuthProvider>().loadUserData(),
            builder: (context, Usersnapshot) {
              if(Usersnapshot.connectionState == ConnectionState.waiting){
                return Scaffold(
                  body: Center(child: CircularProgressIndicator(),),
                );
              }
              return HomeScreen();
            },
          );
        }
        return LoginScreen();
      },

    );
  }
}