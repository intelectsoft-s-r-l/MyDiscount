import 'dart:async';
import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../Screens/first_screen.dart';
import '../widgets/credentials.dart';
import '../services/remote_config_service.dart';
import '../services/auth_service.dart';
import '../services/internet_connection_service.dart';
import '../services/shared_preferences_service.dart';

SharedPref sPref = SharedPref();

class QrService  {
  
  AuthService authService = AuthService();
  InternetConnection _internetConnection = InternetConnection();

  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };

  removeSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<AuthState> tryAutoLogin() async {
    AuthState state;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('credentials')) {
      state = AuthState.authorized;
      return state;
    } else {
      state = AuthState.unauthorized;
      return state;
    }
  }

  Future<Map<String, dynamic>> attemptSignIn() async {
    String serviceName = await getServiceName();
    print(serviceName);
    final _bodyData = await getBodyData();

    final url = '$serviceName/json/GetTID';

    try {
      final response = await http
          .post(
            url,
            headers: _headers,
            body: _bodyData,
          )
          .timeout(Duration(seconds: 5));
      var decodedResponse = json.decode(response.body);
     // print(response.body);
      if (decodedResponse['ErrorCode'] == 0) {
        sPref.saveTID(decodedResponse['TID']);
        return decodedResponse;
      } else {
        if (decodedResponse['ErrorCode'] == 103) {
          final prefs = await SharedPreferences.getInstance();
          prefs.clear();
          authService.signOut();
          main();
        }
        return {};
      }
    } catch (e) {
      return {};
    }
  }

//http://api.edi.md/ISMobileDiscountService/json/GetCompany?ID={ID}
  Future<dynamic> getCompanyList() async {
    String serviceName = await getServiceName();
    String id = await getUserId();
    print(serviceName);

    final status = await _internetConnection.verifyInternetConection();
    switch (status) {
      case DataConnectionStatus.connected:
        final url = "$serviceName/json/GetCompany?ID=$id";
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
