import 'package:is_service/service_client.dart';
import 'package:is_service/service_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/core/internet_connection_service.dart';
import 'package:my_discount/infrastructure/remote_datasource_impl.dart/remote_datasource_impl.dart';

class MockNetworkConnections extends Mock implements NetworkConnection {}

class MockServiceClient extends Mock implements ServiceClient {}

void main() {
  MockNetworkConnections _network;
  //MockServiceClient _client;
  RemoteDataSourceImpl remoteDataSource;

  setUp(() {
    _network = MockNetworkConnections();
   //_client = MockServiceClient();
    //remoteDataSource = RemoteDataSourceImpl(_client, _network);
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
  /*  void runTestsOffline(Function body) {
    group(
      'device is offline',
      () {
        setUp(() {
          when(_network.isConnected).thenAnswer((_) async => false);
        });
        body();
      },
    );
  } */

  runTestsOnline(() async {
    test('getRequest', () async {
      final respBody = {};
      final tResponse = IsResponse(0, '', respBody);
      final urlFragment =
          'https://dev.edi.md/ISMobileDiscountService/json/GetAppNews?ID=0';

      when(remoteDataSource.getRequest(urlFragment))
          .thenAnswer((realInvocation) async => tResponse);

      final response = await remoteDataSource.getRequest(urlFragment);

      expect(response, tResponse);
      //verify(remoteDataSource.getRequest(urlFragment));
    });
  });
}
