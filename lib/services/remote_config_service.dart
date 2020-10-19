import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future getServiceName() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  /* final defaults = <String, dynamic>{
    'default': 'https://api.edi.md/ISMobileDiscountService'
  }; */
  //await remoteConfig.setDefaults(defaults);
  //var def = remoteConfig.getString('default');
  try {
    await remoteConfig.fetch(expiration: Duration(hours: 12));
    await remoteConfig.activateFetched();
    final dat = remoteConfig.getString('service_name');
    final map = json.decode(dat) as Map;
    final data = map['service_name'];
    print('welcome message: ' + remoteConfig.getString('service_name'));
    return data;
  } on FetchThrottledException {
   // return def;
    throw FetchThrottledException;
  } catch (e,s) {
   FirebaseCrashlytics.instance.recordError(e, s);
    //print('default');
   // return def;
  }
}
