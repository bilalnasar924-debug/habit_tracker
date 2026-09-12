import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HabitProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String,dynamic>> _habits = [];
  List<Map<String,dynamic>> get habits => _habits;

  String _seletedColor = "Amber";

  String get selectedColor => _seletedColor;

  final Map<String ,Color> colors = {
    'Red' : Colors.red,
    'Pink' : Colors.pink,
    'Green' : Colors.green,
    'Amber' : Colors.amber,
    'Lime':Colors.lime,
    'Blue' : Colors.blue,
    'Grey':Colors.grey
  };

  void changeColor(String color){
    _seletedColor = color;
    notifyListeners();
  }


  Future<void> fetchHabits() async{
    final user = _auth.currentUser;
    if(user == null){
      return;
    }
    try{
      final snapshot = await _firestore.collection('users').doc(user.uid).collection('habits').orderBy('createdAt').get();
      _habits = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id' : doc.id,
          'name' : data['name'],
          'color':data['color'],
          'isCompleted' : data['isCompleted'] ?? false
        };
      }).toList();
      notifyListeners();
    } catch (e){
      debugPrint("Error in Fetching Habits $e");
    }
  }

  Future<void> addHabit(String habitName) async {
    final user = _auth.currentUser;
    if(user == null){
      return;
    }

    if(habitName.trim().isEmpty){
      return;
    }

    _isLoading = true;
    notifyListeners();
    try{
      await _firestore.collection('users').doc(user.uid).collection('habits').add({
        'name':habitName.trim(),
        'color' : _seletedColor,
        'isCompleted' : false,
        'createdAt' : FieldValue.serverTimestamp()
      });
      await fetchHabits();
    }catch(e){
      debugPrint('Error adding Habit : $e');
    }finally{
      _isLoading= false;
      notifyListeners();
    }
  }


  Future<void> deleteHabit(String habitId) async{
    final user = _auth.currentUser;
    if(user == null){
      return;
    }

    try{
      await _firestore.collection('users').doc(user.uid).collection('habits').doc(habitId).delete();
      _habits.removeWhere((habit) => habit['id'] == habitId);
      notifyListeners();

    }catch(e) {
      debugPrint("Error in Deleting Habit $e");
    }
  }

  Future<void> toggleHabit(String habitId , bool iscompleted) async{
    final user = _auth.currentUser;
    if(user == null){
      return;
    }
    try{
      await _firestore.collection('users').doc(user.uid).collection('habits').doc(habitId).update({'isCompleted' : iscompleted});
      final index = _habits.indexWhere((habit)=> habit['id'] == habitId);
      if(index != -1 ){
        _habits[index]['isCompleted'] = iscompleted;
        notifyListeners();
      }
    }catch(e){
       debugPrint('Error updating habit: $e');
    }

  }

}