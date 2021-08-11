import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

import 'domain/entities/company_model.dart';
import 'domain/entities/news_model.dart';
import 'domain/entities/profile_model.dart';
import 'domain/entities/user_model.dart';
import 'domain/settings/settings.dart';

Future<void> initDB(FlutterSecureStorage storage, List<int> hiveKey) async {
  final encriptedBoxes = <String, dynamic>{'user': User, 'profile': Profile};
  final boxNameList = <String, dynamic>{
    'settings': Settings,
    'news': News,
    'company': Company,
    'locale': String
  };

  try {
    for (final boxEntry in boxNameList.entries) {
      switch (boxEntry.value) {
        case Settings:
          await _openBox<Settings>(boxName: boxEntry.key, storage: storage);

          break;
        case News:
          await _openBox<News>(boxName: boxEntry.key, storage: storage);

          break;
        case Company:
          await _openBox<Company>(boxName: boxEntry.key, storage: storage);

          break;
        case String:
          await _openBox<String>(boxName: boxEntry.key, storage: storage);

          break;
        default:
      }
    }
    for (final boxEntry in encriptedBoxes.entries) {
      switch (boxEntry.value) {
        case User:
          await _openEncriptedBox<User>(
              type: boxEntry.value,
              boxName: boxEntry.key,
              key: hiveKey,
              storage: storage);
          break;
        case Profile:
          await _openEncriptedBox<Profile>(
              type: boxEntry.value,
              boxName: boxEntry.key,
              key: hiveKey,
              storage: storage);
          break;
        default:
      }
    }
  } catch (e, s) {
    print(e);
    await FirebaseCrashlytics.instance.log(s.toString());
    await Hive.deleteFromDisk();
    await initDB(storage, hiveKey);
  }
}

Future<void> _openEncriptedBox<T>({
  required Object type,
  required String boxName,
  required List<int> key,
  required FlutterSecureStorage storage,
}) async {
  if (await isAppUpdated(storage)) {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.deleteBoxFromDisk(boxName);
    }
  }
  print(type);
  await Hive.openBox<T>(boxName, encryptionCipher: HiveAesCipher(key));
}

Future<void> _openBox<T>({
  required String boxName,
  required FlutterSecureStorage storage,
}) async {
  if (await isAppUpdated(storage)) {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.deleteBoxFromDisk(boxName);
    }
  }
  await Hive.openBox<T>(boxName);
}

Future<bool> isAppUpdated(FlutterSecureStorage storage) async {
  const versionKey = 'versionKey';
  late String oldVersion;
  final package = await PackageInfo.fromPlatform();
  final version = package.buildNumber;
  if (await storage.containsKey(key: versionKey)) {
    oldVersion = await storage.read(key: versionKey) as String;
    if (oldVersion == version) {
      return false;
    }
  }
  await storage.write(key: versionKey, value: version);
  return true;
}
