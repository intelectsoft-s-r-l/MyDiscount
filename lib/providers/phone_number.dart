import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/shared_preferences_service.dart';

class PhoneNumber with ChangeNotifier {
 final SharedPref _sPrefs = SharedPref();

  String _phone = '';

  bool _editing = false;

  bool get editing => _editing;

  String get phone => _phone;

  set editing(bool value) {
    _editing = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    _savePhone();
    notifyListeners();
  }

  PhoneNumber() {
    getUserPhone();
    notifyListeners();
  }

  void _savePhone() {
    _sPrefs.savePhoneNumber(json.encode(_phone));
  }

  void getUserPhone() async {
    final data = await _sPrefs.instance;
    if (data.containsKey('phone')) {
      _phone = await _sPrefs.readPhoneNumber() as String;
      notifyListeners();
    }
  }
}
