import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkConnectionImpl networkConnectionImpl;
  MockDataConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    //networkConnectionImpl =
      //  NetworkConnectionImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('check internet connection', () {
    test('should forward the call DataConnectionChecker.hasConnection',
        () async {
      final hasConnection = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => hasConnection);
      final result = networkConnectionImpl.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, hasConnection);
    });
  });
}
