import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
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

import 'package:my_discount/services/remote_config_service.dart';

import '../fixtures/fixtures_redear.dart';

class MockFormater extends Mock implements Formater {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockCredentials extends Mock implements Credentials {}

class MockHttpClient extends Mock implements http.Client {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MockRemoteConfig extends Mock implements RemoteConfigService {}

class MockNetworkConnections extends Mock implements NetworkConnection {}

class MockIsService extends Mock implements IsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockIsService _service;
  /* MockLocalRepository _repo;
  MockRemoteDataSource _remoteDataSource; */
  MockNetworkConnections _inet;

  setUp(() {
    _service = MockIsService();
    /*  _repo = MockLocalRepository();
    _remoteDataSource = MockRemoteDataSource(); */

    _inet = MockNetworkConnections();
  });

  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(_inet.isConnected).thenAnswer((_) async => true);
        });
        body();
      },
    );
  }

  runTestsOnline(() {
    group('getAppNews', () {
      final tNewsList = [
        News(
          companyId: 0,
          content: 'test Content',
          logo: Uint8List.fromList([]),
          companyName: 'TestCompany',
          appType: null,
          dateTime: '21 Jan 2021',
          header: 'null',
          id: 1,
          photo: Uint8List.fromList([]),
        ),
      ];
      test('check if function return a list of news', () async {
        when(_service.getAppNews()).thenAnswer((_) async => tNewsList);

        final response = await _service.getAppNews();

        expect(response, tNewsList);
        verify(_service.getAppNews());
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
        when(_service.validatePhone())
            .thenAnswer((realInvocation) async => tCode);
        final response = await _service.validatePhone();

        expect(response, tCode);
      });
    });

    group('updateClientInfo()', () {
      test('function must return a empty body', () async {
        final tUser = User();
        when(_service.updateClientInfo())
            .thenAnswer((realInvocation) async => tUser);

        final response = await _service.updateClientInfo();

        expect(response, tUser);
      });
    });
  });
}
