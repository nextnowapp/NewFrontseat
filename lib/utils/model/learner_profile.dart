class LearnerProfile {
  bool? success;
  Data? data;
  var message;

  LearnerProfile({this.success, this.data, this.message});

  LearnerProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = Data.fromJson(json['data']);
    message = json['message'];
  }
}

class Data {
  UserDetails? userDetails;
  ParentLoginDetails? parentLoginDetails;

  Data({
    this.userDetails,
    this.parentLoginDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userDetails: UserDetails.fromJson(json['userDetails']),
        parentLoginDetails:
            ParentLoginDetails.fromJson(json['parentLoginDetails']),
      );
}

class UserDetails {
  int studId;
  int id;
  String username;
  int admissionNo;
  int rollNo;
  int classId;
  int userId;
  int roleId;
  int? genderId;
  int? schoolId;
  int? academicId;
  String firstName;
  String? middleName;
  String lastName;
  String fullName;
  String dateOfBirth;
  String? email;
  String? mobile;
  String? admissionDate;
  String? studentPhoto;
  int age;
  String? height;
  String? weight;
  String? currentAddress;
  String? permanentAddress;
  String? nationalIdNo;
  String? documentTitle1;
  String? documentFile1;
  String? documentTitle2;
  String? documentFile2;
  String? documentTitle3;
  String? documentFile3;
  String? documentTitle4;
  String? documentFile4;
  String className;
  String? gender;
  String? districtID;
  String? circuitID;
  String parent1Name;
  String parent1FirstName;
  String? parent1Email;
  String? parent1Phone;
  String? parent1MiddleName;
  String parent1LastName;
  String? parent1Nid;
  String? parent1Photo;
  String? parent1Occupation;
  String? parent1Relation;
  String? parent1Address;
  String parent1Dob;
  String? parent2Name;
  String? parent2Email;
  String? parent2Phone;
  String? parent2Nid;
  String? parent2Photo;
  String? parent2Occupation;
  String? parent2Relation;
  String? parent2Address;
  String? parent2FirstName;
  String? parent2MiddleName;
  String? parent2LastName;
  String? parent2Dob;

  UserDetails({
    required this.studId,
    required this.id,
    required this.admissionNo,
    required this.rollNo,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.dateOfBirth,
    this.email,
    this.mobile,
    this.admissionDate,
    this.studentPhoto,
    required this.username,
    required this.age,
    this.height,
    this.weight,
    this.currentAddress,
    this.permanentAddress,
    this.nationalIdNo,
    this.documentTitle1,
    this.documentFile1,
    this.documentTitle2,
    this.documentFile2,
    this.documentTitle3,
    this.documentFile3,
    this.documentTitle4,
    this.documentFile4,
    required this.classId,
    required this.userId,
    required this.roleId,
    this.genderId,
    this.schoolId,
    this.academicId,
    this.districtID,
    this.circuitID,
    this.middleName,
    this.gender,
    required this.parent1Name,
    required this.parent1FirstName,
    this.parent1Email,
    this.parent1Phone,
    this.parent1Nid,
    this.parent1Photo,
    this.parent1Occupation,
    this.parent1Relation,
    this.parent1Address,
    this.parent2Name,
    this.parent2FirstName,
    this.parent2Email,
    this.parent2Phone,
    this.parent2Nid,
    this.parent2Photo,
    this.parent2Occupation,
    this.parent2Relation,
    this.parent2Address,
    this.parent1MiddleName,
    required this.parent1LastName,
    this.parent2MiddleName,
    this.parent2LastName,
    required this.parent1Dob,
    this.parent2Dob,
    required this.className,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        studId: json['stud_id'],
        id: json['id'],
        admissionNo: json['admission_no'],
        rollNo: json['roll_no'],
        username: json['username'],
        classId: json['class_id'],
        userId: json['user_id'],
        roleId: json['role_id'],
        genderId: json['gender_id'],
        schoolId: json['school_id'],
        academicId: json['academic_id'],
        firstName: json['first_name'],
        middleName: json['middle_name'],
        lastName: json['last_name'],
        fullName: json['full_name'],
        dateOfBirth: json['date_of_birth'],
        email: json['email'],
        mobile: json['mobile'],
        admissionDate: json['admission_date'],
        studentPhoto: json['student_photo'],
        age: json['age'],
        height: json['height'] ?? '' + ' (inch)',
        weight: json['weight'] ?? '' + ' (Kg)',
        currentAddress: json['current_address'],
        permanentAddress: json['permanent_address'],
        nationalIdNo: json['national_id_no'],
        documentTitle1: json['document_title_1'],
        documentFile1: json['document_file_1'],
        documentTitle2: json['document_title_2'],
        documentFile2: json['document_file_2'],
        documentTitle3: json['document_title_3'],
        documentFile3: json['document_file_3'],
        documentTitle4: json['document_title_4'],
        documentFile4: json['document_file_4'],
        className: json['class_name'],
        gender: json['gender'],
        districtID: json['districtID'],
        circuitID: json['circuitID'],
        parent1Name: json['parent_1_name'],
        parent1FirstName: json['parent1_first_name'],
        parent1Email: json['parent_1_email'],
        parent1Phone: json['parent1_phone'],
        parent1MiddleName: json['parent1_middle_name'],
        parent1LastName: json['parent1_last_name'],
        parent1Nid: json['parent_1_nid'],
        parent1Photo: json['parent1_photo'],
        parent1Occupation: json['parent_1_occupation'],
        parent1Relation: json['parent_1_relation'],
        parent1Address: json['parent1_address'],
        parent1Dob: json['parent1_dob'],
        parent2Name: json['parent2_name'],
        parent2Email: json['parent2_email'],
        parent2Phone: json['parent2_phone'],
        parent2Nid: json['parent_2_nid'],
        parent2Photo: json['parent2_photo'],
        parent2Occupation: json['parent2_occupation'],
        parent2Relation: json['parent_2_relation'],
        parent2Address: json['parent2_address'],
        parent2FirstName: json['parent2_first_name'],
        parent2MiddleName: json['parent2_middle_name'],
        parent2LastName: json['parent2_last_name'],
        parent2Dob: json['parent2_dob'],
      );
}

class ParentLoginDetails {
  String parent1Dob;
  String p1Pass;
  String? parent2Dob;
  String? p2Pass;

  ParentLoginDetails({
    required this.parent1Dob,
    required this.p1Pass,
    this.parent2Dob,
    this.p2Pass,
  });

  factory ParentLoginDetails.fromJson(json) => ParentLoginDetails(
        parent1Dob: json['parent1_dob'],
        p1Pass: json['p1_pass'],
        parent2Dob: json['parent2_dob'],
        p2Pass: (json['p2_pass']),
      );
}
