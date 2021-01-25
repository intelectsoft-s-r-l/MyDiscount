import 'dart:convert';

import 'package:MyDiscount/domain/entities/user_model.dart';
import 'package:MyDiscount/services/auth_service.dart';
import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class AuthorizationProvider with ChangeNotifier {
  final NetworkConnectionImpl internet = NetworkConnectionImpl();
  final AuthService data = AuthService();
  SharedPref _pref = SharedPref();
  User _user;
  String _id;
  String _token;
  DateTime _expireDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null && _id != null && _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  logOut() {
    _id = null;
    _token = null;
    _expireDate = null;
    data.signOut();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final _prefs = await _pref.instance;
    if (!_prefs.containsKey('user')) {
      return false;
    }
    final _usermap = json.decode(await _pref.readUser());
    final _expireDat = DateTime.parse(_usermap['expireDate']);
    if (_expireDat.isBefore(DateTime.now())) {
      return false;
    }
    _id = _usermap['ID'];
    _token = _usermap['access_token'];
    _expireDate = _expireDat;
    notifyListeners();
    return true;
  }

  void _authorize(
    future,
  ) async {
    _user = await future;
    _id = _user.id;
    _token = _user.accessToken;
    _expireDate = DateTime.parse(_user.expireDate);
    notifyListeners();
  }

  void getAuthorizationFB() async {
    if (await internet.isConnected) {
      _authorize(data.authWithFacebook());
    }
  }

  void getAuthorizationGoogle() async {
    if (await internet.isConnected) {
      _authorize(
        data.logwithG(),
      );
    }
  }

  void getAuthorizationApple() async {
    if (await internet.isConnected) {
      _authorize(
        data.signInWithApple(),
      );
    }
  }
}
