import 'package:flutter/material.dart';

class RiverpodModel extends ChangeNotifier {
  int counter;
  RiverpodModel({required this.counter});

  void addCounter() {
    counter++;
    notifyListeners();
  }

  void decCounter() {
    counter--;
    notifyListeners();
  }
}
