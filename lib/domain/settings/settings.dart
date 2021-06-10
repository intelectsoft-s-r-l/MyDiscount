import 'package:hive/hive.dart';

part 'settings.g.dart';

/// Use this class to manage aplication settings of news and push notification
@HiveType(typeId: 4)
class Settings {
  @HiveField(0)

  /// Parameter of push notification settings (true/false)
  /// On false, the `FCM` the token will not be valid if it was requested or will
  ///  not be requested in other case
  bool notificationEnabled;
  @HiveField(1)

  /// Parameter of news settings (true/false)
  /// On false, when open the News Page, all the news from database will be 
  /// deleted
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
