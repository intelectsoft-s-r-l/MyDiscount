import 'package:is_service/service_client.dart';
import 'package:is_service/service_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/core/failure.dart';
import 'package:my_discount/core/internet_connection_service.dart';
import 'package:my_discount/domain/data_source/remote_datasource.dart';

class MockNetworkConnections extends Mock implements NetworkConnection {}

class MockServiceClient extends Mock implements ServiceClient {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  MockNetworkConnections _network;

  MockRemoteDataSource remoteDataSource;

  setUp(() {
    _network = MockNetworkConnections();

    remoteDataSource = MockRemoteDataSource();
  });
  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(_network.isConnected).thenAnswer((_) async => true);
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
        });
        body();
      },
    );
  }

  final urlFragment =
      'https://dev.edi.md/ISMobileDiscountService/json/GetAppNews?ID=0';

  runTestsOnline(() async {
    test('online getRequest', () async {
      final respBody = {};
      final tResponse = IsResponse(0, '', respBody);

      when(remoteDataSource.getRequest(urlFragment))
          .thenAnswer((realInvocation) async => tResponse);

      final response = await remoteDataSource.getRequest(urlFragment);

      expect(response, tResponse);
      expect(response, isA<IsResponse>());
      verify(remoteDataSource.getRequest(urlFragment));
    });
  });
  runTestsOffline(() {
    test('offline getRequest', () async {
      when(remoteDataSource.getRequest(urlFragment))
          .thenThrow(NoInternetConection()); 
      final response = await remoteDataSource.getRequest(urlFragment);
      expect(response, throwsA(NoInternetConection()));
    });
  });
}
