import 'dart:async';
import 'dart:convert';


import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/credentials.dart';
import '../widgets/user_credentials.dart';

class QrService {
  SharedPref sPref = SharedPref();
  final NetworkConnectionImpl status = NetworkConnectionImpl();
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };

  Future<String> attemptSignIn() async {
    try {
      String serviceName = await getServiceNameFromRemoteConfig();

      print(serviceName);

      final _bodyData = await UserCredentials().getRequestBodyData();

      final url = '$serviceName/json/GetTID';

      final response = await http.post(url, headers: _headers, body: _bodyData);
      //.timeout(Duration(seconds: 10));

      var decodedResponse = json.decode(response.body);

      //print(response.statusCode);
      if (decodedResponse['ErrorCode'] == 0) {
        sPref.saveTID(decodedResponse['TID']);

        return decodedResponse['TID'];
      } else {
        if (decodedResponse['ErrorCode'] == 103) {
          final prefs = await sPref.instance;

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
    String id = await UserCredentials().getUserIdFromLocalStore();
    // print(serviceName);
    try {
      if (await status.isConnected) {
        String serviceName = await getServiceNameFromRemoteConfig();
        final url = "$serviceName/json/GetCompany?ID=$id";
        final response = await http
            .get(url, headers: _headers)
            .timeout(Duration(seconds: 3));
        if (response.statusCode == 200) {
          final Map<String,dynamic> companiesToMap =
              json.decode(response.body);
          final List listOfCompanies = companiesToMap['Companies'];
          return listOfCompanies;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}
