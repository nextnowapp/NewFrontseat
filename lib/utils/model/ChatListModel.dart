class ChatListModel {
  final bool? success;
  final List<Chat>? data;
  final dynamic message;

  ChatListModel({
    this.success,
    this.data,
    this.message,
  });

  ChatListModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Chat.fromJson(e as Map<String, dynamic>))
            .toList(),
        message = json['message'];

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message
      };
}

class Chat {
  final int? id;
  final String? chatTitle;
  final String? chatMessage;
  final String? teacherName;
  final String? chatDate;
  final String? informTo;
  final int? createdBy;
  final int? activeStatus;
  final String? chatImage;
  final dynamic chatUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? time;

  Chat(
      {this.id,
      this.chatTitle,
      this.chatMessage,
      this.chatDate,
      this.informTo,
      this.createdBy,
      this.activeStatus,
      this.chatImage,
      this.chatUrl,
      this.createdAt,
      this.updatedAt,
      this.time,
      this.teacherName});

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        chatTitle = json['chat_title'] as String?,
        chatMessage = json['chat_message'] as String?,
        chatDate = json['chat_date'] as String?,
        informTo = json['inform_to'] as String?,
        createdBy = json['created_by'] as int?,
        activeStatus = json['active_status'] as int?,
        chatImage = json['chat_image'] as String?,
        chatUrl = json['chat_url'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        time = json['time'] as String?,
        teacherName = json['teacher_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'chat_title': chatTitle,
        'chat_message': chatMessage,
        'chat_date': chatDate,
        'inform_to': informTo,
        'created_by': createdBy,
        'active_status': activeStatus,
        'chat_image': chatImage,
        'chat_url': chatUrl,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'time': time,
        'teacher_name':teacherName
      };
}
