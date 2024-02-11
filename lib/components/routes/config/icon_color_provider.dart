import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}