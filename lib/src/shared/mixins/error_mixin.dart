import 'package:flutter/material.dart';

mixin ErrorMixin on ChangeNotifier {
  String? error;
  void setError(String? value) {
    error = value;
    notifyListeners();
  }
}
