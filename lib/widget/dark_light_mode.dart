import 'package:flutter/material.dart';
import 'package:qareeb/utils/colors.dart';

class ColorNotifier with ChangeNotifier {
  bool _isDark = false;
  set setIsDark(value) {
    _isDark = value;
    notifyListeners();
  }

  get background => _isDark ? const Color(0xff202427) : Colors.grey.shade100;
  get textColor => _isDark ? whiteColor : blackColor;
  get containerColor => _isDark ? blackColor : whiteColor;
  get borderColor =>
      _isDark ? const Color(0xff24211F) : const Color(0xffe1e6ef);
}
