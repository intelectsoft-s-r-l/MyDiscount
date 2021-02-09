import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<String> getServiceNameFromRemoteConfig() async {
  try {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    // ignore: prefer_const_constructors
    await remoteConfig.fetch(expiration: Duration(hours: 12));
    await remoteConfig.activateFetched();

    final serviceNameAsMap =
        _decodeRemoteConfigData(remoteConfig.getString('service_name_dev'));
    final String serviceName = serviceNameAsMap['service_name'] as String;
    return serviceName;
  } on FetchThrottledException {
    throw FetchThrottledException;
  } on dynamic catch (e, s) {
    FirebaseCrashlytics.instance.recordError(e, s);
  }
  return '';
}

Map<String, dynamic> _decodeRemoteConfigData(String data) {
  final decoded = json.decode(data) as Map<String, dynamic>;
  return decoded;
}
