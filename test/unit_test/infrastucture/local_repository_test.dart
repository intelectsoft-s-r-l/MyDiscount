import 'package:my_discount/domain/repositories/local_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLocalRepositoryImpl extends Mock implements LocalRepository {}

void main() {
  MockLocalRepositoryImpl localRepozitory;

  setUp(() {
    localRepozitory = MockLocalRepositoryImpl();
  });
  final tUserProfile = {};

  test('', () async {
    when(localRepozitory.getFacebookProfile('')).thenAnswer((_) async => tUserProfile);
  });
}
