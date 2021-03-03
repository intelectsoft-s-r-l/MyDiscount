import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockRemoteConfig extends Mock implements RemoteConfig {}

void main() {
  MockRemoteConfig mockRemoteConfig;

  setUp(() {
    mockRemoteConfig = MockRemoteConfig();
  });

  test('check remoteconfig', () async {
    final tfechMap = {
      'service_name_dev': {
        'service_name': 'https://dev.edi.md/ISMobileDiscountService'
      }
    };
    when(mockRemoteConfig.lastFetchStatus)
        .thenAnswer((_) => LastFetchStatus.success);
    when(mockRemoteConfig.activateFetched()).thenAnswer((_) async => true);
    when(mockRemoteConfig.getString(any))
        .thenAnswer((_) => json.encode(tfechMap));
    mockRemoteConfig.fetch();
    bool activated = await mockRemoteConfig.activateFetched();

    final response = mockRemoteConfig.getString('service_name');
    final status = mockRemoteConfig.lastFetchStatus;
    expect(status, LastFetchStatus.success);
    mapEquals(json.decode(response) as Map<String, dynamic>, tfechMap);
    expect(activated, true);
    verify(mockRemoteConfig.lastFetchStatus);
    verify(mockRemoteConfig.fetch());
    verify(mockRemoteConfig.activateFetched());
  });
}
