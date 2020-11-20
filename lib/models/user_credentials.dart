import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'user_model.dart';
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
    var map = {
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
    final _prefs = await sPrefs.instance;
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
    final _prefs = await sPrefs.instance;
    if (_prefs.containsKey('Tid')) {
      Map<String, dynamic> userData = await _returnCredentialsAsMap();
      String id = userData['ID'];
      return id;
    } else {
      return '';
    }
  }

  Future<Map<String, dynamic>> _returnCredentialsAsMap() async {
    String savedCredential = await sPrefs.readCredentials();
    Map<String,dynamic> credential = json.decode(savedCredential) as Map<String,dynamic>;
    return Future.value(credential);
  }

  Future<Map<String, dynamic>> _returnProfileDataAsMap() async {
    String savedFormData = await sPrefs.readFormProfileData();

    return savedFormData != null
        ? json.decode(savedFormData)
        : {'birthDay': '', 'gender': '', 'phoneNumber': ''};
  }

  Future<Map<String, dynamic>> getUserProfileData() async {
    Map<String, dynamic> credentialMap = await _returnCredentialsAsMap();

    Map<String, dynamic> profileMap = await _returnProfileDataAsMap();

    var profile = _credentialsToProfileMap(
      displayName: credentialMap['DisplayName'],
      email: credentialMap['Email'],
      birthDay: profileMap['birthDay'],
      gender: profileMap['gender'],
      phoneNumber: profileMap['phoneNumber'],
    );
    sPrefs.saveProfileData(json.encode(profile));
    return Future.value(profile);
  }

  Map<String, dynamic> _credentialsToProfileMap({
    @required String displayName,
    @required String email,
    @required String birthDay,
    @required String gender,
    @required String phoneNumber,
  }) {
    List<String> data = _splitTheStrings(displayName);
    return {
      'firstName': data[0],
      'lastName': data[1],
      'email': email,
      'birthDay': birthDay,
      'gender': gender,
      'phoneNumber': phoneNumber,
    };
  }

  List<String> _splitTheStrings(String displayName) {
    return displayName.split(" ").map((e) => e.toString()).toList();
  }

  void saveFormProfileInfo(
      {String birthDay, String gender, String phoneNumber}) {
    Map<String, String> map = {
      'birthDay': birthDay,
      'gender': gender,
      'phoneNumber': phoneNumber,
    };
    sPrefs.saveFormProfileData(json.encode(map));
  }
}
