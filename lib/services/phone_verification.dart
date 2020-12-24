class PhoneVerification {
  Future<String> getVerificationCodeFromServer() {
    return Future.value('1234');
  }

  String getVerificationLocalCode(String code) {
    return '1234';
  }

  Future<bool> smsCodeVerification() async {
    final codeFromServer = await getVerificationCodeFromServer();
    final codefromLocal = getVerificationLocalCode(codeFromServer);
    if (codefromLocal == codeFromServer) {
      print('true');
      return true;
    }
    print(false);
    return false;
  }
}

abstract class VerificationCode {
  final String code;

  VerificationCode(this.code);

  int get lenght => code.length;

  bool operator(Object o) {
    if (identical(this, o)) return true;
    return false;
  }
}
