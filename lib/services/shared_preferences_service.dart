import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  saveTID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }

  readTID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Tid');
  }

  credentials(String data) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('credentials', data);
  }

  credential() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('credentials');
  }

/*   saveRemote(var data) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('remote', data);
  }

  readRemote() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('remote');
  } */
}
