import 'package:hive/hive.dart';
import 'package:my_discount/domain/settings/settings.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppSettings {
  final Box<Settings> _settingsBox;
  AppSettings(this._settingsBox);

  Settings getSettings() {
    if (_settingsBox.isNotEmpty) {
      final settings = _settingsBox.get(1) as Settings;
      return settings;
    }
    return Settings(notificationEnabled: false,newsEnabled: true,);
  }

  void setSettings(Settings settings) {
    _settingsBox.put(1, settings);
  }
}
