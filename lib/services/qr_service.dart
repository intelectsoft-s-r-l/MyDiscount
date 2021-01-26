import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/services/user_credentials.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;

import '../core/constants/credentials.dart';
import '../core/formater.dart';

import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';

class QrService with ChangeNotifier {
  SharedPref sPref = SharedPref();
  Credentials credentials = Credentials();
  Formater formater = Formater();
  NetworkConnectionImpl status = NetworkConnectionImpl();
  double _progress = 1;
  int _countTID = 0;
  String _tid = '';
  bool _showImage = false;
  bool _showNoInternet = false;
  get progress => _progress;
  get tid => _tid;
  get showImage => _showImage;
  get showNoInet => _showNoInternet;

  Future<Map<String, dynamic>> getTID(bool isPhoneVerification,
      [context]) async {
    try {
      if (await status.isConnected) {
        _countTID++;
        print(_countTID);
        double _counter = 7;
        final response = await returnTId(isPhoneVerification);
        

        debugPrint('Tid: $_tid');
        // ignore: unused_local_variable
        if (!isPhoneVerification) {
          Timer _timer = Timer.periodic(Duration(seconds: 1), (_timer) async {
            if (_counter > 0) {
              _counter--;
              _progress -= 0.1428;
              debugPrint('$_counter');
            } else if (_counter == 0 && _countTID < 3) {
              _progress = 1;
              _timer?.cancel();
              getTID(false);
            } else {
              _timer?.cancel();
            }
          });
          if (_countTID == 3) {}
        } else {}
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      return {};
    }
  }

  Future<String> returnTId(
    bool isPhoneVerification,
  ) async {
    String serviceName = await getServiceNameFromRemoteConfig();

    final _bodyData =
        await UserCredentials().getRequestBodyData(isPhoneVerification);

    debugPrint(_bodyData);

    final url = '$serviceName/json/GetTID';
    final response = await http
        .post(url, headers: credentials.header, body: _bodyData)
        .timeout(Duration(seconds: 10));
    final map = json.decode(response.body);
    _tid = map['TID'];
    notifyListeners();
    return _tid;
  }
}
