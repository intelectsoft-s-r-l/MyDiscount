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
   
  });
}
