import 'package:hive/hive.dart';
import 'package:my_discount/domain/settings/settings.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppSettings {
  final Box<Settings> settingsBox;
  AppSettings(this.settingsBox);

  Settings getSettings() {
    if (settingsBox.isNotEmpty) {
      final settings = settingsBox.get(1) as Settings;
      return settings;
    }
    return Settings(notificationEnabled: false,newsEnabled: true,locale: 'en');
  }

  void setSettings(Settings settings) {
    settingsBox.put(1, settings);
  }
}
