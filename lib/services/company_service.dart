import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../core/constants/credentials.dart';
import '../core/failure.dart';
import '../core/formater.dart';
import '../models/company_model.dart';
import '../models/user_credentials.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';

class CompanyService {
  SharedPref sPref = SharedPref();
  Credentials credentials = Credentials();
  Formater formater = Formater();
  NetworkConnectionImpl status = NetworkConnectionImpl();
  Box<Company> companyBox = Hive.box<Company>('company');

  //https://api.edi.md/ISMobileDiscountService/json/GetCompany?ID={ID}
  Future<List<Company>> getCompanyList() async {
    String id = await UserCredentials().getUserIdFromLocalStore();
    String serviceName = await getServiceNameFromRemoteConfig();
    if (await status.isConnected) {
      try {
        final url = "$serviceName/json/GetCompany?ID=$id";
        final response = await http
            .get(url, headers: credentials.header)
            .timeout(Duration(seconds: 3));
        if (response.statusCode == 200) {
          final Map<String, dynamic> _responseJsonMap =
              json.decode(response.body);

          final List _listOfCompanyMaps = _responseJsonMap['Companies'];

          if (_listOfCompanyMaps.isNotEmpty) {
            final companyListwithDecodedLogo =
                formater.checkImageFormatAndDecode(_listOfCompanyMaps, 'Logo');

            final List<Company> _listOfCompanyObjects =
                companyListwithDecodedLogo
                    .map((map) => Company.fromJson(map))
                    .toList();
            _listOfCompanyObjects.forEach((company) => _saveCompanyToDB(company));

            return _listOfCompanyObjects;
          } else {
            throw EmptyList();
          }
        } else {
          throw NoInternetConection();
        }
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(e, s);
        throw EmptyList();
      }
    } else {
      throw NoInternetConection();
    }
  }

  _saveCompanyToDB(Company company) {
    companyBox.put(company.id, company);
  }
}
