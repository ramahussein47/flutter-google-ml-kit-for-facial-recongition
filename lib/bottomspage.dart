import 'package:facial/Homepage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomPagesProvider with ChangeNotifier{
  int _currentIndex=0;
  int  get currentindex => _currentIndex;

    void setPage(int index){
       _currentIndex=index;
       notifyListeners();
    }


}
