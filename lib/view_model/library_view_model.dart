import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LibraryViewModel with ChangeNotifier{

  bool isLoading = false;
  set setIsLoading(bool newValue){
    isLoading = newValue;
    notifyListeners();
  }

  List bookList = [];

  Future<void> getBooks(String searchWord)async{
    isLoading = true;
    notifyListeners();
    Uri url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$searchWord');
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      bookList = jsonDecode(response.body)['items'];
      isLoading = false;
      notifyListeners();
    }
  }

}