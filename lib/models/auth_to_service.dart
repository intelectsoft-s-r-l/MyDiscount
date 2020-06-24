import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/SharedPref.dart';

class AuthServ {
  SharedPref sPref = SharedPref();
  bool _isLogedIn = false;

  bool get state {
    return _isLogedIn = isLoggedIn;
  }

  bool get isLoggedIn {
    return _isLogedIn;
  }

  Future<bool> attemptSignIn() async {
    String credentials = "appuser:frj936epae293e9c6epae29";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ' + encoded,
    };
    SharedPref sPrefs = SharedPref();
    final _accessToken = await sPrefs.getAccessToken();
    final _userID = await sPrefs.getID();
    final _displayName = await sPrefs.getDisplayName();
    final _email = await sPrefs.getEmail();
    //final photoUrl = await sPrefs.getPhotoUrl();

    var _bodyData = json.encode(
      {
        "DisplayName": _displayName,
        "Email": _email,
        "ID": _userID,
        //"PhotoUrl": photoUrl,
        "RegisterMode": 1,
        "access_token": _accessToken,
      },
    );
    print(_bodyData);
    const url = 'http://api.efactura.md:8585/AppCardService/json/GetTID';

    if (_bodyData != null) {
      try {
        final response = await http.post(
          url,
          headers: headers,
          body: _bodyData,
        );
        _isLogedIn = true;
        var resp = json.decode(response.body);
        sPref.saveTID(resp['TID']);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      _isLogedIn = false;
    }

    return true;
  }

  setTID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }

  Future<bool> tryAutoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userID')) {
      return true;
    } else {
      return false;
    }
  }
}
