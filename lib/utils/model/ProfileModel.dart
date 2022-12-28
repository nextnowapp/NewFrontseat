import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

class ProfileModel {
  ProfileModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  dynamic message;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json['success'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
}

class Data {
  Data({
    this.userDetails,
  });

  User? userDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userDetails: User.fromJson(json['userDetails']),
      );
}

class User {
  User({
    required this.id,
    this.staffNo,
    required this.username,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.fullName,
    this.className,
    this.classId,
    this.subjectIds,
    this.subjectNames,
    required this.dateOfBirth,
    this.email,
    this.mobile,
    this.designation,
    this.designationId,
    required this.userId,
    required this.roleId,
    this.gender,
    this.genderId,
    this.photo,
    this.password,
    this.relation,
  });

  int id;
  int? staffNo;
  String username;
  String firstName;
  String? middleName;
  String lastName;
  String fullName;
  String? className;
  int? classId;
  String? subjectIds;
  List<String>? subjectNames;
  String dateOfBirth;
  String? email;
  String? mobile;
  String? designation;
  int? designationId;
  int userId;
  int roleId;
  String? gender;
  int? genderId;
  String? photo;
  String? password;
  String? relation;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        staffNo: json['staff_no'] as int?,
        username: json['username'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        fullName: json['full_name'] as String,
        middleName: json['middle_name'] as String?,
        className: json['class_name'] as String?,
        classId: json['class_id'] as int?,
        dateOfBirth: json['date_of_birth'] as String,
        email: json['email'] as String?,
        subjectIds: json['subject_ids'] as String?,
        subjectNames: json['subject_name'] == null
            ? []
            : List<String>.from(json['subject_name'] as List),
        mobile: json['mobile'] as String?,
        designation: json['designation'] as String?,
        designationId: json['designation_id'] as int?,
        userId: json['user_id'] as int,
        roleId: json['role_id'] as int,
        gender: json['gender'] as String?,
        genderId: json['gender_id'] as int?,
        photo: json['photo'] as String?,
        relation: json['relation'] as String?,
        password: json['pass'] as String?,
      );
}
