import 'dart:convert';

import 'package:MyDiscount/widgets/crdentials.dart';
import 'package:flutter/material.dart';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../services/internet_connection_service.dart';
import '../services/shared_preferences_service.dart';

SharedPref sPref = SharedPref();

class QrService extends ChangeNotifier {
  InternetConnection _internetConnection = InternetConnection();

  int count = 0;

  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };

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
    final _bodyData = await getBodyData();
    //print(_bodyData);
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
        final decodedResponse = json.decode(response.body);
        sPref.saveTID(decodedResponse['TID']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getCompanyList() async {
    final status = await _internetConnection.verifyInternetConection();
    switch (status) {
      case DataConnectionStatus.connected:
        const url = "https://api.edi.md/AppCardService/json/GetCompany";
        final response = await http.get(url, headers: _headers).timeout(
              Duration(seconds: 3),
            );
        if (response.statusCode == 200) {
          final companiesMap =
              json.decode(response.body) as Map<String, dynamic>;
          var listCompanies = companiesMap['Companies'] as List;
          return listCompanies;
        } else {
          return false;
        }
        break;
      case DataConnectionStatus.disconnected:
        return false;
    }
  }
}
