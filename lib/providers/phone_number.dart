import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/shared_preferences_service.dart';

class PhoneNumber with ChangeNotifier {
  SharedPref _sPrefs = SharedPref();

  String _phone = '';

  bool _editing = false;
  String _phoneIsoCode = '';
  Map<String, String> _map = {};

  bool get editing => _editing;

  String get phone => _phone;

  get phoneIsoCode => _phoneIsoCode;

  set editing(value) {
    _editing = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    _savePhone();
    notifyListeners();
  }

  set phoneIsoCode(String code) {
    _phoneIsoCode = code;
    _saveCode();
  }

  PhoneNumber() {
    getUserPhone();
    notifyListeners();
  }
  _saveCode() {
    _map.putIfAbsent('code', () => _phoneIsoCode);
  }

  _savePhone() {
    _map.putIfAbsent('phone', () => _phone);
    final _newphone = json.encode(_map);
    _sPrefs.savePhoneNumber(_newphone);
  }

  getUserPhone() async {
    final data = await _sPrefs.instance;
    if (data.containsKey('phone')) {
      final savedFormData =
          json.decode(await _sPrefs.readPhoneNumber()) as Map<String, dynamic>;
      _phone = savedFormData['phone'];
      _phoneIsoCode = savedFormData['code'];
      notifyListeners();
    }
  }
}
