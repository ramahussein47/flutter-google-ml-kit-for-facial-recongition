import 'package:flutter/material.dart';

class Passwordviewer with ChangeNotifier {
  bool _isvisible=false;
 bool get isvisible=> _isvisible;
 void toggleVisibility(){
_isvisible!=_isvisible;
notifyListeners();
 }

}
