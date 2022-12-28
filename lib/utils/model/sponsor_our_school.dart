class SponsorOurSchoolModel {
  final bool? success;
  final List<SponsorOurSchool>? data;
  final String? message;

  SponsorOurSchoolModel({
    this.success,
    this.data,
    this.message,
  });

  SponsorOurSchoolModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                SponsorOurSchool.fromJson(e as Map<String, dynamic>))
            .toList(),
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message
      };
}

class SponsorOurSchool {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? message;
  final String? location;
  final String? date;
  final String? time;

  SponsorOurSchool(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.message,
      this.location,
      this.date,
      this.time});

  SponsorOurSchool.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['full_name'] ?? '',
        email = json['email'] ?? '',
        mobile = json['phone'] ?? '',
        message = json['message'] ?? '',
        location = json['address'] ?? '',
        date = json['date'] ?? '',
        time = json['time'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'message': message,
        'location': location,
        'contact_date': date,
        'time': time
      };
}
