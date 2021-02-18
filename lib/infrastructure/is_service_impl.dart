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
