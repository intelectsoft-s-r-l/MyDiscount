import 'package:MyDiscount/domain/repositories/local_repository.dart';
import 'package:MyDiscount/providers/news_settings.dart';
import 'package:injectable/injectable.dart';
import 'package:IsService/service_client.dart';

import '../core/failure.dart';
import '../core/formater.dart';
import '../core/internet_connection_service.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/tranzaction_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/company_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/is_service_repository.dart';
import '../services/remote_config_service.dart';

@LazySingleton(as: IsService)
class IsServiceImpl implements IsService {
  final ServiceClient _client;
  final NetworkConnection _network;
  final Formater _formater;
  final LocalRepository _localRepository;
  NewsSettings settings = NewsSettings();

  IsServiceImpl(this._client, this._network, this._localRepository, this._formater);
  @override
  Future<List<News>> getAppNews() async {
    try {
      if (await settings.getNewsState()) {
        final String eldestLocalNewsId = _localRepository.readEldestNewsId();
        final String _urlFragment = '/json/GetAppNews?ID=$eldestLocalNewsId';
        final List _listNewsMaps = await _getResponse(_urlFragment);
        _formater.parseDateTime(_listNewsMaps, 'CreateDate');
        _formater.checkImageFormatAndDecode(_listNewsMaps, 'CompanyLogo');
        _formater.checkImageFormatAndDecode(_listNewsMaps, 'Photo');
        _localRepository.saveLocalNews(_listNewsMaps);
      }
      return _localRepository.getLocalNews();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> getClientInfo() async {
    try {
      final User localUser = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetClientInfo?ID=${localUser.id}&RegisterMode=${localUser.registerMode}';
      final Map profileMap = await _getResponse(_urlFragment);
      _formater.splitDisplayName(profileMap);
      await _formater.downloadProfileImageOrDecodeString(profileMap);
      _formater.addToProfileMapSignMethod(profileMap, localUser);
      Profile profile = Profile.fromJson(profileMap);
      _localRepository.saveLocalClientInfo(profile);
      return profile;
    } catch (e) {
      rethrow;
    }
  }

/* flutter clean
pod cache clean  --all
rm -rf ios/Flutter/Flutter.framework

flutter pub get
pod install
flutter run
 */
  @override
  Future<List<Company>> getCompanyList() async {
    try {
      final User user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetCompany?ID=${user.id}';
      List listCompaniesMaps = await _getResponse(_urlFragment);
      _formater.checkImageFormatAndDecode(listCompaniesMaps, 'Logo');
      List<Company> listCompanies = listCompaniesMaps.map((company) => Company.fromJson(company)).toList();
      _localRepository.saveLocalCompanyList(listCompanies);
      if (listCompanies.isEmpty) {
        throw EmptyList();
      }
      return listCompanies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getTempId() async {
    try {
      // throw Error();
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
      //throw Error();
      final _url = 'https://dev.edi.md/ISMobileDiscountService/json/UpdateClientInfo';

      final response = await _client.post(_url, json);

      final userMap = _localRepository.returnUserMapToSave(json);

      if (response.statusCode == 0) {
        final user = _localRepository.saveLocalUser(User.fromJson(userMap));
        return user;
      } else {
        throw ServerError();
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
