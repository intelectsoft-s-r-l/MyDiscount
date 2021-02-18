/* import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../services/shared_preferences_service.dart';

class ProfileProvider with ChangeNotifier {
  SharedPref _prefs = SharedPref();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _photo = '';
  int _registerMode = 0;

  get firstName => _firstName;

  get lastName => _lastName;

  get email => _email;

  get photo => _photo;

  get registerMode => _registerMode;

  ProfileProvider() {
    _getProfileData();
    notifyListeners();
  }

  _getProfileData() async {
    final _profile =
        json.decode(await _prefs.readProfileData()) as Map<String, dynamic>;
    _firstName = _profile['firstName'];
    _lastName = _profile['lastName'];
    _email = _profile['email'];
    _photo = _profile['photoUrl'];
    _registerMode = _profile['registerMode'];
    notifyListeners();
  }
} */
