import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/widgets/credentials.dart';
import '../widgets/widgets/user.dart';

SharedPref sPref = SharedPref();

class QrService with ChangeNotifier {
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };

  Future<String> attemptSignIn() async {
    try {
      String serviceName = await getServiceName();
      print(serviceName);
      final _bodyData = await UserCredentials().getBodyData();
      final url = '$serviceName/json/GetTID';
      final response = await http
          .post(url, headers: _headers, body: _bodyData)
          .timeout(Duration(seconds: 10));
      var decodedResponse = json.decode(response.body);
      //print(response.statusCode);
      if (decodedResponse['ErrorCode'] == 0) {
        sPref.saveTID(decodedResponse['TID']);
        return decodedResponse['TID'];
      } else {
        if (decodedResponse['ErrorCode'] == 103) {
          final prefs = await SharedPreferences.getInstance();
          prefs.clear();
          AuthService().signOut();
          authController.add(false);
        }
        return '';
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      return '';
    }
  }

//https://api.edi.md/ISMobileDiscountService/json/GetCompany?ID={ID}
  Future<dynamic> getCompanyList() async {
    String id = await UserCredentials().getUserId();
    // print(serviceName);
    try {
      final status = await InternetConnection().verifyInternetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          String serviceName = await getServiceName();
          final url = "$serviceName/json/GetCompany?ID=$id";
          final response = await http
              .get(url, headers: _headers)
              .timeout(Duration(seconds: 3));
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
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}
