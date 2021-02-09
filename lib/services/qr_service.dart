import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/services/user_credentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../core/constants/credentials.dart';
import '../core/formater.dart';

import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';

@injectable
class QrService {
  final SharedPref sPref;
  final Credentials credentials;
  final Formater formater;
  final NetworkConnectionImpl status;

  QrService(this.sPref, this.credentials, this.formater, this.status);

  Future<Map<String, dynamic>> getTID(bool isPhoneVerification) async {
    try {
      String serviceName = await getServiceNameFromRemoteConfig();

      final _bodyData = await UserCredentials().getRequestBodyData(isPhoneVerification);

      debugPrint(_bodyData);

      final url = '$serviceName/json/GetTID';

      final response = await http.post(url, headers: credentials.header, body: _bodyData).timeout(Duration(seconds: 3));

      Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        sPref.saveTID(response.body);
      }
      return decodedResponse;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      return {};
    }
  }
}
