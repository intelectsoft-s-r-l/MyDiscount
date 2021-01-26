import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/credentials.dart';
import '../services/shared_preferences_service.dart';
import '../services/qr_service.dart';
import '../services/remote_config_service.dart';

class PhoneVerification {
  SharedPref prefs = SharedPref();
 final  QrService _qrService =QrService();

  Future<void> getVerificationCodeFromServer(String phoneNumber) async {
     try {
      String serviceName = await getServiceNameFromRemoteConfig();
      final url = '$serviceName/json/ValidatePhone?Phone=$phoneNumber';
      final response = await http.get(url, headers: Credentials().header);
      if (response.statusCode == 200) {
        final codeMap = json.decode(response.body);
        prefs.saveCode(codeMap['CODE']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> smsCodeVerification(VerificationCode code) async {
    final codeFromServer = await prefs.readCode();
    if (code == VerificationCode(codeFromServer)) {
      _qrService.getTID(true);
      return true;
    }
    return false;
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

  int get hashCode => code.hashCode;
}
