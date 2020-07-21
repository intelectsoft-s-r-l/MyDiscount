import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService extends ChangeNotifier {
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

    remoteConfig.fetch(expiration: const Duration(seconds: 0));
    remoteConfig.activateFetched();

    return remoteConfig;
  }
}
