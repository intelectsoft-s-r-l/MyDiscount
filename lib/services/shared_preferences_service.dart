import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();

  void remove() async {
    final authData = await SharedPreferences.getInstance();
     authData.clear();
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
}
