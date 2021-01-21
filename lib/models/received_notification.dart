class ReceivedNotification {
  
  int id;
  
  String title;
  
  String body;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
  });
  factory ReceivedNotification.fromMap(dynamic map) {
    return ReceivedNotification(
        id: map['id'], title: map['title'], body: map['body']);
  }
}
