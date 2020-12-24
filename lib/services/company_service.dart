import 'dart:convert';

import '../constants/credentials.dart';
import '../core/failure.dart';
import '../core/formater.dart';
import '../models/company_model.dart';
import '../models/user_credentials.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  SharedPref sPref = SharedPref();
  Credentials credentials = Credentials();
  Formater formater = Formater();
  NetworkConnectionImpl status = NetworkConnectionImpl();

  //https://api.edi.md/ISMobileDiscountService/json/GetCompany?ID={ID}
  Future<dynamic> getCompanyList() async {
    String id = await UserCredentials().getUserIdFromLocalStore();
    String serviceName = await getServiceNameFromRemoteConfig();
    if (await status.isConnected) {
      try {
        final url = "$serviceName/json/GetCompany?ID=$id";
        final response = await http.get(url, headers: credentials.header)
            /* .timeout(Duration(seconds: 3)) */;
        if (response.statusCode == 200) {
          final Map<String, dynamic> companiesToMap =
              json.decode(response.body);
          final List _listOfCompanies = companiesToMap['Companies'];
          if (_listOfCompanies.isNotEmpty) {
            final companyListwithdecodedLogo =
                formater.checkImageFormatAndSkip(_listOfCompanies, 'Logo');
            return companyListwithdecodedLogo
                .map((e) => Company.fromJson(e))
                .toList();
          } else {
            throw EmptyList();
          }
          /* .forEach((company) {
            saveCompanyOnDB(company) });*/

          /*  return companyListwithdecodedLogo
              .map((map) => Company.fromJson(map))
              .toList(); */
        } else {
          throw NoInternetConection();
        }
      } catch (e) {
       /*  FirebaseCrashlytics.instance.recordError(e, s); */
        throw EmptyList();
      }
    } else {
      throw NoInternetConection();
    }
  }

  /* Future<void> saveCompanyOnDB(Company company) async {
    Box<Company> companyBox = Hive.box<Company>('company');
    companyBox.add(Company(
      name: company.name,
      id: company.id,
      logo: company.logo,
      amount: company.amount,
    ));
    print('companyBoxValue:$companyBox.values');
  } */
}
