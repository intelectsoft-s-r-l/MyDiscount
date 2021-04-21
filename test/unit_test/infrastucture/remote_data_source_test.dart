import 'package:is_service/service_client.dart';
import 'package:is_service/service_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/core/failure.dart';
import 'package:my_discount/core/internet_connection_service.dart';
import 'package:my_discount/domain/data_source/remote_datasource.dart';
import 'package:my_discount/infrastructure/remote_datasource_impl.dart/remote_datasource_impl.dart';
import 'package:my_discount/services/remote_config_service.dart';

class MockNetworkConnections extends Mock implements NetworkConnection {}

class MockServiceClient extends Mock implements ServiceClient {}

class MockRemoteConfig extends Mock implements RemoteConfigService {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockNetworkConnections _network;

  late MockRemoteConfig _mockRemoteConfig;

  late MockServiceClient _client;

  /* Mock */ late RemoteDataSourceImpl remoteDataSource;

  setUp(() {
    _network = MockNetworkConnections();
    _client = MockServiceClient();
    _mockRemoteConfig = MockRemoteConfig();

    remoteDataSource = /* Mock */ RemoteDataSourceImpl(
        _client, _mockRemoteConfig, _network);
  });
  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(_network.isConnected).thenAnswer((_) async => true);
          when(_mockRemoteConfig.getServiceNameFromRemoteConfig()).thenAnswer(
              (realInvocation) async =>
                  'https://dev.edi.md/ISMobileDiscountService');
        });
        body();
      },
    );
  }

  void runTestsOffline(Function body) {
    group(
      'device is offline',
      () {
        setUp(() {
          when(_network.isConnected)
              .thenAnswer((realInvocation) async => false);
          when(_mockRemoteConfig.getServiceNameFromRemoteConfig()).thenAnswer(
              (realInvocation) async =>
                  'https://dev.edi.md/ISMobileDiscountService');
        });
        body();
      },
    );
  }

  final urlFragment =
      'https://dev.edi.md/ISMobileDiscountService/json/GetAppNews?ID=0';
  final purlFragment =
      'https://dev.edi.md/ISMobileDiscountService/json/UpdateClientInfo';
  final tUrlFragment = '/json/GetAppNews?ID=0';
  final tpUrlFragment = '/json/UpdateClientInfo';
  final tJson = <String, dynamic>{};

  final respBody = {};
  final tResponse = IsResponse(0, '', respBody);

  runTestsOnline(() async {
    test('online getRequest', () async {
      when(_client.get(urlFragment)).thenAnswer((_) async => tResponse);

      final response = await remoteDataSource.getRequest(tUrlFragment);

      expect(response, tResponse);
      expect(response, isA<IsResponse>());
    });
    test('online postRequest', () async {
      when(_client.post(purlFragment, tJson))
          .thenAnswer((realInvocation) async => tResponse);

      final response = await remoteDataSource.postRequest(
          urlFragment: tpUrlFragment, json: tJson);

      expect(response, tResponse);
    });
  });

  runTestsOffline(() {
    test('offline getRequest', () async {
      when(_client.get(urlFragment)).thenThrow(NoInternetConection());

      final response = remoteDataSource.getRequest(tUrlFragment);

      expect(response, throwsException);
    });
    test('offline postRequest', () async {
      when(_client.post(purlFragment, tJson)).thenThrow(NoInternetConection());

      final response = remoteDataSource.getRequest(tUrlFragment);

      expect(response, throwsException);
    });
  });
}
