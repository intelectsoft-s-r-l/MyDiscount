import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:my_discount/domain/entities/company_model.dart';
import 'package:my_discount/domain/entities/news_model.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/domain/entities/user_model.dart';
import 'package:my_discount/domain/settings/settings.dart';

/// Runs some tests
///
/// 1. Opens the box
/// 2. Reads some series of values
/// 3. Writes new values
/// 4. Closes
/* Future<void> test(int index, [List<int>? key]) async {
  final boxName = 'box_$index';
  final hasKey = key != null;
  final info = '(box = $boxName, hasKey = $hasKey)';

  // open
  Box box;
  try {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.deleteBoxFromDisk(boxName);
    }
    box = await Hive.openBox(boxName,
        encryptionCipher: key != null ? HiveAesCipher(key) : null);
  } catch (error) {
    return print('Crashed! $info');
  }

  // read
  for (var i = 0; i < 100; i++) {
    final value = box.get('item_$i');
    if (value != null && value != i) {
      print('Item: item_$i Value: $value Expected: $i $info');
    }
  }

  // write
  for (var i = 0; i < 100; i++) {
    await box.put('item_$i', i);
  }

  // close
  await box.close();
  print('OK. $info');

  // await Hive.deleteBoxFromDisk(boxName);
} */
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
              boxName: boxEntry.key, key: hiveKey, storage: storage);
          break;
        case Profile:
          await _openEncriptedBox<Profile>(
              boxName: boxEntry.key, key: hiveKey, storage: storage);
          break;
        default:
      }
    }
  } catch (e, s) {
    print(e);
    //await FirebaseCrashlytics.instance.log(s.toString());
    await Hive.deleteFromDisk();
    await initDB(storage, hiveKey);
  }
}

void main() async {
  final path = '${Directory.current.path}/test/unit_test/services/db';
  final storage = const FlutterSecureStorage();
  Directory(path)
    ..deleteSync(recursive: true)
    ..createSync();
  var i = 0;
  final key = Hive.generateSecureKey();
  Hive.init(path);
  while (i < 100) {
    await initDB(storage, key);
    await Hive.close();
    /* await test(1, key); // OK
    await test(1, key); // OK
    await test(1, key); // OK, Recovering corrupted box.
    await test(1, null); */ // Crashes!
    //await Hive.close();
    print('Iteration: $i');
    i++;
  }
}

Future<void> _openEncriptedBox<T>({
  required String boxName,
  required List<int> key,
  required FlutterSecureStorage storage,
}) async {
  if (await isAppUpdated(storage)) {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.deleteBoxFromDisk(boxName);
    }
  }

  await Hive.openBox<T>(
    boxName, encryptionCipher: HiveAesCipher(key)
  );
  print('box $boxName is openned');
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
  print('box $boxName is openned');
}

Future<bool> isAppUpdated(FlutterSecureStorage storage) async {
  //const versionKey = 'versionKey';
  late String oldVersion;
  final containsKey = true;
  //final package = await PackageInfo.fromPlatform();
  final version = '2.2.2'; //package.buildNumber;
  if (containsKey) {
    oldVersion = '2.2.2';
    if (oldVersion == version) {
      return false;
    }
  }
  //await storage.write(key: versionKey, value: version);
  return true;
}
