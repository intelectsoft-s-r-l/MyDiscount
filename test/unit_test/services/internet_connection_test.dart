import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/core/internet_connection_service.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker _internetChecker;
  late NetworkConnectionImpl _networkConnection;
  setUp(() {
    _internetChecker = MockInternetConnectionChecker();
    _networkConnection =
        NetworkConnectionImpl(connectionChecker: _internetChecker);
  });

  group('check internet connection', () {
    test('should forward the call DataConnectionChecker.hasConnection',
        () async {
      //final hasConnection = Future.value(true);
      when(_internetChecker.hasConnection).thenAnswer((_)async => true/* hasConnection */);
      final result = await _networkConnection.isConnected;
      verify(_networkConnection.isConnected);
      expect(result, true);
    });
  });
}
