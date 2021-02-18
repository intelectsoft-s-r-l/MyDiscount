import 'dart:typed_data';

import 'package:IsService/service_client.dart';
import 'package:MyDiscount/core/formater.dart';
import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:MyDiscount/infrastructure/is_service_impl.dart';
import 'package:MyDiscount/infrastructure/local_repository_impl.dart';
import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockInternetConnection extends Mock implements NetworkConnectionImpl {}

class MockServiceClient extends Mock implements ServiceClient {}

class MockFormater extends Mock implements Formater {}

class MockLocalRepository extends Mock implements LocalRepositoryImpl {}

void main1() {
  TestWidgetsFlutterBinding.ensureInitialized();
  IsServiceImpl _service;
  MockInternetConnection _inet;
  MockServiceClient _client;
  MockFormater _formater;
  MockLocalRepository _localRepository;

  setUp(() {
    _inet = MockInternetConnection();
    _client = MockServiceClient();
    _formater = MockFormater();
    _localRepository = MockLocalRepository();
    _service = IsServiceImpl(
      _client,
      _inet,
      _localRepository,
      _formater,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(_inet.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('getAppNews', () {
    test('check if device is online', () {
      when(_inet.isConnected).thenAnswer((_) async => true);

      _service.getAppNews();

      verify(_inet.isConnected);
    });
  });

  runTestsOnline(() {
    test('check if function return a list of news', () async {
      final newsList = [
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
      when(_service.getAppNews()).thenAnswer((_) async => newsList);

      final response = await _service.getAppNews();

      expect(response, newsList);
    });
  });
}
