import 'package:flutter/material.dart';

class WaitingProvider extends ChangeNotifier {
  String? _comment;
  double? _loadingValue;

  String? get comment => _comment;
  double? get loadingValue => _loadingValue;

  void setComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  void setLoadingValue(double value) {
    _loadingValue = value;
    notifyListeners();
  }

  void clear() {
    _comment = _loadingValue = null;
  }
}
