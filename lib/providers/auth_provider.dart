import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  User? _user;
  bool isLoading = false;
  String? _username;
  String? get username => _username;
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  int? _age;
  String? _country;

  int? get age => _age;
  String? get country => _country; 

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> loadUserData() async{
    final user = _auth.currentUser;
    if(user == null){
      return;
    }
    _user = user;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if(doc.exists){
      _username = doc.data()?['username'];
      _age = doc.data()?['age'];
      _country = doc.data()?['country'];
    }
    notifyListeners();
  }

   Future<void> signUp( String username, String email, String password,int age ,String country, List<String> habits) async{
    isLoading = true;
    notifyListeners();
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;
      _user = user;
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'uid': user.uid,
        'age': age,
        'country': country,
        'habits': habits,
      });
      _username = username;
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
      final doc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

      _username = doc.data()?['username'];
    } on FirebaseAuthException catch (e){
       print('Firebase Login Error: ${e.code}');
       print('Firebase Login Message: ${e.message}');
       rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
   }

   Future<void> forgetPassword(String email) async {
    isLoading = true;
    notifyListeners();
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }catch(e){
      debugPrint('Error in Reseting Password $e');
      rethrow;
    }finally{
      isLoading = false;
      notifyListeners();
    }
    


   }


   Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
    _user = null;
    _username = null;
    notifyListeners();
   }

   Future<void> updatePersonalInfo(String username , String country , int age)async{
    final user = _auth.currentUser;
    if(user == null) return;
    isLoading = true;
    notifyListeners();
    try{
      await _firestore.collection('users').doc(user.uid).update({
        'username' : username,
        'country' : country,
        'age' : age
      });
      _username = username;
      _country = country;
      _age = age;

    }catch(e){
      debugPrint("Error in Updating Personal INfo $e");
    }finally{
      isLoading= false;
      notifyListeners();
    }
   }

}