import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:is_service/service_client_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/infrastructure/core/failure.dart';

import 'package:my_discount/infrastructure/core/formater.dart';
import 'package:my_discount/infrastructure/core/internet_connection_service.dart';
import 'package:my_discount/domain/data_source/remote_datasource.dart';
import 'package:my_discount/domain/entities/card.dart';
import 'package:my_discount/domain/entities/company_model.dart';
import 'package:my_discount/domain/entities/news_model.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/domain/entities/tranzaction_model.dart';
import 'package:my_discount/domain/entities/user_model.dart';
import 'package:my_discount/domain/repositories/local_repository.dart';
import 'package:my_discount/domain/settings/settings.dart';
import 'package:my_discount/infrastructure/is_service_impl.dart';
//import 'package:my_discount/aplication/providers/news_settings.dart';


import 'package:my_discount/infrastructure/settings/settings_Impl.dart';

import '../fixtures/fixtures_redear.dart';
import 'is_service_impl_test.mocks.dart';

@GenerateMocks([
  IsResponse,
  AppSettings,
  NetworkConnection,

  LocalRepository,
  Formater,
  RemoteDataSource,
  User,
  Settings
])
void main() {
  final _repo = MockLocalRepository();
  final _formater = MockFormater();
  final _remoteDataSource = MockRemoteDataSource();
  final _inet = MockNetworkConnection();
  final _appState = MockAppSettings();
  final _mockSettings = MockSettings();
  final _isResponse = MockIsResponse();
  final user = MockUser();
  final _serviceImpl =
      IsServiceImpl(_repo, _formater, _remoteDataSource, _appState);
  final _id = '';
  final _registerMode = -1;
  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(_inet.isConnected).thenAnswer((_) async => true);
          when(_appState.getSettings())
              .thenAnswer((realInvocation) => _mockSettings);
          when(_mockSettings.newsEnabled).thenAnswer((_) => true);
        });
        body();
      },
    );
  }

  void runTestsOffline(Function body) {
    group(
      'if device is offline',
      () {
        setUp(() {
          when(_inet.isConnected).thenAnswer((_) async => false);
          when(_appState.getSettings())
              .thenAnswer((realInvocation) => _mockSettings);
          when(_mockSettings.newsEnabled).thenAnswer((_) => true);
        });
        body();
      },
    );
  }

  runTestsOnline(() {
    final tUrlFragment = '/json/GetAppNews?ID=0';
    group('getAppNews', () {
      final tNewsList = <News>[
        News(
          companyId: 0,
          content: 'test Content',
          logo: Uint8List.fromList([]),
          companyName: 'TestCompany',
          appType: 1,
          dateTime: '21 Jan 2021',
          header: '',
          id: 1,
          photo: Uint8List.fromList([]),
        ),
      ];

      final tJson = json.decode(fixture('list_of_news.json')) as List;

      final tListMap = tJson.toList().cast<Map<String, dynamic>>();
      final tResponse = IsResponse(0, 'errorMessage', tJson);
      test('must return a list of news', () async {
        // the real invocation
        when(_repo.readEldestNewsId()).thenAnswer((_) => '0');
        when(_remoteDataSource.getRequest(tUrlFragment))
            .thenAnswer((realInvocation) async => tResponse);
        when(_isResponse.statusCode).thenAnswer((_) => 0);
        when(_repo.getLocalNews()).thenAnswer((_) => tNewsList);
        when(_formater.parseDateTime(tJson, 'CreateDate'))
            .thenAnswer((_) => tJson);
        when(_formater.deleteImageFormatAndDecode(tJson, 'CompanyLogo'))
            .thenAnswer((_) => tListMap);
        when(_formater.deleteImageFormatAndDecode(tJson, 'Photo'))
            .thenAnswer((_) => tListMap);
        when(_repo.deleteNews()).thenAnswer((_) => <News>[]);

        final response = await _serviceImpl.getAppNews();
        verify(_formater.parseDateTime(tJson, 'CreateDate'))
            .called(response.length);
        verify(_formater.deleteImageFormatAndDecode(tJson, 'CompanyLogo'))
            .called(response.length);
        verify(_formater.deleteImageFormatAndDecode(tJson, 'Photo'))
            .called(response.length);

        expect(response, tNewsList);
      });
    });

    group('getClientInfo()', () {
      final tUrlFragment =
          '/json/GetClientInfo?ID=$_id&RegisterMode=$_registerMode';
      test('must return a profile object', () async {
        final tClientInfo = <String, dynamic>{
          'Name': 'Ion Cristea',
          'Email': '',
          'ID': '',
          'phone': '',
          'Photo': Uint8List.fromList([]),
          'PushToken': '',
          'RegisterMode': 1,
          'access_token': ''
        };
        final tProfile = Profile.fromJson(tClientInfo);
        final tResponse = IsResponse(0, 'errorMessage', tClientInfo);
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(user.id).thenAnswer((realInvocation) => '12312342341234214');
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(_formater.splitDisplayName(tClientInfo)).thenAnswer(
            (realInvocation) => tClientInfo.cast<String, dynamic>());
        when(_formater.downloadProfileImageOrDecodeString(tClientInfo))
            .thenAnswer(
                (realInvocation) async => tClientInfo.cast<String, dynamic>());
        when(_formater.addToProfileMapSignMethod(tClientInfo, _registerMode))
            .thenAnswer(
                (realInvocation) => tClientInfo.cast<String, dynamic>());
        when(_remoteDataSource.getRequest(tUrlFragment))
            .thenAnswer((_) async => tResponse);
        when(_repo.saveClientInfoLocal(any)).thenAnswer((_) => tProfile);

        final response = await _serviceImpl.getClientInfo();

        expect(response, tProfile);
      });
    });
    group('getCompanyList()', () {
      final tUrlFragment = '/json/GetCompany?ID=$_id';
      test('must return a List of Company Objects', () async {
        final tCompanyList = <Map<String, dynamic>>[
          {
            'Amount': 'String content',
            'ID': 2147483647,
            'Logo': Uint8List.fromList([]),
            'Name': 'String content'
          }
        ];
        final tList = tCompanyList.map((map) => Company.fromJson(map)).toList();
        final tResponse = IsResponse(0, 'errorMessage', tCompanyList);

        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(user.id).thenAnswer((realInvocation) => '12312342341234214');
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(_formater.deleteImageFormatAndDecode(tCompanyList, 'Logo'))
            .thenAnswer((_) => tCompanyList);
        when(_remoteDataSource.getRequest(tUrlFragment))
            .thenAnswer((_) async => tResponse);
        when(_isResponse.statusCode).thenAnswer((_) => 0);

        final response = await _serviceImpl.getCompanyList();

        expect(response, tList);
      });
    });
    group('getTempId()', () {
      final tUrl = '/json/GetTempID?ID=$_id&RegisterMode=$_registerMode';
      test('must return a String temporary Id', () async {
        final tTempId = '';
        final tResponse = IsResponse(0, 'errorMessage', tTempId);
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(user.id).thenAnswer((realInvocation) => '12312342341234214');
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(_remoteDataSource.getRequest(tUrl))
            .thenAnswer((_) async => tResponse);

        final response = await _serviceImpl.getTempId();

        expect(response, tTempId);
      });
    });
    group('getTransactionList()', () {
      final _urlFragment =
          '/json/GetTransactionList?ID=$_id&RegisterMode=$_registerMode';
      test('must return a transaction list', () async {
        final tTransaction = <Map<String, dynamic>>[
          {
            'Amount': 12678967.543233,
            'Company': 'String content',
            'DateTimeOfSale': '\/Date(928138800000+0300)\/',
            'SalesPoint': 'String content'
          }
        ];
        final tTransactionList =
            tTransaction.map((e) => Transaction.fromJson(e)).toList();
        final tResponse = IsResponse(0, 'errorMessage', tTransaction);
        when(_remoteDataSource.getRequest(_urlFragment))
            .thenAnswer((_) async => tResponse);
        when(_isResponse.statusCode).thenAnswer((_) => 0);
        when(_formater.parseDateTime(tTransaction, 'DateTimeOfSale'))
            .thenAnswer((_) => tTransaction);
        when(_formater.deleteImageFormatAndDecode(tTransaction, 'Logo'))
            .thenAnswer((realInvocation) => tTransaction);

        final response = await _serviceImpl.getTransactionList();

        expect(response, tTransactionList);
      });
    });
    group('validatePhone()', () {
      test('function must return a verification code', () async {
        final phone = '123456789';
        final _urlFragment = '/json/ValidatePhone?Phone=$phone';
        final tCode = '1234';
        final tResponse = IsResponse(0, 'errorMessage', tCode);
        when(_remoteDataSource.getRequest(_urlFragment))
            .thenAnswer((_) async => tResponse);
        final response = await _serviceImpl.validatePhone(phone: phone);

        expect(response, tResponse.body);
      });
    });

    group('updateClientInfo()', () {
      final _urlFragment = '/json/UpdateClientInfo';
      test('function must return a empty body', () async {
        final tUser =
            User(id: '', accessToken: '', registerMode: 0, expireDate: '');
        final tResponse = IsResponse(0, 'errorMessage', tUser.toJson());
        when(_remoteDataSource.postRequest(
                json: tUser.toJson(), urlFragment: _urlFragment))
            .thenAnswer((realInvocation) async => tResponse);
        when(_repo.returnUserMapToSave(tUser.toJson()))
            .thenAnswer((realInvocation) => tUser.toJson());
        when(_repo.saveUserLocal(any)).thenAnswer((_) => tUser);

        final response =
            await _serviceImpl.updateClientInfo(json: tUser.toJson());

        expect(response, tUser);
      });
    });

    group('getRequestActivationCards()', () {
      test('function must return a list of Discound Card Objects', () async {
        final tCardList = <Map<String, dynamic>>[
          {
            'Code': 'String content',
            'Company': 'String content',
            'State': 0,
            'Logo': Uint8List.fromList([]),
          }
        ];
        final tCard = tCardList.map((card) => DiscountCard.fromJson(card));
        final tResponse = IsResponse(0, 'errorMessage', tCardList);
        final _urlFragment =
            '/json/GetRequestActivationCards?ID=$_id&RegisterMode=$_registerMode';
        when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
        when(_remoteDataSource.getRequest(_urlFragment))
            .thenAnswer((realInvocation) async => tResponse);
        when(_formater.deleteImageFormatAndDecode(tCardList, 'Logo'))
            .thenAnswer((realInvocation) => tCardList);

        final response = await _serviceImpl.getRequestActivationCards();

        expect(response, tCard);
      });
    });

    group('requestActivationCard()', () {
      test('function must return error code 0 when we activaiting a new card',
          () async {
        final tJson = <String, dynamic>{
          'CardCode': 'String content',
          'CompanyID': 2147483647,
          'ID': 'String content',
          'RegisterMode': 0
        };
        final _urlFragment = '/json/RequestActivationCard';
        when(_remoteDataSource.postRequest(
                json: tJson, urlFragment: _urlFragment))
            .thenAnswer((_) async => IsResponse(0, 'errorMessage', null));

        final response = await _serviceImpl.requestActivationCard(json: tJson);
        expect(response.statusCode, 0);
      });
    });
  });

  ///Ofline tests[Tests]
  ///
  ///
  ///

  group('check errors', () {
    final tUrlFragment = '/json/GetAppNews?ID=0';
    when(_inet.isConnected).thenAnswer((_) async => true);
    when(_appState.getSettings().newsEnabled).thenAnswer((_) => true);
    group('ServerError', () {
      test('getAppNews catch server error when status code is 0', () {
        when(_remoteDataSource.getRequest(tUrlFragment))
            .thenAnswer((_) async => IsResponse(167, 'errorMessage', null));
        expect(_serviceImpl.getAppNews, throwsException);
      });
    });

    runTestsOffline(() {
      group('getAppNews', () {
        test('check if function throw NointernetConnection exception',
            () async {
          // the real invocation
          when(_repo.readEldestNewsId()).thenAnswer((_) => '0');
          when(_remoteDataSource.getRequest(tUrlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getAppNews(), throwsException);
        });
      });

      group('getClientInfo()', () {
        final tUrlFragment =
            '/json/GetClientInfo?ID=$_id&RegisterMode=$_registerMode';
        test('throw NoInternetConnection', () async {
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
          when(user.id).thenAnswer((realInvocation) => '12312342341234214');
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());

          when(_remoteDataSource.getRequest(tUrlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getClientInfo(), throwsException);
        });
      });
      group('getCompanyList()', () {
        final tUrlFragment = '/json/GetCompany?ID=$_id';
        test('throw NoInternetConnection', () async {
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
          when(user.id).thenAnswer((realInvocation) => '12312342341234214');
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());

          when(_remoteDataSource.getRequest(tUrlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getCompanyList(), throwsException);
        });
      });
      group('getTempId()', () {
        final tUrl = '/json/GetTempID?ID=$_id&RegisterMode=$_registerMode';
        test('throw NoInternetConnection', () async {
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
          when(user.id).thenAnswer((realInvocation) => '12312342341234214');
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
          when(_remoteDataSource.getRequest(tUrl))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getTempId(), throwsException);
        });
      });
      group('getTransactionList()', () {
        final _urlFragment =
            '/json/GetTransactionList?ID=$_id&RegisterMode=$_registerMode';
        test('throw NoInternetConnection', () async {
          when(_remoteDataSource.getRequest(_urlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getTransactionList(), throwsException);
        });
      });
      group('validatePhone()', () {
        test('throw NoInternetConnection', () async {
          final phone = '123456789';
          final _urlFragment = '/json/ValidatePhone?Phone=$phone';
          when(_remoteDataSource.getRequest(_urlFragment))
              .thenThrow(NoInternetConection());
          expect(_serviceImpl.validatePhone(phone: phone), throwsException);
        });
      });

      group('updateClientInfo()', () {
        final _urlFragment = '/json/UpdateClientInfo';
        test('throw NoInternetConnection', () async {
          final tUser =
              User(id: '', accessToken: '', registerMode: 0, expireDate: '');
          when(_remoteDataSource.postRequest(
                  json: tUser.toJson(), urlFragment: _urlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.updateClientInfo(json: tUser.toJson()),
              throwsException);
        });
      });

      group('getRequestActivationCards()', () {
        test('throw NoInternetConnection', () async {
          final _urlFragment =
              '/json/GetRequestActivationCards?ID=$_id&RegisterMode=$_registerMode';
          when(_repo.getLocalUser()).thenAnswer((_) => User.empty());
          when(_remoteDataSource.getRequest(_urlFragment))
              .thenThrow(NoInternetConection());

          expect(_serviceImpl.getRequestActivationCards(), throwsException);
        });
      });

      group('requestActivationCard()', () {
        test('throw NoInternetConnection', () async {
          final tJson = <String, dynamic>{
            'CardCode': 'String content',
            'CompanyID': 2147483647,
            'ID': 'String content',
            'RegisterMode': 0
          };
          final _urlFragment = '/json/RequestActivationCard';
          when(_remoteDataSource.postRequest(
                  json: tJson, urlFragment: _urlFragment))
              .thenThrow(NoInternetConection());

          expect(
              _serviceImpl.requestActivationCard(json: tJson), throwsException);
        });
      });
    });
  });
}
