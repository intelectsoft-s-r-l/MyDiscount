import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String> getServiceNameFromRemoteConfig() async {
    Duration _duration;
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;

      if (remoteConfig.lastFetchStatus == LastFetchStatus.success) {
        _duration = Duration(hours: 12);
      } else if (remoteConfig.lastFetchStatus == LastFetchStatus.noFetchYet) {
        _duration = Duration(seconds: 1);
      }

      await remoteConfig.fetch(expiration: _duration);
      await remoteConfig.activateFetched();

      final serviceNameAsMap = _decodeRemoteConfigData(remoteConfig.getString('service_name_dev'));

      return serviceNameAsMap['service_name'];
    } on FetchThrottledException {
      throw FetchThrottledException;
    } on dynamic catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      rethrow;
    }
  }

  Map<String, dynamic> _decodeRemoteConfigData(String data) {
    final decoded = json.decode(data) as Map<String, dynamic>;
    return decoded;
  }
}
