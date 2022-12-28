class WebsiteMessagesModel {
  final bool? success;
  final List<WebsiteMessages>? data;
  final String? message;

  WebsiteMessagesModel({
    this.success,
    this.data,
    this.message,
  });

  WebsiteMessagesModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                WebsiteMessages.fromJson(e as Map<String, dynamic>))
            .toList(),
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message
      };
}

class WebsiteMessages {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? message;
  final String? date;
  final String? time;

  WebsiteMessages(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.message,
      this.date,
      this.time});

  WebsiteMessages.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        mobile = json['mobile'] as String?,
        message = json['message'] as String?,
        date = json['contact_date'] as String?,
        time = json['time'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'message': message,
        'contact_date': date,
        'time': time
      };
}
