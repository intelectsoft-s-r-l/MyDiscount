import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/shared_preferences_service.dart';

class UserCredentials  {
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
    var map = {
      "DisplayName": displayName,
      "Email": email,
      "ID": id,
      "PhotoUrl": photoUrl,
      "PushToken": pushToken,
      "RegisterMode": registerMode,
      "access_token": accessToken
    };
    saveLocalUserCredentials(map);
  }

  void saveLocalUserCredentials(Map<String, dynamic> map) async {
    final String _data = json.encode(map);
    sPrefs.credentials(_data);
    //var savedCredential = await sPrefs.credential();
    //var userData = json.decode(savedCredential);
    
    //print(_tID);
  }

  

  Future<String> getBodyData() async {
    final _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('Tid')) {
      String savedCredential = await sPrefs.credential();
      Map<String, dynamic> userData = json.decode(savedCredential);
      final minUserData = json.encode(
        {"ID": userData['ID'], "RegisterMode": userData['RegisterMode']},
      );
      return minUserData;
    } else {
      var fullUserData = await sPrefs.credential();
      return fullUserData;
    }
  }

  getUserId() async {
    var _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('Tid')) {
      var savedCredential = await sPrefs.credential();
      var userData = json.decode(savedCredential);
      var id = userData['ID'];
      return id;
    } else {
      return '';
    }
  }

}
