import 'package:MyDiscount/core/internet_connection_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements NetworkConnection {}

void main() {
  MockDataConnectionChecker networkConnectionImpl;
 
  setUp(() {
   // mockDataConnectionChecker = NetworkConnection();
    networkConnectionImpl = MockDataConnectionChecker();
  });

  group('check internet connection', () {
    test('should forward the call DataConnectionChecker.hasConnection', () async {
      final hasConnection = Future.value(true);
      when(networkConnectionImpl.isConnected).thenAnswer((_) => hasConnection);
      final result = networkConnectionImpl.isConnected;
      verify(networkConnectionImpl.isConnected);
      expect(result, hasConnection);
    });
  });
}
