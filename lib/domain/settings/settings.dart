import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 4)
class Settings {
  @HiveField(0)
  bool notificationEnabled = false;
  @HiveField(1)
  bool newsEnabled = true;
  @HiveField(2)
  String locale = 'en';

  Settings({
    required this.notificationEnabled,
    required this.newsEnabled,
    required this.locale,
  });

  Settings copyWith({
    bool? notificationEnabled,
    bool? newsEnabled,
    String? locale,
  }) {
    return Settings(
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        newsEnabled: newsEnabled ?? this.newsEnabled,
        locale: locale ?? this.locale);
  }
}
