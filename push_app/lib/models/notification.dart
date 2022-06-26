class NotificationModel {
  late int id;
  late String userId;
  late String title;
  late String content;
  late DateTime receivedTime;
  late String notificationId;
  late dynamic sentTime;

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
    if (json.containsKey("sent_time")) {
      sentTime = DateTime.fromMicrosecondsSinceEpoch(json['sent_time']);
    } else {
      sentTime = "None";
    }
  }
}
