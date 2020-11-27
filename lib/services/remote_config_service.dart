import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<String> getServiceNameFromRemoteConfig() async {
  try {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(hours: 12));
    await remoteConfig.activateFetched();
    final String dataFromRemoteConfig = remoteConfig.getString('service_name');
    final serviceNameAsMap = _decodeRemoteConfigData(dataFromRemoteConfig);
    final String serviceNameToString = serviceNameAsMap['service_name'];

    return serviceNameToString;
  } on FetchThrottledException {
    throw FetchThrottledException;
  } catch (e, s) {
    FirebaseCrashlytics.instance.recordError(e, s);
  }
  return '';
}

Map<String, dynamic> _decodeRemoteConfigData(data) {
  final Map<String, dynamic> serviceNameAsMap = json.decode(data);
  return serviceNameAsMap;
}
