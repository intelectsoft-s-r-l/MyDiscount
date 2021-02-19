import 'package:IsService/service_client.dart';
import 'package:MyDiscount/core/formater.dart';
import 'package:injectable/injectable.dart';

import '../core/failure.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/tranzaction_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/company_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/is_service_repository.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';

import 'local_repository_impl.dart';

@injectable
class IsServiceImpl implements IsService {
  final ServiceClient _client;
  final NetworkConnectionImpl _network;
  final Formater _formater;
  final LocalRepositoryImpl _localRepository;

  IsServiceImpl(this._client, this._network, this._localRepository, this._formater);
  @override
  Future<List<News>> getAppNews() async {
    try {
      final id = _localRepository.readEldestNewsId();
      final _urlFragment = '/json/GetAppNews?ID=$id';
      final List _listNewsMaps = await _getResponse(_urlFragment);
      _formater.parseDateTime(_listNewsMaps, 'CreateDate');
      _formater.checkImageFormatAndDecode(_listNewsMaps, 'CompanyLogo');
      _formater.checkImageFormatAndDecode(_listNewsMaps, 'Photo');
      _localRepository.saveLocalNews(_listNewsMaps);
      return _localRepository.getLocalNews();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> getClientInfo() async {
    try {
      final User user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetClientInfo?ID=${user.id}&RegisterMode=${user.registerMode}';
      final Map profileMap = await _getResponse(_urlFragment);
      await _formater.splitDisplayName(profileMap);
      Profile profile = Profile.fromJson(profileMap);
      _localRepository.saveLocalClientInfo(profile);
      return profile;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Company>> getCompanyList() async {
    try {
      final User user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetCompany?ID=${user.id}';
      List listCompaniesMaps = await _getResponse(_urlFragment);
      _formater.checkImageFormatAndDecode(listCompaniesMaps, 'Logo');
      _localRepository.saveLocalCompanyList(listCompaniesMaps);
      List<Company> listCompanies = listCompaniesMaps.map((company) => Company.fromJson(company)).toList();
      return listCompanies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getTempId() async {
    try {
      final User user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetTempID?ID=${user.id}&RegisterMode=${user.registerMode}';
      String id = await _getResponse(_urlFragment) as String;
      return Future.value(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransactionList() async {
    try {
      final User user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetTransactionList?ID=${user.id}&RegisterMode=${user.registerMode}';
      List listTransactionsMaps = await _getResponse(_urlFragment);
      List<Transaction> listTransactions = listTransactionsMaps.map((transaction) => Transaction.fromJson(transaction)).toList();
      if (listTransactions.length == 0) {
        throw EmptyList();
      }
      return listTransactions;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> validatePhone({String phone}) async {
    try {
      final _urlFragment = '/json/ValidatePhone?Phone=$phone';
      return await _getResponse(_urlFragment);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateClientInfo({Map<String, dynamic> json}) async {
    print(json);
    try {
      final _url = 'https://dev.edi.md/ISMobileDiscountService/json/UpdateClientInfo';
      if (await _network.isConnected) {
        final response = await _client.post(_url, json);

        final userMap = _localRepository.returnUserMapToSave(json);

        if (response.statusCode == 0) {
          final user = _localRepository.saveLocalUser(User.fromJson(userMap));
          return user;
        } else {
          throw ServerError();
        }
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future _getResponse(String urlFragment) async {
    final serviceName = await getServiceNameFromRemoteConfig();
    final _baseUrl = '$serviceName$urlFragment';
    try {
      if (await _network.isConnected) {
        final response = await _client.get(_baseUrl);

        if (response.statusCode == 0) {
          return response.body;
        } else {
          throw ServerError();
        }
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      rethrow;
    }
  }
}
/* {DisplayName: null null, Email: null, ID: 001179.71c0864b494945a8a3801eb289447bd3.0905, PhotoUrl: , PushToken: , RegisterMode: 3, access_token: eyJraWQiOiJZdXlYb1kiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmludGVsZWN0c29mdC5kaXNjb3VudCIsImV4cCI6MTYxMzczNDA2OSwiaWF0IjoxNjEzNjQ3NjY5LCJzdWIiOiIwMDExNzkuNzFjMDg2NGI0OTQ5NDVhOGEzODAxZWIyODk0NDdiZDMuMDkwNSIsImNfaGFzaCI6Ikd2T1FNMmJfRXJoOEVhdXF4NTZmOUEiLCJlbWFpbCI6ImNyaXN0ZWFpb24zNkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJhdXRoX3RpbWUiOjE2MTM2NDc2NjksIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.sDQLQCR7oGU0pe8rEzb5fViPkC5lwDT8iry_jsIjtY_9ApfY7-jKRyww3aJpLRmGZLBrgSx0gpjpObyz3q0fggWezzivA-B2ETbWJq9uvlDVZsKzO3EHkjFFU6qV2TRdFkUQrT2hGnfrOtUStmONDH-eMpY6k1ChDe7jbYqGilR4hc0wF99t6bWpjxMhYfeMsH08YWy6GSnvofwU8PiI2RVR-QkMZGzTgNjgs8b2OEumOTdWLAE-gd-NYKnCAOP95ULTQgK7lvWBB-Zhk0c-mDWcEI25zg_o_dyE0IPRKxhPOXp_hrI7lsKLTPOQ5j5tIlfrqxVh1SH-vdEk96-odA} */
/* https://dev.edi.md/ISMobileDiscountService/json/GetTempID?ID=001179.71c0864b494945a8a3801eb289447bd3.0905&RegisterMode=3 */
/* https://dev.edi.md/ISMobileDiscountService/json/GetTempID?ID=001179.71c0864b494945a8a3801eb289447bd3.0905&RegisterMode=3 */
