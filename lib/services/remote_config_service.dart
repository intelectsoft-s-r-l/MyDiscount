import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String> getServiceNameFromRemoteConfig() async {
    try {
      final remoteConfig = RemoteConfig.instance;

       await remoteConfig.fetchAndActivate();

      /* if (!fetched) {
        await remoteConfig.fetchAndActivate();
      } */

      final serviceNameAsMap =
          _decodeRemoteConfigData(remoteConfig.getString('service_name_dev'));

      return serviceNameAsMap['service_name'];
    } on dynamic catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      rethrow;
    }
  }

  Map<String, dynamic> _decodeRemoteConfigData(String data) {
    final decoded = json.decode(data) as Map<String, dynamic>;
    return decoded;
  }
}
