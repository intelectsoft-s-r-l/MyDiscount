import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/SharedPref.dart';

class AuthServ {
  SharedPref sPref = SharedPref();

  Future<bool> attemptSignIn(
    String displayName,
    String email,
    String userId,
    String photoUrl,
    String accessToken,
  ) async {
    String credentials = "appuser:frj936epae293e9c6epae29";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ' + encoded,
    };
    //getuserData();
    var authData = json.encode(
      {
        "DisplayName": displayName,
        "Email": email,
        "ID": userId,
        "PhotoUrl": photoUrl,
        "RegisterMode": 1,
        "access_token": accessToken,
      },
    );

    const url = 'http://api.efactura.md:8585/AppCardService/json/GetTID';
    final response = await http.post(
      url,
      headers: headers,
      body: authData,
    );

    print(response.body);
    var resp = json.decode(response.body);

    sPref.saveTID(resp['TID']);
    

    return true;
  }

  setTID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }
getuserData() {
    AuthServ serv = AuthServ();
    /* String displayName;
    String email;
    String userId;
    String photoUrl;
    String accessToken; */
    SharedPref sPrefs = SharedPref();
    final userData = json.decode(sPrefs.getLogStatus()) as Map<String, Object>;
    /* displayName = 
    email = ;
    userId = ;
    photoUrl = ;
    accessToken = ; */
    serv.attemptSignIn(
      userData['displayName'].toString(),
      userData['email'].toString(),
      userData['photoUrl'].toString(),
      userData['userId'].toString(),
      userData['accessToken'].toString(),
    );
  
  }
  
}
