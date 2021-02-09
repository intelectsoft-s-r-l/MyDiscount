import 'dart:convert';

import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/services/user_credentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../core/constants/credentials.dart';
import '../core/failure.dart';
import '../core/formater.dart';

import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preferences_service.dart';
@injectable
class CompanyService {
  final SharedPref sPref ;
  final Credentials credentials ;
  final Formater formater ;
  final NetworkConnectionImpl status;
  final Box<Company> companyBox = Hive.box<Company>('company');

  CompanyService(this.sPref, this.credentials, this.formater, this.status);

  //https://api.edi.md/ISMobileDiscountService/json/GetCompany?ID={ID}
  Future<List<Company>> getCompanyList() async {
    final String id = await UserCredentials().getUserIdFromLocalStore();
    final String serviceName = await getServiceNameFromRemoteConfig();
    if (await status.isConnected) {
      try {
        final url = "$serviceName/json/GetCompany?ID=$id";
        final response = await http
            .get(url, headers: credentials.header)
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final companiesToMap =
              json.decode(response.body) as Map<String, dynamic>;
          final List _listOfCompanies = companiesToMap['Companies'] as List;
          if (_listOfCompanies.isNotEmpty) {
            final companyListwithdecodedLogo =
                formater.checkImageFormatAndSkip(_listOfCompanies, 'Logo');

            final comp = companyListwithdecodedLogo
                .map((e) => Company.fromJson(e as Map<String, dynamic>))
                .toList();
            comp.forEach((c) => _saveCompanyToDB(c));
            return comp;
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

  void _saveCompanyToDB(Company company) {
    companyBox.put(company.id, company);
  }
}
