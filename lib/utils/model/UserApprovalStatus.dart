class UserApprovalStatus {
  int? status;
  String? message;
  List<Data>? data;

  UserApprovalStatus({this.status, this.message, this.data});

  UserApprovalStatus.fromJson(Map<String, dynamic> json) {
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? lFirstName;
  String? lMiddleName;
  String? lLastName;
  String? lClass;
  String? createdAt;
  String? usedVoucher;
  int? approvalStatus;

  Data(
      {this.id,
      this.lFirstName,
      this.lMiddleName,
      this.lLastName,
      this.lClass,
      this.createdAt,
      this.usedVoucher,
      this.approvalStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lFirstName = json['l_first_name'];
    lMiddleName = json['l_middle_name'];
    lLastName = json['l_last_name'];
    lClass = json['l_class'];
    createdAt = json['created_at'];
    usedVoucher = json['used_voucher'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['l_first_name'] = this.lFirstName;
    data['l_middle_name'] = this.lMiddleName;
    data['l_last_name'] = this.lLastName;
    data['l_class_id'] = this.lClass;
    data['created_at'] = this.createdAt;
    data['used_voucher'] = this.usedVoucher;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}

class StatusList {
  List<Data> contents;

  StatusList(this.contents);

  factory StatusList.fromJson(List<dynamic> json) {
    List<Data> statusList = [];

    statusList = json.map((i) => Data.fromJson(i)).toList();

    return StatusList(statusList);
  }
}
