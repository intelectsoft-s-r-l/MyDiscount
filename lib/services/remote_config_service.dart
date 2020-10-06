import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

Future getServiceName() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  final defaults = <String, dynamic>{
    'default': 'http://api.edi.md/ISMobileDiscountService'
  };
  await remoteConfig.setDefaults(defaults);
  var def = remoteConfig.getString('default');
  try {
    await remoteConfig.fetch(expiration: Duration(seconds: 1));
    await remoteConfig.activateFetched();
    final dat = remoteConfig.getString('service_name');
    final map = json.decode(dat) as Map;
    final data = map['service_name'];
    print('welcome message: ' + remoteConfig.getString('service_name'));
    return data;
  } on FetchThrottledException {
    throw FetchThrottledException;
  } catch (e) {
    print('default');
    return def;
  }
}
