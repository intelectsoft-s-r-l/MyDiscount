import 'dart:convert';

import 'package:MyDiscount/domain/entities/user_model.dart';
import 'package:MyDiscount/services/auth_service.dart';
import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthorizationProvider with ChangeNotifier {
  final NetworkConnectionImpl internet;
  final AuthService data;
  final SharedPref _pref;

  AuthorizationProvider(this.internet, this.data, this._pref);

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

  void logOut() {
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
    final _usermap = json.decode(await _pref.readUser() as String);
    final _expireDat = DateTime.parse(_usermap['expireDate'] as String);
    if (_expireDat.isBefore(DateTime.now())) {
      return false;
    }
    _id = _usermap['ID'] as String;
    _token = _usermap['access_token'] as String;
    _expireDate = _expireDat;
    notifyListeners();
    return true;
  }

  void _authorize(
    future,
  ) async {
    _user = await future as User;
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
