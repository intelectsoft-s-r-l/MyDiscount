import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/services/user_credentials.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/scheduler.dart';
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

  Timer _timer;
  double _progress = 1;
  int _countTID = 0;
  String _tid = '';
  bool _showImage = false;
  bool _showNoInternet = false;

  AppLifecycleState _state;
  set state(value) {
    _state = value;
  }

  get progress => _progress;
  get tid => _tid;
  get showImage => _showImage;
  get showNoInet => _showNoInternet;

  set showImage(bool value) {
    _showImageF(value);
  }

  set showNoInet(bool value) {
    _showNoInetF(value);
  }

  QrService() {
    getTID(false);
  }

  void getTID(bool isPhoneVerification) async {
    /* if (_state == AppLifecycleState.resumed) { */
    try {
      if (await status.isConnected) {
        debugPrint('Tid: $_tid');
        // ignore: unused_local_variable
        if (!isPhoneVerification) {
          _countTID++;
          final response = await returnTId(isPhoneVerification);
          _tid = response;
          print(_countTID);
          double _counter = 7;
          _timer = Timer.periodic(Duration(seconds: 1), (_timer) async {
            if (_counter > 0) {
              _counter--;
              _showProgress(_progress);
              debugPrint('$_counter');
            } else if (_counter == 0 && _countTID < 3) {
              _progress = 1;
              _timer?.cancel();
              getTID(false);
            } else {
              _timer?.cancel();
              _countTID = 0;
              _progress = 1;
              _showImageF(true);
            }
          });
        } else {
          returnTId(true);
        }
      } else {
        _countTID = 0;
        _progress = 1;
        _timer?.cancel();
        _showImageF(true);
        _showNoInetF(true);
      }
      notifyListeners();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
    /*  } */
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
    final _ti = map['TID'];
    return _ti;
  }

  _showProgress(double progress) {
    progress -= 0.1428;
    _progress = progress;
    notifyListeners();
  }

  _showImageF(bool img) {
    final image = img;
    _showImage = image;
    notifyListeners();
  }

  _showNoInetF(bool img) {
    final image = img;
    _showNoInternet = image;
    notifyListeners();
  }
}
