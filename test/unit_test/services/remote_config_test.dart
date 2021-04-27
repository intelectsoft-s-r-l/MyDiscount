import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockRemoteConfig extends Mock implements RemoteConfig {}

void main() {
     MockRemoteConfig mockRemoteConfig;

    mockRemoteConfig = MockRemoteConfig();
  setUp(() {
  });
  test('check remoteconfig', () async {
    final tfechMap = {
      'service_name_dev': {
        'service_name': 'https://dev.edi.md/ISMobileDiscountService'
      }
    };
    final tString = json.encode(tfechMap);
    when(mockRemoteConfig.fetchAndActivate())
        .thenAnswer((realInvocation) async => true);
    final resp = await mockRemoteConfig.fetchAndActivate();
    expect(resp, equals(true));
    when(mockRemoteConfig.getString('service_name_dev'))
        .thenAnswer((_) => tString);
    final response = mockRemoteConfig.getString('service_name_dev');
    final decodedResp = json.decode(response);
    expect(response, equals(tString));
    expect(decodedResp, equals(tfechMap));
  });
}
