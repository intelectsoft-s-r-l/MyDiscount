import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService extends ChangeNotifier {
  SharedPref sharedPref = SharedPref();
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

      try {
        remoteConfig.fetch(expiration: const Duration(seconds: 0));
      } on FetchThrottledException catch (e) {
        throw Exception(e);
      }
      remoteConfig.activateFetched();
    } catch (e) {
      print(e);
    }
    //var data = sharedPref.saveRemote(remoteConfig.getString('list_companies'));
    return remoteConfig;
  }
}
