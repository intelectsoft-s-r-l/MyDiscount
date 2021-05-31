import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final remoteConfig = RemoteConfig.instance;

  void _fetchAndActivateRemoteConfigData() async {
    await remoteConfig.fetchAndActivate();
    print('remoteConfig fetch');
  }

  Future<String> getServiceNameFromRemoteConfig() async {
    try {
      /*   remoteConfig.addListener(() { */
      //_fetchAndActivateRemoteConfigData();
      final minimumInterval = remoteConfig.lastFetchStatus ==
                  RemoteConfigFetchStatus.noFetchYet ||
              remoteConfig.lastFetchStatus == RemoteConfigFetchStatus.failure
          ? const Duration(seconds: 1)
          : const Duration(hours: 12);
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 12),
          minimumFetchInterval: minimumInterval));
      /*    }); */

      if (remoteConfig.lastFetchTime
          .add(const Duration(hours: 12))
          .isBefore(DateTime.now())) {
        _fetchAndActivateRemoteConfigData();
        print('last fetch time');
      }

      return _decodeRemoteConfigData(
          remoteConfig.getString('service_name_dev'))['service_name'];
      //serviceNameAsMap['service_name'];
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      rethrow;
    }
  }

  Map<String, dynamic> _decodeRemoteConfigData(String data) {
    final decoded = json.decode(data) as Map<String, dynamic>;
    return decoded;
  }
}
