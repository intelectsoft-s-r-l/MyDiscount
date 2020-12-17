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

  saveUser(String data) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('user', data);
  }

  readUser() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('user');
  }

  saveProfileData(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', profile);
  }

  readProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile');
  }

  saveFormProfileData(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('formProfile', profile);
  }

  readFormProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('formProfile');
  }

  /* saveNewsId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id.toString());
  }

 Future<String> readNewsId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  } */
}
