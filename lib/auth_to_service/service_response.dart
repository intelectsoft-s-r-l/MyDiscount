import 'package:MyDiscount/auth_to_service/company.dart';
import 'package:flutter/foundation.dart';

abstract class ServiceResponseTid {
  final int errorCode;
  final String errorMessage;
  final String tID;
  final String temporaryCode;
  const ServiceResponseTid({
   @required this.errorCode,
   @required this.errorMessage,
   @required this.tID,
   @required this.temporaryCode,
  });
}

class ServiceResponseGetCompany {
  final int errorCode;
  final String errorMessage;
  final List<Company> company;

  ServiceResponseGetCompany({
   @required this.errorCode,
   @required this.errorMessage,
   @required this.company,
  });
}
