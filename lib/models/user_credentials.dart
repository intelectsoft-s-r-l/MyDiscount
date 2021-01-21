import 'dart:convert';

import 'user_model.dart';
import 'profile_model.dart';

import '../services/shared_preferences_service.dart';

class UserCredentials {
  SharedPref sPrefs = SharedPref();

  void saveUserRegistrationDatatoMap(User user) {
    sPrefs.saveUser(json.encode(user.toJson()));
  }

  void saveProfileRegistrationDataToMap(Profile profile) async {
    sPrefs.saveProfileData(json.encode(profile.toJson()));
    final prefs = await sPrefs.instance;
    if (profile.registerMode == 3 && !prefs.containsKey('IOS'))
      sPrefs.saveIOSCredentials(json.encode(profile.toJson()));
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
    if (displayName.contains(' ')) {
      return displayName.split(" ").map((e) => e.toString()).toList();
    } else {
      final list = displayName.split(" ").map((e) => e.toString()).toList();
      list.add('');
      return list;
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
    } catch (e) {}
    throw Exception();
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

  Future<String> _readFormPhoneNumber() async {
    final String phone = await sPrefs.readPhoneNumber();
    if (phone != null) return phone;
    return '{}';
  }

  Future<Profile> _returnRegistrationProfileDataAsMap() async {
    Map<String, dynamic> profile =
        json.decode(await sPrefs.readProfileData()) as Map<String, dynamic>;
    if (profile['registerMode'] == 3) {
      Map<String, dynamic> iOSProfile = json
          .decode(await sPrefs.readIOSCredentials()) as Map<String, dynamic>;
      return Future.value(Profile.fromJson(iOSProfile));
    }
    return Future.value(Profile.fromJson(profile));
  }
}
