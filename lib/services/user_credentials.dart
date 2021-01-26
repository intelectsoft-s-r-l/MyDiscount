import 'dart:convert';


import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/domain/entities/user_model.dart';

import '../services/shared_preferences_service.dart';

class UserCredentials {
  SharedPref sPrefs = SharedPref();

  void saveUserRegistrationDatatoMap(User user) {
    try {
      sPrefs.saveUser(json.encode(user.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  void saveProfileRegistrationDataToMap(Profile profile) async {
    try {
      sPrefs.saveProfileData(json.encode(profile.toJson()));
      final prefs = await sPrefs.instance;
      if (profile.registerMode == 3 && !prefs.containsKey('IOS'))
        sPrefs.saveIOSCredentials(json.encode(profile.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<Profile> getUserProfileData() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  List<String> splitTheStrings(String displayName) {
    try {
      if (displayName.contains(' ')) {
        return displayName.split(" ").map((e) => e.toString()).toList();
      } else {
        final list = displayName.split(" ").map((e) => e.toString()).toList();
        list.add('');
        return list;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getRequestBodyData(bool isPhoneVerification) async {
    try {
      final _prefs = await sPrefs.instance;
      User user = await _getRegistrationUserData();
      Profile profile = await _returnRegistrationProfileDataAsMap();
      String phone = await _readFormPhoneNumber();
      if (isPhoneVerification) {
        return json.encode({
          "DisplayName": "${profile.firstName}" + ' ' + "${profile.lastName}",
          "Email": profile.email,
          "ID": user.id,
          "PhotoUrl": profile.photoUrl,
          "PushToken": profile.pushToken,
          "RegisterMode": profile.registerMode,
          "access_token": user.accessToken,
          "phone": phone,
        });
      }
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
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUserIdFromLocalStore() async {
    try {
      final _prefs = await sPrefs.instance;
      if (_prefs.containsKey('Tid')) {
        User user = await _getRegistrationUserData();
        return user.id;
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> _getRegistrationUserData() async {
    try {
      return Future.value(
        User.fromJson(
          json.decode(
            await sPrefs.readUser(),
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _readFormPhoneNumber() async {
    try {
      final String phone = await sPrefs.readPhoneNumber();
      if (phone != null) return phone;
      return '{}';
    } catch (e) {
      rethrow;
    }
  }

  Future<Profile> _returnRegistrationProfileDataAsMap() async {
    try {
      Map<String, dynamic> profile =
          json.decode(await sPrefs.readProfileData()) as Map<String, dynamic>;
      if (profile['registerMode'] == 3) {
        Map<String, dynamic> iOSProfile = json
            .decode(await sPrefs.readIOSCredentials()) as Map<String, dynamic>;
        return Future.value(Profile.fromJson(iOSProfile));
      }
      return Future.value(Profile.fromJson(profile));
    } catch (e) {
      rethrow;
    }
  }
}
