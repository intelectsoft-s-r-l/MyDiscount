import 'dart:convert';

import 'user_model.dart';
import 'profile_model.dart';
import '../services/shared_preferences_service.dart';

class UserCredentials {
  SharedPref sPrefs = SharedPref();

  void saveUserRegistrationDatatoMap(User user) {
    sPrefs.saveUser(json.encode(user.toJson()));
  }

  void saveProfileRegistrationDataToMap(Profile profile) {
    sPrefs.saveProfileData(json.encode(profile.toJson()));
  }

  Future<Profile> _returnRegistrationProfileDataAsMap() async {
    Map<String, dynamic> profile =
        json.decode(await sPrefs.readProfileData()) as Map<String, dynamic>;
    return Future.value(Profile.fromJson(profile));
  }

  Future<Profile> _returnFormProfileDataAsMap() async {
    final data = await sPrefs.instance;
    if (data.containsKey('formProfile')) {
      String savedFormData = await sPrefs.readFormProfileData();

      return Profile.fromJson(json.decode(savedFormData));
    } else {
      return Profile(birthDay: '', gender: '', phone: '');
    }
  }

  Future<Map<String, dynamic>> getUserProfileData() async {
    Profile profile = await _returnRegistrationProfileDataAsMap();

    Profile profileMap = await _returnFormProfileDataAsMap();

    sPrefs.saveProfileData(
      json.encode(
        Profile(
          firstName: profile.firstName??'',
          lastName: profile.lastName??'',
          birthDay: profileMap.birthDay??'',
          gender: profileMap.gender??'',
          phone: profileMap.phone??'',
          email: profile.email??'',
          photoUrl: profile.photoUrl??'',
          registerMode: profile.registerMode??'',
          pushToken: profile.pushToken??'',
        ),
      ),
    );
    return Future.value(profile.toJson());
  }

  List<String> splitTheStrings(String displayName) {
    return displayName.split(" ").map((e) => e.toString()).toList();
  }

  void saveFormProfileInfo(Profile profile) {
    sPrefs.saveFormProfileData(json.encode(profile.toJson()));
  }

  Future<String> getRequestBodyData() async {
    final _prefs = await sPrefs.instance;
    User user = await getRegistrationUserData();
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
      User user = await getRegistrationUserData();
      return user.id;
    } else {
      return '';
    }
  }

  Future<User> getRegistrationUserData() async {
    return Future.value(
      User.fromJson(
        json.decode(await sPrefs.readUser()),
      ),
    );
  }
}
