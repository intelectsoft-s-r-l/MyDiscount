import 'package:IsService/service_client_response.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/core/formater.dart';

import '../core/failure.dart';
import '../domain/data_source/remote_datasource.dart';
import '../domain/entities/card.dart';
import '../domain/entities/company_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/tranzaction_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/is_service_repository.dart';
import '../domain/repositories/local_repository.dart';

@LazySingleton(as: IsService)
class IsServiceImpl implements IsService {
  final RemoteDataSource remoteDataSourceImpl;
  final Formater _formater;
  final LocalRepository _localRepository;

  IsServiceImpl(
    this._localRepository,
    this._formater,
    this.remoteDataSourceImpl,
  );
  @override
  Future<List<News>> getAppNews() async {
    try {
      /* if (await settings.getNewsState()) { */
      final  eldestLocalNewsId = _localRepository?.readEldestNewsId();
      final  _urlFragment = '/json/GetAppNews?ID=$eldestLocalNewsId';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final _listNewsMaps = response.body as List;
        _formater.parseDateTime(_listNewsMaps, 'CreateDate');
        _formater.checkImageFormatAndDecode(_listNewsMaps, 'CompanyLogo');
        _formater.checkImageFormatAndDecode(_listNewsMaps, 'Photo');
        _localRepository.saveLocalNews(_listNewsMaps);
        return _localRepository.getLocalNews();
      } else {
        throw ServerError();
      }
      /*  }
      return []; */
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> getClientInfo({String id, int registerMode}) async {
    try {
      final  localUser = _localRepository.getLocalUser();
      final _id = id ?? localUser?.id;
      final _registerMode = registerMode ?? localUser?.registerMode;
      final _urlFragment =
          '/json/GetClientInfo?ID=$_id&RegisterMode=$_registerMode';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final  profileMap = response.body as Map;
        _formater.splitDisplayName(profileMap);
        await _formater.downloadProfileImageOrDecodeString(profileMap);
        _formater.addToProfileMapSignMethod(profileMap, _registerMode);
        final profile = Profile.fromJson(profileMap);
        _localRepository.saveLocalClientInfo(profile);
        return profile;
      } else {
        throw ServerError();
      }
    } catch (e) {
      return null;
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
      final  user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetCompany?ID=${user.id}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final listCompaniesMaps = response.body as List;
        _formater.checkImageFormatAndDecode(listCompaniesMaps, 'Logo');
        final listCompanies = listCompaniesMaps
            .map((company) => Company.fromJson(company))
            .toList();
        _localRepository.saveLocalCompanyList(listCompanies);
        if (listCompanies.isEmpty) {
          throw EmptyList();
        }
        return listCompanies;
      } else {
        throw ServerError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getTempId() async {
    try {
      // throw Error();
      final  user = _localRepository.getLocalUser();
      final _urlFragment =
          '/json/GetTempID?ID=${user.id}&RegisterMode=${user.registerMode}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final id = response.body as String;
        return Future.value(id);
      } else {
        throw ServerError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransactionList() async {
    try {
      final  user = _localRepository.getLocalUser();
      final _urlFragment =
          '/json/GetTransactionList?ID=${user.id}&RegisterMode=${user.registerMode}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final listTransactionsMaps = response.body as List;
        final listTransactions = listTransactionsMaps
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();
        if (listTransactions.isEmpty) {
          throw EmptyList();
        }
        return listTransactions;
      } else {
        throw ServerError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> validatePhone({String phone}) async {
    try {
      final _urlFragment = '/json/ValidatePhone?Phone=$phone';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        print(response.body);
        return response.body;
      } else {
        throw ServerError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateClientInfo({Map<String, dynamic> json}) async {
    print(json);
    try {
      //throw Error();
      final _urlFragment = '/json/UpdateClientInfo';

      final response = await remoteDataSourceImpl.postRequest(
          json: json, urlFragment: _urlFragment);

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

  @override
  Future<List<DiscountCard>> getRequestActivationCards(
      {String id, int registerMode}) async {
    try {
      final localUser = _localRepository.getLocalUser();
      final _id = id ?? localUser?.id;
      final _registerMode = registerMode ?? localUser?.registerMode;
      final _urlFragment =
          '/json/GetRequestActivationCards?ID=$_id&RegisterMode=$_registerMode';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      final  listofCardsMaps = response.body as List;
      _formater.checkCompanyLogo(listofCardsMaps);
      final  listOfCards =
          listofCardsMaps.map((card) => DiscountCard.fromJson(card)).toList();
      if (listOfCards.isNotEmpty) {
        return listOfCards;
      } else {
        throw EmptyList();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<IsResponse> requestActivationCard({Map<String, dynamic> json}) async {
    final _urlFragment = '/json/RequestActivationCard';
    final response = await remoteDataSourceImpl.postRequest(
        json: json, urlFragment: _urlFragment);
    return response;
  }
}
