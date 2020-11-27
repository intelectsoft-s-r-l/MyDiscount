import 'package:flutter/foundation.dart';

class ServiceException implements Exception {
  final int errorCode;
  final String errorMessage;

  ServiceException({
    @required this.errorCode,
    @required this.errorMessage,
  });

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! ServiceException) return false;
    return other.toString() == this.toString();
  }

  @override
  int get hashCode {
    return this.toString().hashCode;
  }

  @override
  String toString() {
    return "[ErrorCode:$errorCode] $errorMessage";
  }
}

ServiceException internalError() {
  return ServiceException(errorCode: -1, errorMessage: '');
}

ServiceException apiKeyNotMatch() {
  return ServiceException(errorCode: 3, errorMessage: 'APIKey does not match');
}

ServiceException apiKeyNotExist() {
  return ServiceException(errorCode: 8, errorMessage: 'APIKey does not exist');
}

ServiceException companyWithSuchApiKeyNotExist() {
  return ServiceException(
      errorCode: 100, errorMessage: 'Company With Such ApiKey Not Exists');
}

ServiceException tKeynotExist() {
  return ServiceException(errorCode: 102, errorMessage: 'TKey does not exist');
}

ServiceException cardNotExist() {
  return ServiceException(errorCode: 103, errorMessage: 'Card not exist');
}

ServiceException expiredToken() {
  return ServiceException(errorCode: 104, errorMessage: 'Expired Token');
}

ServiceException cardAlreadyExist() {
  return ServiceException(errorCode: 105, errorMessage: 'Card Already Exist');
}

ServiceException invalidToken() {
  return ServiceException(errorCode: 106, errorMessage: 'Invalid Token');
}
