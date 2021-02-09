import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../core/constants/credentials.dart';
import '../core/failure.dart';
import '../services/shared_preferences_service.dart';
import '../services/qr_service.dart';
import '../services/remote_config_service.dart';

@injectable
class PhoneVerification {
  final SharedPref prefs;
  final QrService _qrService;

  PhoneVerification(this.prefs, this._qrService);

  Future<void> getVerificationCodeFromServer(String phoneNumber) async {
    /*  try {
      String serviceName = await getServiceNameFromRemoteConfig();
      final url = '$serviceName/json/ValidatePhone?Phone=$phoneNumber';
      final response = await http.get(url, headers: Credentials().header);
      if (response.statusCode == 200) {
        final codeMap = json.decode(response.body);
        if (codeMap['errorCode'] != 0) {
          prefs.saveCode(codeMap['CODE']);
        } else {
          throw NoInternetConection();
        }
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      throw Exception(e);
    } */
  }

  Future<bool> smsCodeVerification(VerificationCode code) async {
    try {
      final codeFromServer = await prefs.readCode();
      if (code == VerificationCode(codeFromServer)) {
        _qrService.getTID(true);
        prefs.remove('code');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class VerificationCode {
  final String code;

  const VerificationCode(this.code);

  int get lenght => code.length;
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VerificationCode && code == other.code;
  }

  @override
  int get hashCode => code.hashCode;
}
