
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  saveTID(String id) async{
    final prefs =await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }
  

  readTID() async {
    final prefs =await SharedPreferences.getInstance();
    return prefs.getString('Tid');
  }
}