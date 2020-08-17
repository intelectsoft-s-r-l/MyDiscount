import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences_service.dart';

class QrService extends ChangeNotifier {
  int count = 0;
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

  static const String credentials = "appuser:frj936epae293e9c6epae29";
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static String encoded = stringToBase64.encode(credentials);
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + encoded,
  };

  Future<bool> attemptSignIn() async {
    SharedPref sPrefs = SharedPref();
    getBodyData() async {
      var prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('Tid')) {
        var shared = await sPrefs.credential();
        var dat = json.decode(shared);
        final request =
            json.encode({"ID": dat['ID'], "RegisterMode": dat['RegisterMode']});
        return request;
      } else {
        var response = await sPrefs.credential();
        return response;
      }
    }

    final _bodyData = await getBodyData();
    print(_bodyData);
    const url = 'https://api.edi.md/AppCardService/json/GetTID';

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

  

  Future<List> getCompanyList() async {
    const url = "https://api.edi.md/AppCardService/json/GetCompany";
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final listCompanies = json.decode(response.body) as Map<String, dynamic>;
      print(response.body);
      var companies = listCompanies['Companies'] as List;
      return companies;
    } else {
      return ["1"];
    }
  }
}
