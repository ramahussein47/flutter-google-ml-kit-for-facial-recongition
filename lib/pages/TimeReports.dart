import 'package:flutter/material.dart';

class TimePeriodProvider with ChangeNotifier {
  String _selectedPeriod = 'Day';

  String get selectedPeriod => _selectedPeriod;

  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }
}
