class UserNotifications {
  UserNotifications(
      {this.id,
      this.date,
      this.message,
      this.url,
      this.createdAt,
      this.isRead,
      this.userId,
      this.routingId});

  int? id;
  String? date;
  String? message;
  String? url;
  int? userId;
  int? routingId;
  DateTime? createdAt;
  int? isRead;

  factory UserNotifications.fromJson(Map<String, dynamic> json) =>
      UserNotifications(
        id: json['id'],
        date: json['date'],
        message: json['message'],
        url: json['url'],
        createdAt: DateTime.parse(json['created_at']),
        userId: json['user_id'],
        routingId: json['routing_user_id'],
        isRead: json['is_read'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'message': message,
        'url': url == null ? null : url,
        'created_at': createdAt!.toIso8601String(),
        'is_read': isRead,
      };
}

class UserNotificationList {
  List<UserNotifications> userNotifications;

  UserNotificationList(this.userNotifications);

  factory UserNotificationList.fromJson(List<dynamic> json) {
    List<UserNotifications> uploadedContent = [];

    uploadedContent = json.map((i) => UserNotifications.fromJson(i)).toList();

    return UserNotificationList(uploadedContent);
  }
}
