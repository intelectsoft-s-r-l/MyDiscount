import 'dart:io';

import 'package:hive/hive.dart';

/// Runs some tests
///
/// 1. Opens the box
/// 2. Reads some series of values
/// 3. Writes new values
/// 4. Closes
Future<void> test(int index, [List<int>? key]) async {
  final boxName = 'box_$index';
  final hasKey = key != null;
  final info = '(box = $boxName, hasKey = $hasKey)';

  // open
  Box box;
  try {
    if(!Hive.isBoxOpen(boxName)){
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
}

void main() async {
  final path = '${Directory.current.path}/db';
  Directory(path)
    ..deleteSync(recursive: true)
    ..createSync();
  var i = 0;
  final key = Hive.generateSecureKey();
  Hive.init(path);
  while (i < 100) {
    await test(1, key); // OK
    await test(1, key); // OK
    await test(1, key); // OK, Recovering corrupted box.
    await test(1, null); // Crashes!
    //await Hive.close();
    print('Iteration: $i');
    i++;
  }
}
