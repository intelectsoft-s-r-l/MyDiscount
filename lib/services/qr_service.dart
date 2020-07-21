import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences_service.dart';

class QrService extends ChangeNotifier {
  SharedPref sPref = SharedPref();
  removeSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('credentials')) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> attemptSignIn() async {
    const String credentials = "appuser:frj936epae293e9c6epae29";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    Map<String, String> _headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ' + encoded,
    };
    SharedPref sPrefs = SharedPref();

    final _bodyData = await sPrefs.credential();

    const url = 'http://api.efactura.md:8585/AppCardService/json/GetTID';

    try {
      final response = await http
          .post(
            url,
            headers: _headers,
            body: _bodyData,
          )
          .timeout(Duration(seconds: 5));

      print(response.body);
      if (response.statusCode == 200) {
        final resp = json.decode(response.body);
        sPref.saveTID(resp['TID']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  setTID(String id) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('Tid', id);
  }
}
