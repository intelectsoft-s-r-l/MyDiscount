import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:is_service/service_client_response.dart';
import 'package:mockito/mockito.dart';

import 'package:my_discount/core/constants/credentials.dart';
import 'package:my_discount/core/formater.dart';
import 'package:my_discount/core/internet_connection_service.dart';
import 'package:my_discount/domain/data_source/remote_datasource.dart';
import 'package:my_discount/domain/entities/company_model.dart';
import 'package:my_discount/domain/entities/news_model.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/domain/entities/tranzaction_model.dart';
import 'package:my_discount/domain/entities/user_model.dart';
//import 'package:my_discount/domain/entities/user_model.dart';
import 'package:my_discount/domain/repositories/is_service_repository.dart';
import 'package:my_discount/domain/repositories/local_repository.dart';
import 'package:my_discount/infrastructure/is_service_impl.dart';
import 'package:my_discount/providers/news_settings.dart';

import 'package:my_discount/services/remote_config_service.dart';

import '../fixtures/fixtures_redear.dart';

class MockFormater extends Mock implements Formater {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockCredentials extends Mock implements Credentials {}

class MockHttpClient extends Mock implements http.Client {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MockRemoteConfig extends Mock implements RemoteConfigService {}

class MockNetworkConnections extends Mock implements NetworkConnection {}

class MockNewsState extends Mock implements NewsSettings {}

class MockIsService extends Mock implements IsService {}

class MockIsResponse extends Mock implements IsResponse {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockIsService _service;
  late MockLocalRepository _repo;
  late MockFormater _formater;
  late MockRemoteDataSource _remoteDataSource;
  late MockNetworkConnections _inet;
  late MockNewsState _newsState;
  late IsServiceImpl _serviceImpl;
  late MockIsResponse _isResponse;
  setUp(() {
    _service = MockIsService();
    _repo = MockLocalRepository();
    _formater = MockFormater();
    _remoteDataSource = MockRemoteDataSource();
    _inet = MockNetworkConnections();
    _newsState = MockNewsState();
    _isResponse = MockIsResponse();
    _serviceImpl =
        IsServiceImpl(_repo, _formater, _remoteDataSource, _newsState);
  });

  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(_inet.isConnected).thenAnswer((_) async => true);
          when(_newsState.getNewsState()).thenAnswer((_) async => true);
        });
        body();
      },
    );
  }

  runTestsOnline(() {
    final tUrlFragment = '/json/GetAppNews?ID=0';
    group('getAppNews', () {
      final tNewsList = [
        News(
          companyId: 0,
          content: 'test Content',
          logo: Uint8List.fromList([]),
          companyName: 'TestCompany',
          appType: 1,
          dateTime: '21 Jan 2021',
          header: 'null',
          id: 1,
          photo: Uint8List.fromList([]),
        ),
      ];
      final tResponse = IsResponse(0, 'errorMessage', tNewsList);
      test('check if function return a list of news', () async {
        when(_repo.readEldestNewsId()).thenAnswer((realInvocation) => '0');
        when(_remoteDataSource.getRequest(tUrlFragment))
            .thenAnswer((realInvocation) async => tResponse);
        when(_isResponse.statusCode).thenAnswer((realInvocation) => 0);
        when(_repo.getLocalNews()).thenAnswer((_) => tNewsList);

        final response = await _serviceImpl.getAppNews();
        verify(_formater.parseDateTime(response, 'CreateDate'))
            .called(response.length);
        verify(_formater.deleteImageFormatAndDecode(response, 'CompanyLogo'))
            .called(response.length);
        verify(_formater.deleteImageFormatAndDecode(response, 'Photo'))
            .called(response.length);

        expect(response, tNewsList);
        //verify(_service.getAppNews());
      });
    });

    group('getClientInfo()', () {
      test('check if function return a profile object', () async {
        final tClientInfo =
            json.decode(fixture('auth_providers_credentials.json'));
        final tProfile = Profile.fromJson(tClientInfo);
        when(_service.getClientInfo()).thenAnswer((_) async => tProfile);

        final response = await _service.getClientInfo();

        expect(response, tProfile);
        verify(_service.getClientInfo());
      });
    });
    group('getCompanyList()', () {
      test('check if function return a List of Company Objects', () async {
        final tcompanyList = [
          {
            'Amoun': 'String content',
            'ID': 2147483647,
            'Logo': Uint8List.fromList([]),
            'Name': 'String content'
          }
        ];

        final tList = tcompanyList.map((map) => Company.fromJson(map)).toList();

        when(_service.getCompanyList()).thenAnswer((_) async => tList);

        final response = await _service.getCompanyList();

        expect(response, tList);

        verify(_service.getCompanyList());
      });
    });
    group('getTempId()', () {
      test('chech if the function return a String temporary Id', () async {
        final tTempId = '';
        when(_service.getTempId()).thenAnswer((_) async => tTempId);

        final response = await _service.getTempId();

        expect(response, tTempId);
        verify(_service.getTempId());
      });
    });
    group('getTransactionList()', () {
      test('function must return a transaction list', () async {
        final tTransaction = [
          {
            'Amount': 12678967.543233,
            'Company': 'String content',
            'DateTimeOfSale': '\/Date(928138800000+0300)\/',
            'SalesPoint': 'String content'
          }
        ];
        final tTransactionList =
            tTransaction.map((e) => Transaction.fromJson(e)).toList();
        when(_service.getTransactionList())
            .thenAnswer((_) async => tTransactionList);

        final response = await _service.getTransactionList();

        expect(response, tTransactionList);
        verify(_service.getTransactionList());
      });
    });
    group('validatePhone()', () {
      test('function must return a verification code', () async {
        final tCode = '1234';
        when(_service.validatePhone(phone: ''))
            .thenAnswer((realInvocation) async => tCode);
        final response = await _service.validatePhone(phone: '');

        expect(response, tCode);
      });
    });

    group('updateClientInfo()', () {
      test('function must return a empty body', () async {
        final tUser = User(
          id: '',
          accessToken: '',
          registerMode: 0,
        );
        when(_service.updateClientInfo(json: {}))
            .thenAnswer((realInvocation) async => tUser);

        final response = await _service.updateClientInfo(json: {});

        expect(response, tUser);
      });
    });
  });
}
