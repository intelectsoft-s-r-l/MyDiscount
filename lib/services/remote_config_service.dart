import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

/* class RemoteConfigService { */
Future getServiceName() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  //final defaults = <String, dynamic>{'welcome': 'default welcome'};
  // await remoteConfig.setDefaults(defaults);

  await remoteConfig.fetch(expiration: const Duration(hours: 5));
  await remoteConfig.activateFetched();
  final dat = remoteConfig.getString('service_name');
  final map = json.decode(dat) as Map;
  final data = map['service_name'];
  print('welcome message: ' + remoteConfig.getString('service_name'));
  return data;
}
/* } */
