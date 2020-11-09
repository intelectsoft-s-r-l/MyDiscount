import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/shared_preferences_service.dart';

class UserCredentials {
  SharedPref sPrefs = SharedPref();

  void userCredentialstoMap({
    @required String displayName,
    @required String email,
    @required String id,
    @required String photoUrl,
    @required String pushToken,
    @required int registerMode,
    @required String accessToken,
    //@required String authorizationCode,
  }) {
    var map= {
      "DisplayName": displayName,
      "Email": email,
      "ID": id,
      "PhotoUrl": photoUrl,
      "PushToken": pushToken,
      "RegisterMode": registerMode,
      "access_token": accessToken
    };
    saveLocalUserCredentials(UserModel.fromJson(map));
  }

  void saveLocalUserCredentials(UserModel userToCache) async {
    return sPrefs.saveCredentials(json.encode(userToCache.toJson()));
  }

  Future<String> getRequestBodyData() async {
  final _prefs =await sPrefs.instance;
    //final _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('Tid')) {
      String savedCredential = await sPrefs.readCredentials();
      Map<String, dynamic> userData = json.decode(savedCredential);
      final minUserData = json.encode(
        {"ID": userData['ID'], "RegisterMode": userData['RegisterMode']},
      );
      return minUserData;
    } else {
      var fullUserData = await sPrefs.readCredentials();
      return fullUserData;
    }
  }

  Future<String> getUserIdFromLocalStore() async {
    final _prefs =await sPrefs.instance;
    if (_prefs.containsKey('Tid')) {
      var savedCredential = await sPrefs.readCredentials();
      var userData = json.decode(savedCredential);
      var id = userData['ID'];
      return id;
    } else {
      return '';
    }
  }
}
