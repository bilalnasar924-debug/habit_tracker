import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuoteProvider extends ChangeNotifier{
  String _quote = "";
  String _author = "";
  bool _isLoading = false;

  String get quote => _quote;
  String get author => _author;
  bool get isLoading => _isLoading;

  Future<void> fetchQuote() async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as List;
        _quote = data[0]['q'];
        _author = data[0]['a'];
      }
    }catch(e){
      debugPrint('Error in Fetching qute $e');
      _quote = 'Stay consistent with your habits.';
      _author = 'Habit Tracker';
    }finally{
      _isLoading  = false;
      notifyListeners();
    }
  }


}