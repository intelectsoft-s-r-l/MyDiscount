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
}