class UserApprovalDetails {
  int? status;
  String? message;
  List<Data>? data;

  UserApprovalDetails({this.status, this.message, this.data});

  UserApprovalDetails.fromJson(Map<String, dynamic> json) {
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
  String? usedVoucher;
  String? approvalRequestId;
  String? admissionNo;
  String? learnerId;
  String? requestForParent;
  String? lFirstName;
  String? lMiddleName;
  String? lLastName;
  String? lClassId;
  String? lSectionId;
  String? lGrade;
  String? lClass;
  String? lGender;
  String? lDob;
  String? lNid;
  String? lEmail;
  String? lMobile;
  String? p1FirstName;
  String? p1MiddleName;
  String? p1LastName;
  String? p1Dob;
  String? p1Mobile;
  String? p1Email;
  String? p1Nid;
  String? p1Occupation;
  String? p1Relation;
  String? p1Address;
  String? p1Pass;
  String? p2FirstName;
  String? p2MiddleName;
  String? p2LastName;
  String? p2Dob;
  String? p2Mobile;
  String? p2Email;
  String? p2Nid;
  String? p2Occupation;
  String? p2Relation;
  String? p2Address;
  String? p2Pass;
  int? approvalStatus;
  String? comments;
  String? academicId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.usedVoucher,
      this.approvalRequestId,
      this.admissionNo,
      this.learnerId,
      this.requestForParent,
      this.lFirstName,
      this.lMiddleName,
      this.lLastName,
      this.lClassId,
      this.lSectionId,
      this.lGrade,
      this.lClass,
      this.lGender,
      this.lDob,
      this.lNid,
      this.lEmail,
      this.lMobile,
      this.p1FirstName,
      this.p1MiddleName,
      this.p1LastName,
      this.p1Dob,
      this.p1Mobile,
      this.p1Email,
      this.p1Nid,
      this.p1Occupation,
      this.p1Relation,
      this.p1Address,
      this.p1Pass,
      this.p2FirstName,
      this.p2MiddleName,
      this.p2LastName,
      this.p2Dob,
      this.p2Mobile,
      this.p2Email,
      this.p2Nid,
      this.p2Occupation,
      this.p2Relation,
      this.p2Address,
      this.p2Pass,
      this.approvalStatus,
      this.comments,
      this.academicId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usedVoucher = json['used_voucher'];
    approvalRequestId = json['approval_request_id'];
    admissionNo = json['admission_no'];
    learnerId = json['learner_id'];
    requestForParent = json['request_for_parent'];
    lFirstName = json['l_first_name'];
    lMiddleName = json['l_middle_name'];
    lLastName = json['l_last_name'];
    lClassId = json['l_class_id'];
    lSectionId = json['l_section_id'];
    lGrade = json['l_grade'];
    lClass = json['l_class'];
    lGender = json['l_gender'];
    lDob = json['l_dob'];
    lNid = json['l_nid'];
    lEmail = json['l_email'];
    lMobile = json['l_mobile'];
    p1FirstName = json['p1_first_name'];
    p1MiddleName = json['p1_middle_name'];
    p1LastName = json['p1_last_name'];
    p1Dob = json['p1_dob'];
    p1Mobile = json['p1_mobile'];
    p1Email = json['p1_email'];
    p1Nid = json['p1_nid'];
    p1Occupation = json['p1_occupation'];
    p1Relation = json['p1_relation'];
    p1Address = json['p1_address'];
    p1Pass = json['p1_pass'];
    p2FirstName = json['p2_first_name'];
    p2MiddleName = json['p2_middle_name'];
    p2LastName = json['p2_last_name'];
    p2Dob = json['p2_dob'];
    p2Mobile = json['p2_mobile'];
    p2Email = json['p2_email'];
    p2Nid = json['p2_nid'];
    p2Occupation = json['p2_occupation'];
    p2Relation = json['p2_relation'];
    p2Address = json['p2_address'];
    p2Pass = json['p2_pass'];
    approvalStatus = json['approval_status'];
    comments = json['comments'];
    academicId = json['academic_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['used_voucher'] = this.usedVoucher;
    data['approval_request_id'] = this.approvalRequestId;
    data['admission_no'] = this.admissionNo;
    data['learner_id'] = this.learnerId;
    data['request_for_parent'] = this.requestForParent;
    data['l_first_name'] = this.lFirstName;
    data['l_middle_name'] = this.lMiddleName;
    data['l_last_name'] = this.lLastName;
    data['l_class_id'] = this.lClassId;
    data['l_section_id'] = this.lSectionId;
    data['l_grade'] = this.lGrade;
    data['l_class'] = this.lClass;
    data['l_gender'] = this.lGender;
    data['l_dob'] = this.lDob;
    data['l_nid'] = this.lNid;
    data['l_email'] = this.lEmail;
    data['l_mobile'] = this.lMobile;
    data['p1_first_name'] = this.p1FirstName;
    data['p1_middle_name'] = this.p1MiddleName;
    data['p1_last_name'] = this.p1LastName;
    data['p1_dob'] = this.p1Dob;
    data['p1_mobile'] = this.p1Mobile;
    data['p1_email'] = this.p1Email;
    data['p1_nid'] = this.p1Nid;
    data['p1_occupation'] = this.p1Occupation;
    data['p1_relation'] = this.p1Relation;
    data['p1_address'] = this.p1Address;
    data['p1_pass'] = this.p1Pass;
    data['p2_first_name'] = this.p2FirstName;
    data['p2_middle_name'] = this.p2MiddleName;
    data['p2_last_name'] = this.p2LastName;
    data['p2_dob'] = this.p2Dob;
    data['p2_mobile'] = this.p2Mobile;
    data['p2_email'] = this.p2Email;
    data['p2_nid'] = this.p2Nid;
    data['p2_occupation'] = this.p2Occupation;
    data['p2_relation'] = this.p2Relation;
    data['p2_address'] = this.p2Address;
    data['p2_pass'] = this.p2Pass;
    data['approval_status'] = this.approvalStatus;
    data['comments'] = this.comments;
    data['academic_id'] = this.academicId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}