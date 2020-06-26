

import 'package:firebase_remote_config/firebase_remote_config.dart';


const  _ShowList = "list_companies";

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
 var  defaults = <String,dynamic> {"companies": [
    {
      "image": "https://edi.md/androidapps/assets/vento_logo.png",
      "name": "Vento",
      "active": true,
      "id": 150
    },
    {
      "image": "https://edi.md/androidapps/assets/bemol_logo.png",
      "name": "Bemol",
      "active": true,
      "id": 151
    },
    {
      "image": "https://edi.md/androidapps/assets/rompetrol_logo.png",
      "name": "RomPetrol",
      "active": true,
      "id": 152
    },
    {
	  "image": "https://edi.md/androidapps/assets/tirex_logo.png",
      "name": "Tirex",
      "active": false,
      "id": 153
    }
  ]} ;

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }
    return _instance;
  }

  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  String get showList => _remoteConfig.getString(_ShowList);

  getString() async {
   _remoteConfig.getString("list_companies");
   await _fetchAndActivate();
 }
   
  Future initialise() async {
    try {
      await _remoteConfig.setDefaults(defaults);
     _remoteConfig.getString('list_companies') ;
      await _fetchAndActivate();
    } on FetchThrottledException catch (e) {
      print('Remote config fetch throttled: $e');
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activateFetched();
  }
}
