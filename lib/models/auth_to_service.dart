import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/SharedPref.dart';

class AuthServ {
  SharedPref sPref = SharedPref();

  removeSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userID')) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> attemptSignIn() async {
    // DataConnectionStatus status = await internetConection();
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

    final _bodyData = json.encode(
      {
        "DisplayName": _displayName,
        "Email": _email,
        "ID": _userID,
        //"PhotoUrl": photoUrl,
        "RegisterMode": 1,
        "access_token": _accessToken,
      },
    );

    const url = 'http://api.efactura.md:8585/AppCardService/json/GetTID';

    final response = await http.post(
      url,
      headers: headers,
      body: _bodyData,
    );
    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      sPref.saveTID(resp['TID']);
      return true;
    } else {
      return false;
    }
  }

  setTID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }
}

internetConection() async {
  // print("The statement 'this machine is connected to the Internet' is: ");
  // print(await DataConnectionChecker().hasConnection);

  // print("Current status: ${await DataConnectionChecker().connectionStatus}");

  // print("Last results: ${DataConnectionChecker().lastTryResults}");

  var listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        break;
    }
  });
  listener.cancel();
  await Future.delayed(Duration(seconds: 0));
  return await DataConnectionChecker().connectionStatus;
}
