import 'package:flutter/material.dart';

import '../services/shared_preferences_service.dart';

class PhoneNumber with ChangeNotifier {
  SharedPref _sPrefs = SharedPref();

  String _phone = '';

  bool _editing = false;

  bool get editing => _editing;

  String get phone => _phone;

  set editing(value) {
    _editing = value;
    notifyListeners();
  }

  set phone(value) {
    _phone = value;
    _savePhone();
    notifyListeners();
  }

  PhoneNumber() {
    getUserPhone();

    notifyListeners();
  }
  _savePhone() {
    _sPrefs.saveFormProfileData(_phone);
  }

  getUserPhone() async {
    final data = await _sPrefs.instance;
    if (data.containsKey('formProfile')) {
      String savedFormData = await _sPrefs.readFormProfileData();
      _phone = savedFormData;
      notifyListeners();
    }
  }
}