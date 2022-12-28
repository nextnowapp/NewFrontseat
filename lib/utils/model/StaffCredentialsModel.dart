class StaffCredentialsModel {
  final bool? success;
  final List<StaffCredential>? data;
  final String? message;

  StaffCredentialsModel({
    this.success,
    this.data,
    this.message,
  });

  StaffCredentialsModel.fromJson(Map<String, dynamic> json)
    : success = json['success'] as bool?,
      data = (json['data'] as List?)?.map((dynamic e) => StaffCredential.fromJson(e as Map<String,dynamic>)).toList(),
      message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'data' : data?.map((e) => e.toJson()).toList(),
    'message' : message
  };
}

class StaffCredential {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? staffPhoto;
  final String? password;
  final String? className;
  final String? dateOfBirth;
 bool? isObscure = false;

  StaffCredential({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.staffPhoto,
    this.password,
    this.className,
    this.dateOfBirth,
    this.isObscure
  });

  StaffCredential.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      fullName = json['full_name'] as String?,
      staffPhoto = json['staff_photo'] as String?,
      password = json['password'] as String?,
      className = json['class_name'] as String?,
      dateOfBirth = json['date_of_birth'] as String?,
      isObscure = false;


  Map<String, dynamic> toJson() => {
    'id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'full_name' : fullName,
    'staff_photo' : staffPhoto,
    'password' : password,
    'class_name' : className,
    'date_of_birth' : dateOfBirth
  };
}