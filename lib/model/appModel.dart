import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {
  ThemeData _appTheme = ThemeData.light();
  get appTheme => _appTheme;
  bool _isDarkModeOn = false;
  get isDarkModeOn => _isDarkModeOn;

  setDarkMode(bool value) {
    _isDarkModeOn = value;
    if (_isDarkModeOn) {
      _appTheme = ThemeData.dark().copyWith(
        platform: _iphoneStyleOn ? TargetPlatform.iOS : TargetPlatform.android,
      );
    } else {
      _appTheme = ThemeData.light().copyWith(
        platform: _iphoneStyleOn ? TargetPlatform.iOS : TargetPlatform.android,
      );
    }

    notifyListeners();
  }

  Color _primaryColor = Colors.blue;
  get primaryColor => _primaryColor;
  String _colorName = '蓝色';
  get colorName => _colorName;
  setPrimaryColor(Color color, String colorName) {
    _appTheme = _appTheme.copyWith(
      primaryColor: color,
    );
    _primaryColor = color;
    _colorName = colorName;
    notifyListeners();
  }

  bool _iphoneStyleOn = false;
  get iphoneStyleOn => _iphoneStyleOn;
  setIPhoneStyleOn(bool value) {
    _appTheme = _appTheme.copyWith(
      platform: value ? TargetPlatform.iOS : TargetPlatform.android,
    );
    _iphoneStyleOn = value;
    notifyListeners();
  }
}
