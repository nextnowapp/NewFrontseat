class Birthdays {
  bool? success;
  List<Data>? data;
  String? message;

  Birthdays({this.success, this.data, this.message});

  Birthdays.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? firstName;
  String? dateOfBirth;
  String? bdayTotalRemainingDays;

  Data({this.firstName, this.dateOfBirth, this.bdayTotalRemainingDays});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['full_name'];
    dateOfBirth = json['birthday'];
    bdayTotalRemainingDays = json['remaning_days'];
  }
}
