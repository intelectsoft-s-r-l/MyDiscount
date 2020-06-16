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

  saveResp(userId) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('userID', userId);
  }

  getResp() async {
    final authData = await SharedPreferences.getInstance();
    authData.getString('userID');
  }
  setLogStatus(authData)async{
    final userData = await SharedPreferences.getInstance();
    userData.setString('logedIn',authData);
  }
  getLogStatus()async{
    final userData = await SharedPreferences.getInstance();
    userData.getString('logedIn');
  }
}
