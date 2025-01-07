import 'package:flutter/material.dart';

mixin LoadingMixin on ChangeNotifier {
  bool loading = true;
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool loadingMore = true;
  void setLoadingMore(bool value) {
    loadingMore = value;
    notifyListeners();
  }
}
