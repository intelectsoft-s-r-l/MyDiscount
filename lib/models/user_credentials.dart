import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'user_model.dart';
import 'profile_model.dart';

import '../services/shared_preferences_service.dart';

class UserCredentials{
  SharedPref sPrefs = SharedPref();

  void saveUserRegistrationDatatoMap(User user) {
    user.session = DateTime.now().add(Duration(minutes: 2));
    sPrefs.saveUser(json.encode(user.toJson()));
  }

  void saveProfileRegistrationDataToMap(Profile profile) {
    sPrefs.saveProfileData(json.encode(profile.toJson()));
  }

  Future<Profile> getUserProfileData() async {
    Profile profile = await _returnRegistrationProfileDataAsMap();

    sPrefs.saveProfileData(
      json.encode(
        Profile(
          firstName: profile.firstName ?? '',
          lastName: profile.lastName ?? '',
          email: profile.email ?? '',
          photoUrl: profile.photoUrl,
          registerMode: profile.registerMode,
          pushToken: profile.pushToken ?? '',
        ),
      ),
    );
    return Future.value(profile);
  }

  List<String> splitTheStrings(String displayName) {
    return displayName.split(" ").map((e) => e.toString()).toList();
  }

  Future<String> getRequestBodyData() async {
    final _prefs = await sPrefs.instance;
    User user = await _getRegistrationUserData();
    print(user.session);
    Profile profile = await _returnRegistrationProfileDataAsMap();
    if (_prefs.containsKey('Tid')) {
      final minUserData = json.encode(
        {"ID": user.id, "RegisterMode": profile.registerMode},
      );
      return minUserData;
    } else {
      return json.encode({
        "DisplayName": "${profile.firstName}" + ' ' + "${profile.lastName}",
        "Email": profile.email,
        "ID": user.id,
        "PhotoUrl": profile.photoUrl,
        "PushToken": profile.pushToken,
        "RegisterMode": profile.registerMode,
        "access_token": user.accessToken,
      });
    }
  }

  Future<String> getUserIdFromLocalStore() async {
    final _prefs = await sPrefs.instance;
    if (_prefs.containsKey('Tid')) {
      User user = await _getRegistrationUserData();
      return user.id;
    } else {
      return '';
    }
  }

  Future<User> _getRegistrationUserData() async {
    return Future.value(
      User.fromJson(
        json.decode(
          await sPrefs.readUser(),
        ),
      ),
    );
  }

  Future<Profile> _returnRegistrationProfileDataAsMap() async {
    Map<String, dynamic> profile =
        json.decode(await sPrefs.readProfileData()) as Map<String, dynamic>;
    return Future.value(Profile.fromJson(profile));
  }
}


