import 'package:injectable/injectable.dart';
import 'package:is_service/service_client_response.dart';

import '../domain/data_source/remote_datasource.dart';
import '../domain/entities/card.dart';
import '../domain/entities/company_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/tranzaction_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/is_service_repository.dart';
import '../domain/repositories/local_repository.dart';
import 'core/failure.dart';
import 'core/formater.dart';
import 'settings/settings_Impl.dart';

@LazySingleton(as: IsService)
class IsServiceImpl implements IsService {
  final RemoteDataSource remoteDataSourceImpl;
  final Formater _formater;
  final LocalRepository _localRepository;
  final AppSettings settings;
  IsServiceImpl(
    this._localRepository,
    this._formater,
    this.remoteDataSourceImpl,
    this.settings,
  );
  @override
  Future<List<News>> getAppNews() async {
    try {
      if (settings.getSettings().newsEnabled) {
        final eldestLocalNewsId = _localRepository.readEldestNewsId();
        final _urlFragment = '/json/GetAppNews?ID=$eldestLocalNewsId';
        final response = await remoteDataSourceImpl.getRequest(_urlFragment);
        if (response.statusCode == 0) {
          final _listNewsMaps = response.body as List;
          _formater
            ..parseDateTime(_listNewsMaps, 'CreateDate')
            ..deleteImageFormatAndDecode(_listNewsMaps, 'CompanyLogo')
            ..deleteImageFormatAndDecode(_listNewsMaps, 'Photo');
         
          _localRepository.saveNewsLocal(_listNewsMaps);
          return _localRepository.getLocalNews();
        } else {
          throw ServerError();
        }
      } else {
        _localRepository.deleteNews();
      }
      throw EmptyList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> getClientInfo({String? id, int? registerMode}) async {
    try {
      final localUser = _localRepository.getLocalUser();
      final _id = id ?? localUser.id;
      final _registerMode = registerMode ?? localUser.registerMode;
      final _urlFragment =
          '/json/GetClientInfo?ID=$_id&RegisterMode=$_registerMode';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      //print(response.statusCode);
      if (response.statusCode == 0) {
        final profileMap = response.body as Map<String, dynamic>;
        _formater
          ..splitDisplayName(profileMap)
          ..addToProfileMapSignMethod(profileMap, _registerMode);
        await _formater.downloadProfileImageOrDecodeString(profileMap);
        final profile = Profile.fromJson(profileMap);
        _localRepository.saveClientInfoLocal(profile);
        return profile;
      } else {
        return Profile.empty();
      }
    } catch (e) {
      //print(e);

      throw ServerError();
    }
  }

  @override
  Future<List<Company>> getCompanyList() async {
    try {
      final user = _localRepository.getLocalUser();
      final _urlFragment = '/json/GetCompany?ID=${user.id}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final companyListMaps = response.body as List;
        _formater.deleteImageFormatAndDecode(companyListMaps, 'Logo');
        final companyList = companyListMaps
            .map((company) => Company.fromJson(company))
            .toList();
        _localRepository.saveCompanyListLocal(companyList);
        if (companyList.isEmpty) {
          throw EmptyList();
        }
        return companyList;
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
      final user = _localRepository.getLocalUser();
      final _urlFragment =
          '/json/GetTempID?ID=${user.id}&RegisterMode=${user.registerMode}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final id = response.body as String?;
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
      final user = _localRepository.getLocalUser();
      final _urlFragment =
          '/json/GetTransactionList?ID=${user.id}&RegisterMode=${user.registerMode}';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        final listTransactionsMaps = response.body as List;
        _formater
          ..parseDateTime(listTransactionsMaps, 'DateTimeOfSale')
          ..deleteImageFormatAndDecode(listTransactionsMaps, 'Logo');
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
  Future<String> validatePhone({required String phone}) async {
    try {
      final _urlFragment = '/json/ValidatePhone?Phone=$phone';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      if (response.statusCode == 0) {
        return response.body;
      } else {
        throw ServerError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateClientInfo({required Map<String, dynamic> json}) async {
    //print(json);
    try {
      //throw Error();
      final _urlFragment = '/json/UpdateClientInfo';

      final response = await remoteDataSourceImpl.postRequest(
          json: json, urlFragment: _urlFragment);

      final userMap = _localRepository.returnUserMapToSave(json);

      if (response.statusCode == 0) {
        
        final user = User.fromJson(userMap);
         _formater
          ..splitDisplayName(json)
          ..addToProfileMapSignMethod(json, user.registerMode);
        await _formater.downloadProfileImageOrDecodeString(json);
        final profile = Profile.fromJson(json);
        _localRepository..saveClientInfoLocal(profile)..saveUserLocal(user);
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
      {String? id, int? registerMode}) async {
    try {
      final localUser = _localRepository.getLocalUser();
      final _id = id ?? localUser.id;
      final _registerMode = registerMode ?? localUser.registerMode;
      final _urlFragment =
          '/json/GetRequestActivationCards?ID=$_id&RegisterMode=$_registerMode';
      final response = await remoteDataSourceImpl.getRequest(_urlFragment);
      final listofCardsMaps = response.body as List;
      _formater.deleteImageFormatAndDecode(listofCardsMaps, 'Logo');
      final listOfCards =
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
  Future<IsResponse> requestActivationCard(
      {required Map<String, dynamic> json}) async {
    try {
      final _urlFragment = '/json/RequestActivationCard';
      final response = await remoteDataSourceImpl.postRequest(
          json: json, urlFragment: _urlFragment);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
