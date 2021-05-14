import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 4)
class Settings {
  @HiveField(0)
  bool notificationEnabled;
  @HiveField(1)
  bool newsEnabled;

  Settings({
    required this.notificationEnabled,
    required this.newsEnabled,
  });

  Settings copyWith({
    bool? notificationEnabled,
    bool? newsEnabled,
    String? locale,
  }) {
    return Settings(
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      newsEnabled: newsEnabled ?? this.newsEnabled,
    );
  }
}
