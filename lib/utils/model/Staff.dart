class Staff {
  int userId;
  int id;
  int staffId;
  String name;
  String username;
  String fullName;
  String firstName;
  String? middleName;
  String lastName;
  String dob;
  String? email;
  String? phone;
  String? designation;
  String? className;
  int? classId;
  String? nid;
  String? subjectIds;
  List<String>? subjectNames;
  String? gender;
  int? genderId;
  int? designationId;
  String? qualification;
  String? currentAddress;
  String? maritalStatus;
  String? dateOfJoining;
  String? photo;
  int? roleId;

  Staff({
    required this.userId,
    required this.username,
    required this.id,
    required this.staffId,
    required this.fullName,
    required this.firstName,
    required this.name,
    this.middleName,
    required this.lastName,
    this.designation,
    this.classId,
    this.className,
    this.subjectIds,
    this.qualification,
    this.currentAddress,
    this.maritalStatus,
    this.dateOfJoining,
    this.phone,
    this.photo,
    this.designationId,
    this.subjectNames,
    required this.dob,
    this.email,
    this.roleId,
    this.gender,
    this.genderId,
    this.nid,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      userId: json['staff_user_id'] as int,
      id: json['staff_id'],
      username: json['username'],
      staffId: json['staff_no'],
      name: json['full_name'],
      fullName: json['full_name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      dob: json['date_of_birth'],
      email: json['email'],
      phone: json['mobile'],
      designation: json['designation'],
      className: json['selected_class'],
      nid: json['staff_nid'],
      subjectIds: json['subject_ids'],
      gender: json['gender'],
      subjectNames: json['selected_subjects'] == null
          ? null
          : List<String>.from(json['selected_subjects'] as List),
      classId: json['class_id'],
      roleId: json['role_id'],
      designationId: json['designation_id'],
      photo: json['staff_photo'],
      genderId: json['gender_id'],
    );
  }
}

class StaffList {
  List<Staff> staffs;

  StaffList(this.staffs);

  factory StaffList.fromJson(List<dynamic> json) {
    List<Staff> staffList = [];

    staffList = json.map((i) => Staff.fromJson(i)).toList();
    return StaffList(staffList);
  }
}
