import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/infrastructure/core/internet_connection_service.dart';

import 'internet_connection_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkConnectionImpl _networkConnection;
  setUp(() {});

  group('check internet connection', () {
    test('should forward the call DataConnectionChecker.hasConnection',
        () async {
      final _internetChecker = MockInternetConnectionChecker();
      _networkConnection =
          NetworkConnectionImpl(connectionChecker: _internetChecker);
      //final hasConnection = Future.value(true);
      when(_internetChecker.hasConnection)
          .thenAnswer((_) async => true /* hasConnection */);
      final result = await _networkConnection.isConnected;
      verify(_networkConnection.isConnected);
      expect(result, true);
    });
  });
}
