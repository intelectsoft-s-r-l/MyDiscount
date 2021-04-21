class ReceivedNotification {
  
  int? id;
  
  String? title;
  
  String? body;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
  });
  factory ReceivedNotification.fromMap(dynamic map) {
    return ReceivedNotification(
        id: map['id'] as int?,
        title: map['title'] as String?,
        body: map['body'] as String?);
  }
}
