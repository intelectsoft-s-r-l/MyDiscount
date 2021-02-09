import 'package:hive/hive.dart';

part 'received_notification.g.dart';

@HiveType(typeId: 0)
class ReceivedNotification {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String body;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
  });
  factory ReceivedNotification.fromMap(dynamic map) {
    return ReceivedNotification(
        id: map['id'] as int,
        title: map['title'] as String,
        body: map['body'] as String);
  }
}
