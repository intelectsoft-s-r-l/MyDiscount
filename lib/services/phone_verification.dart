import 'dart:convert';

import '../constants/credentials.dart';
import 'shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class PhoneVerification {
  SharedPref prefs = SharedPref();

  Future<void> getVerificationCodeFromServer(String phoneNumber) async {
    final url =
        'http://dev.edi.md/ISMobileDiscountService/json/ValidatePhone?Phone=$phoneNumber';
    try {
      final response = await http.get(url, headers: Credentials().header);
      if (response.statusCode == 200) {
        final codeMap = json.decode(response.body);
        prefs.saveCode(codeMap['CODE']);
      }
    } catch (e) {}
  }

  Future<bool> smsCodeVerification(VerificationCode code) async {
    final codeFromServer = await prefs.readCode();
    if (code == VerificationCode(codeFromServer)) {
      print('true');
      return true;
    }
    print(false);
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
