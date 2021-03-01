import 'dart:convert';
import 'dart:typed_data';

import 'package:IsService/service_client.dart';
import 'package:IsService/service_client_response.dart';
import 'package:MyDiscount/core/constants/credentials.dart';
import 'package:MyDiscount/core/formater.dart';
import 'package:MyDiscount/core/internet_connection_service.dart';
import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/domain/repositories/local_repository.dart';
import 'package:MyDiscount/infrastructure/is_service_impl.dart';
import 'package:MyDiscount/services/remote_config_service.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../fixtures/fixtures_redear.dart';

class MockFormater extends Mock implements Formater {}

class MockInternetConnection extends Mock implements NetworkConnection {}

class MockCredentials extends Mock implements Credentials {}

class MockHttpClient extends Mock implements http.Client {}

class MockLocalRepositoryImpl extends Mock implements LocalRepository {}

class MockRemoteConfig extends Mock implements RemoteConfigService {}

class MockServiceClient extends Mock implements ServiceClient {
  // ignore: unused_field
  http.Client _client = MockHttpClient();
  final String _credential;

  MockServiceClient(this._credential);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockLocalRepositoryImpl _repo;
  IsServiceImpl _service;
  MockInternetConnection _inet;
  MockServiceClient _client;
  MockFormater _formater;
  MockRemoteConfig _remoteConf;

  setUp(() {
    _service = IsServiceImpl(
      _client,
      _inet,
      _repo,
      _formater,
      _remoteConf,
    );
    _repo = MockLocalRepositoryImpl();
    _remoteConf = MockRemoteConfig();
    _inet = MockInternetConnection();
    _formater = MockFormater();
    String cr = Credentials().header;
    _client = MockServiceClient(cr);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(_inet.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  runTestsOnline(() {
    group('getAppNews', () {
      final tNewsList = [
        News(
          companyId: 0,
          content: 'test Content',
          logo: Uint8List.fromList([]),
          companyName: "TestCompany",
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

      test("should return qr when the response code is 200", () async {
        final url = 'https://dev.edi.md/ISMobileDiscountService/json/GetAppNews?ID=0';
        final tresp = json.decode(fixture('list_of_news.json'));
        when(_client.get(url)).thenAnswer(
          (_) async => IsResponse(0, '', tresp),
        );

        final result = await _service.getAppNews();

        expect(result, equals(tNewsList));
      });
    });

    group('getClientInfo()', () {
      test('check if function return a profile object', () async {
        final tClientInfo = json.decode(fixture('auth_providers_credentials.json'));
        final tProfile = Profile.fromJson(tClientInfo);
        when(_service.getClientInfo()).thenAnswer((_) async => tProfile);

        final response = await _service.getClientInfo();

        expect(response, tProfile);
        verify(_service.getClientInfo());
      });
    });
    /* {
	"ErrorCode":0,
	"ErrorMessage":"String content",
	"NewsList":[{
		"AppType":0,
		"CompanyID":2147483647,
		"CompanyLogo":"String content",
		"Content":"String content",
		"CreateDate":"\/Date(928138800000+0300)\/",
		"Header":"String content",
		"ID":2147483647,
		"Photo":"String content",
		"Status":0,
		"CompanyName":"String content"
	}]
} */
    group('getCompanyList()', () {
      test('check if function return a List of Company Objects', () async {
        final tcompanyList = [
          {"Amount": "String content", "ID": 2147483647, "Logo": Uint8List.fromList([]), "Name": "String content"}
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
  });
}
