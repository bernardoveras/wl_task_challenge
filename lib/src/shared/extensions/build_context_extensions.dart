import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
