import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String name;
  final String color;
  bool isCompleted;
  final DateTime createdAt;

  HabitModel({required this.id , required this.name , required this.color , required this.isCompleted, required this.createdAt});

  Map<String , dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'color' : color,
      'isCompleted' : isCompleted,
      'createdAt' : Timestamp.fromDate(createdAt)
    };
  }


  factory HabitModel.fromMap(Map<String,dynamic> map){
    return HabitModel(id: map['id'], name: map['name'], color: map['color'], isCompleted: map['isCompleted'], createdAt:( map['createdAt']  as Timestamp).toDate());
  }
  
}