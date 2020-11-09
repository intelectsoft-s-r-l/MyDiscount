import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();

  saveTID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }

  readTID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Tid');
  }

  saveCredentials(String data) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('credentials', data);
  }

  readCredentials() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('credentials');
  }
}
