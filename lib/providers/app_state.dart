import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  Color _logoBgColor = Colors.white;

  Color get logoBgColor => _logoBgColor;

  void setLogoBgColor(Color color) {
    _logoBgColor = color;
    notifyListeners();
  }
}
