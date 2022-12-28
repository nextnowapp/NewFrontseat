class VoucherListCode {
  int? status;
  String? message;
  List<Data>? data;

  VoucherListCode({this.status, this.message, this.data});

  VoucherListCode.fromJson(json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? admissionNo;
  String? firstName;
  String? lastName;
  int? classId;
  String? className;
  String? sectionId;
  String? tP1Pass;
  String? tP2Pass;
  String? parent1Name;
  String? parent1MiddleName;
  String? parent1LastName;
  String? parent2Name;
  String? parent2MiddleName;
  String? parent2LastName;

  Data(
      {this.admissionNo,
      this.firstName,
      this.lastName,
      this.classId,
      this.className,
      this.sectionId,
      this.tP1Pass,
      this.tP2Pass,
      this.parent1Name,
      this.parent1MiddleName,
      this.parent1LastName,
      this.parent2Name,
      this.parent2MiddleName,
      this.parent2LastName});

  Data.fromJson(Map<String, dynamic> json) {
    admissionNo = json['admission_no'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    classId = json['class_id'];
    className = json['class_name'];
    tP1Pass = json['t_p1_pass'];
    tP2Pass = json['t_p2_pass'];
    parent1Name = json['parent_1_name'];
    parent1MiddleName = json['parent1_middle_name'];
    parent1LastName = json['parent1_last_name'];
    parent2Name = json['parent2_name'];
    parent2MiddleName = json['parent2_middle_name'];
    parent2LastName = json['parent2_last_name'];
  }
}
