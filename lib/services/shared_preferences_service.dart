import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();

  void remove(String key) async {
    final authData = await SharedPreferences.getInstance();
    if (authData.containsKey(key)) authData.remove(key);
  }

  saveTID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }

  readTID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Tid');
  }

  saveUser(String data) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('user', data);
  }

  readUser() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('user');
  }

  void saveProfileData(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', profile);
  }

  readProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile');
  }

  savePhoneNumber(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', profile);
  }

  readPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  saveLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }

  Future<String> readLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale');
  }

  saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('code', code);
  }

  Future<String> readCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('code');
  }

  saveFCMState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('fcmState', value);
  }

  Future<bool> readFCMState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('fcmState');
  }

  saveNewsState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('newsState', value);
  }

  Future<bool> readNewsState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('newsState')) return prefs.getBool('newsState');
    return true;
  }

  saveIOSCredentials(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('IOS', value);
  }

  Future<String> readIOSCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('IOS');
  }
}
