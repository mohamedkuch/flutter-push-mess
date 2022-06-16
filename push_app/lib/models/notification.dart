class NotificationModel {
  late int id;
  late String userId;
  late String title;
  late String content;
  late DateTime receivedTime;
  late String notificationId;
  late DateTime sentTime;

  NotificationModel(
    this.id,
    this.userId,
    this.title,
    this.content,
    this.receivedTime,
    this.notificationId,
    this.sentTime,
  );

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    receivedTime = DateTime.parse(json['received_time']);
    notificationId = json['notification_id'];
    sentTime = DateTime.fromMicrosecondsSinceEpoch(json['sent_time']);
  }
}
