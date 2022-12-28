class LeaveAdmin {
  int? id;
  int? staffId;
  String? applyDate;
  String? leaveFrom;
  String? leaveTo;
  String? reason;
  String? status;
  String? type;
  String? file;
  String? class_name;
  String? section_name;
  String? roll_no;
  String? total_leave_days;
  String? student_photo;
  String? fullName;

  LeaveAdmin(
      {this.id,
      this.staffId,
      this.applyDate,
      this.leaveFrom,
      this.leaveTo,
      this.reason,
      this.status,
      this.type,
      this.file,
      this.fullName,
      this.student_photo,
      this.section_name,
      this.roll_no,
      this.class_name,
      this.total_leave_days});

  factory LeaveAdmin.fromJson(Map<String, dynamic> json) {
    return LeaveAdmin(
      id: json['id'],
      staffId: json['staff_id'],
      applyDate: json['apply_date'],
      leaveFrom: json['leave_from'],
      leaveTo: json['leave_to'],
      status: json['approve_status'],
      reason: json['reason'],
      type: json['type'],
      file: json['file'],
      student_photo:
          json['student_photo'] ?? 'public/uploads/staff/demo/staff.jpg',
      section_name: json['section_name'] ?? '',
      roll_no: (json['roll_no'] ?? '').toString(),
      class_name: json['class_name'] ?? '',
      total_leave_days: (json['total_leave_days']).toString(),
      fullName: json['full_name'],
    );
  }
}

class LeaveAdminList {
  List<LeaveAdmin> leaves;

  LeaveAdminList(this.leaves);

  factory LeaveAdminList.fromJson(List<dynamic> json) {
    List<LeaveAdmin> leaveList = [];

    leaveList = json.map((i) => LeaveAdmin.fromJson(i)).toList();

    return LeaveAdminList(leaveList);
  }
}
