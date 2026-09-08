import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  User? _user;
  bool isLoading = false;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

   Future<void> signUp(String email, String password,int age ,String country, List<String> habits) async{
    isLoading = true;
    notifyListeners();
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;
      _user = user;
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'uid': user.uid,
        'age': age,
        'country': country,
        'habits': habits,
      });
      
    } on FirebaseAuthException catch (e){
       switch (e.code) {
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        case 'email-already-in-use':
          throw Exception('The account already exists for that email.');
        default:
          throw Exception('An error occurred. Please try again.');
       }
    } finally {
      isLoading = false;
      notifyListeners();
    }

   }


   Future<void> Login(String email , String password) async{
    isLoading = true;
    notifyListeners();
    try{
      final crendential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _user = crendential.user;
    } on FirebaseAuthException catch (e){
       print('Firebase Login Error: ${e.code}');
       print('Firebase Login Message: ${e.message}');
       rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
   }

}