import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Themeprovider extends ChangeNotifier {
    bool _isDarkMode=false;
      bool get isDarkMode => _isDarkMode;
      void ChangeTheme(bool isOn){
_isDarkMode=isOn;
notifyListeners();
      }
      ThemeMode get currentTheme=> isDarkMode ? ThemeMode.dark : ThemeMode.light;

}
