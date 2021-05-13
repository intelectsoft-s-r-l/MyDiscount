import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();

  void remove() async {
    final authData = await SharedPreferences.getInstance();
    await authData.clear();
  }

  /*  void savePhoneNumber(String profile) async {
    final prefs = await SharedPreferences.getInstance();
   await prefs.setString('phone', profile);
  }

  Future<String> readPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  } */

  void saveLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }

  Future<String?> readLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale');
  }
/* 
 void saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
   await prefs.setString('code', code);
  }

  Future<String> readCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('code');
  } */

  /* void saveFCMState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fcmState', value);
  }

  Future<bool> readFCMState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('fcmState') ?? false;
  }

  void saveNewsState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('newsState', value);
  }

  Future<bool> readNewsState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('newsState')) {
      return prefs.getBool('newsState') ?? true;
    }

    return true;
  } */
}
