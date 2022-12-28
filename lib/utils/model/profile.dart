class Profiless {
  bool? success;
  Data? data;
  String? message;

  Profiless({this.success, this.data, this.message});

  Profiless.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  User? user;
  UserDetails? userDetails;
  ParentLoginDetails? parentLoginDetails;
  String? religion;
  String? bloodGroup;
  String? transport;

  Data(
      {this.user,
      this.userDetails,
      this.parentLoginDetails,
      this.religion,
      this.bloodGroup,
      this.transport});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    parentLoginDetails = json['parent_loginDetails'] != null
        ? new ParentLoginDetails.fromJson(json['parent_loginDetails'])
        : null;
    religion = json['religion'];
    bloodGroup = json['blood_group'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    if (this.parentLoginDetails != null) {
      data['parent_loginDetails'] = this.parentLoginDetails!.toJson();
    }
    data['religion'] = this.religion;
    data['blood_group'] = this.bloodGroup;
    data['transport'] = this.transport;
    return data;
  }
}

class User {
  int? id;
  int? admissionNo;
  int? rollNo;
  String? firstName;
  String? lastName;
  String? fullName;
  String? dateOfBirth;
  String? caste;
  String? email;
  String? mobile;
  String? admissionDate;
  String? studentPhoto;
  int? age;
  String? height;
  String? weight;
  String? currentAddress;
  String? permanentAddress;
  String? driverId;
  String? nationalIdNo;
  String? localIdNo;
  String? bankAccountNo;
  String? bankName;
  String? previousSchoolDetails;
  String? aditionalNotes;
  String? ifscCode;
  String? documentTitle1;
  String? documentFile1;
  String? documentTitle2;
  String? documentFile2;
  String? documentTitle3;
  String? documentFile3;
  String? documentTitle4;
  String? documentFile4;
  int? activeStatus;
  String? customField;
  String? customFieldFormName;
  String? createdAt;
  String? updatedAt;
  String? bloodgroupId;
  String? religionId;
  String? routeListId;
  String? dormitoryId;
  String? vechileId;
  String? roomId;
  String? studentCategoryId;
  String? studentGroupId;
  int? classId;
  int? sectionId;
  int? sessionId;
  int? parentId;
  int? userId;
  int? roleId;
  int? genderId;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;
  String? firebaseUserAuthId;
  String? globalID;
  String? learnerSID;
  String? districtID;
  String? circuitID;
  String? firebaseLearnerUserAuthId;
  String? luritsNumber;
  String? middleName;
  int? isStudentFlagEnable;
  int? isParent1FlagEnable;
  int? isParent2FlagEnable;
  String? firebaseParent1UserAuthId;
  String? firebaseParent2UserAuthId;

  User(
      {this.id,
      this.admissionNo,
      this.rollNo,
      this.firstName,
      this.lastName,
      this.fullName,
      this.dateOfBirth,
      this.caste,
      this.email,
      this.mobile,
      this.admissionDate,
      this.studentPhoto,
      this.age,
      this.height,
      this.weight,
      this.currentAddress,
      this.permanentAddress,
      this.driverId,
      this.nationalIdNo,
      this.localIdNo,
      this.bankAccountNo,
      this.bankName,
      this.previousSchoolDetails,
      this.aditionalNotes,
      this.ifscCode,
      this.documentTitle1,
      this.documentFile1,
      this.documentTitle2,
      this.documentFile2,
      this.documentTitle3,
      this.documentFile3,
      this.documentTitle4,
      this.documentFile4,
      this.activeStatus,
      this.customField,
      this.customFieldFormName,
      this.createdAt,
      this.updatedAt,
      this.bloodgroupId,
      this.religionId,
      this.routeListId,
      this.dormitoryId,
      this.vechileId,
      this.roomId,
      this.studentCategoryId,
      this.studentGroupId,
      this.classId,
      this.sectionId,
      this.sessionId,
      this.parentId,
      this.userId,
      this.roleId,
      this.genderId,
      this.createdBy,
      this.updatedBy,
      this.schoolId,
      this.academicId,
      this.firebaseUserAuthId,
      this.globalID,
      this.learnerSID,
      this.districtID,
      this.circuitID,
      this.firebaseLearnerUserAuthId,
      this.luritsNumber,
      this.middleName,
      this.isStudentFlagEnable,
      this.isParent1FlagEnable,
      this.isParent2FlagEnable,
      this.firebaseParent1UserAuthId,
      this.firebaseParent2UserAuthId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    admissionNo = json['admission_no'];
    rollNo = json['roll_no'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    caste = json['caste'];
    email = json['email'];
    mobile = json['mobile'];
    admissionDate = json['admission_date'];
    studentPhoto = json['student_photo'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    driverId = json['driver_id'];
    nationalIdNo = json['national_id_no'];
    localIdNo = json['local_id_no'];
    bankAccountNo = json['bank_account_no'];
    bankName = json['bank_name'];
    previousSchoolDetails = json['previous_school_details'];
    aditionalNotes = json['aditional_notes'];
    ifscCode = json['ifsc_code'];
    documentTitle1 = json['document_title_1'];
    documentFile1 = json['document_file_1'];
    documentTitle2 = json['document_title_2'];
    documentFile2 = json['document_file_2'];
    documentTitle3 = json['document_title_3'];
    documentFile3 = json['document_file_3'];
    documentTitle4 = json['document_title_4'];
    documentFile4 = json['document_file_4'];
    activeStatus = json['active_status'];
    customField = json['custom_field'];
    customFieldFormName = json['custom_field_form_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bloodgroupId = json['bloodgroup_id'];
    religionId = json['religion_id'];
    routeListId = json['route_list_id'];
    dormitoryId = json['dormitory_id'];
    vechileId = json['vechile_id'];
    roomId = json['room_id'];
    studentCategoryId = json['student_category_id'];
    studentGroupId = json['student_group_id'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    sessionId = json['session_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    roleId = json['role_id'];
    genderId = json['gender_id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
    firebaseUserAuthId = json['firebase_user_auth_id'];
    globalID = json['globalID'];
    learnerSID = json['learnerSID'];
    districtID = json['districtID'];
    circuitID = json['circuitID'];
    firebaseLearnerUserAuthId = json['firebase_learner_user_auth_id'];
    luritsNumber = json['lurits_number'];
    middleName = json['middle_name'];
    isStudentFlagEnable = json['is_student_flag_enable'];
    isParent1FlagEnable = json['is_parent1_flag_enable'];
    isParent2FlagEnable = json['is_parent2_flag_enable'];
    firebaseParent1UserAuthId = json['firebase_parent1_user_auth_id'];
    firebaseParent2UserAuthId = json['firebase_parent2_user_auth_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admission_no'] = this.admissionNo;
    data['roll_no'] = this.rollNo;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['caste'] = this.caste;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['admission_date'] = this.admissionDate;
    data['student_photo'] = this.studentPhoto;
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['driver_id'] = this.driverId;
    data['national_id_no'] = this.nationalIdNo;
    data['local_id_no'] = this.localIdNo;
    data['bank_account_no'] = this.bankAccountNo;
    data['bank_name'] = this.bankName;
    data['previous_school_details'] = this.previousSchoolDetails;
    data['aditional_notes'] = this.aditionalNotes;
    data['ifsc_code'] = this.ifscCode;
    data['document_title_1'] = this.documentTitle1;
    data['document_file_1'] = this.documentFile1;
    data['document_title_2'] = this.documentTitle2;
    data['document_file_2'] = this.documentFile2;
    data['document_title_3'] = this.documentTitle3;
    data['document_file_3'] = this.documentFile3;
    data['document_title_4'] = this.documentTitle4;
    data['document_file_4'] = this.documentFile4;
    data['active_status'] = this.activeStatus;
    data['custom_field'] = this.customField;
    data['custom_field_form_name'] = this.customFieldFormName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bloodgroup_id'] = this.bloodgroupId;
    data['religion_id'] = this.religionId;
    data['route_list_id'] = this.routeListId;
    data['dormitory_id'] = this.dormitoryId;
    data['vechile_id'] = this.vechileId;
    data['room_id'] = this.roomId;
    data['student_category_id'] = this.studentCategoryId;
    data['student_group_id'] = this.studentGroupId;
    data['class_id'] = this.classId;
    data['section_id'] = this.sectionId;
    data['session_id'] = this.sessionId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['gender_id'] = this.genderId;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    data['firebase_user_auth_id'] = this.firebaseUserAuthId;
    data['globalID'] = this.globalID;
    data['learnerSID'] = this.learnerSID;
    data['districtID'] = this.districtID;
    data['circuitID'] = this.circuitID;
    data['firebase_learner_user_auth_id'] = this.firebaseLearnerUserAuthId;
    data['lurits_number'] = this.luritsNumber;
    data['middle_name'] = this.middleName;
    data['is_student_flag_enable'] = this.isStudentFlagEnable;
    data['is_parent1_flag_enable'] = this.isParent1FlagEnable;
    data['is_parent2_flag_enable'] = this.isParent2FlagEnable;
    data['firebase_parent1_user_auth_id'] = this.firebaseParent1UserAuthId;
    data['firebase_parent2_user_auth_id'] = this.firebaseParent2UserAuthId;
    return data;
  }
}

class UserDetails {
  int? studId;
  int? id;
  int? admissionNo;
  int? rollNo;
  String? firstName;
  String? lastName;
  String? fullName;
  String? dateOfBirth;
  String? caste;
  String? email;
  String? mobile;
  String? admissionDate;
  String? studentPhoto;
  String? age;
  String? height;
  String? weight;
  String? currentAddress;
  String? permanentAddress;
  String? driverId;
  String? nationalIdNo;
  String? localIdNo;
  String? bankAccountNo;
  String? bankName;
  String? previousSchoolDetails;
  String? aditionalNotes;
  String? ifscCode;
  String? documentTitle1;
  String? documentFile1;
  String? documentTitle2;
  String? documentFile2;
  String? documentTitle3;
  String? documentFile3;
  String? documentTitle4;
  String? documentFile4;
  int? activeStatus;
  String? customField;
  String? customFieldFormName;
  String? createdAt;
  String? updatedAt;
  String? bloodgroupId;
  String? religionId;
  String? routeListId;
  String? dormitoryId;
  String? vechileId;
  String? roomId;
  String? studentCategoryId;
  String? studentGroupId;
  int? classId;
  int? sectionId;
  int? sessionId;
  int? parentId;
  int? userId;
  int? roleId;
  int? genderId;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;
  String? firebaseUserAuthId;
  String? globalID;
  String? learnerSID;
  String? districtID;
  String? circuitID;
  String? firebaseLearnerUserAuthId;
  String? luritsNumber;
  String? middleName;
  int? isStudentFlagEnable;
  int? isParent1FlagEnable;
  int? isParent2FlagEnable;
  String? firebaseParent1UserAuthId;
  String? firebaseParent2UserAuthId;
  String? fathersName;
  String? fathersMobile;
  String? fathersOccupation;
  String? fathersPhoto;
  String? mothersName;
  String? mothersMobile;
  String? mothersOccupation;
  String? mothersPhoto;
  String? relation;
  String? guardiansName;
  String? guardiansMobile;
  String? guardiansEmail;
  String? guardiansOccupation;
  String? guardiansRelation;
  String? guardiansPhoto;
  String? guardiansAddress;
  String? isGuardian;
  String? guardiansNid;
  String? parent1Name;
  String? parent1Email;
  String? parent1Phone;
  String? parent1Nid;
  String? parent1Photo;
  String? parent1Occupation;
  String? parent1Relation;
  String? parent1Address;
  String? parent2Name;
  String? parent2Email;
  String? parent2Phone;
  String? parent2Nid;
  String? parent2Photo;
  String? parent2Occupation;
  String? parent2Relation;
  String? parent2Address;
  String? parent1SID;
  String? parent2SID;
  String? firebaseGuardianUserAuthId;
  int? parent1MobileUpdatedOnLogin;
  int? parent2MobileUpdatedOnLogin;
  int? guardianMobileUpdatedOnLogin;
  String? parentSID;
  String? parent1MiddleName;
  String? parent1LastName;
  String? parent2MiddleName;
  String? parent2LastName;
  String? parent1Dob;
  String? parent2Dob;
  String? className;

  UserDetails(
      {this.studId,
      this.id,
      this.admissionNo,
      this.rollNo,
      this.firstName,
      this.lastName,
      this.fullName,
      this.dateOfBirth,
      this.caste,
      this.email,
      this.mobile,
      this.admissionDate,
      this.studentPhoto,
      this.age,
      this.height,
      this.weight,
      this.currentAddress,
      this.permanentAddress,
      this.driverId,
      this.nationalIdNo,
      this.localIdNo,
      this.bankAccountNo,
      this.bankName,
      this.previousSchoolDetails,
      this.aditionalNotes,
      this.ifscCode,
      this.documentTitle1,
      this.documentFile1,
      this.documentTitle2,
      this.documentFile2,
      this.documentTitle3,
      this.documentFile3,
      this.documentTitle4,
      this.documentFile4,
      this.activeStatus,
      this.customField,
      this.customFieldFormName,
      this.createdAt,
      this.updatedAt,
      this.bloodgroupId,
      this.religionId,
      this.routeListId,
      this.dormitoryId,
      this.vechileId,
      this.roomId,
      this.studentCategoryId,
      this.studentGroupId,
      this.classId,
      this.sectionId,
      this.sessionId,
      this.parentId,
      this.userId,
      this.roleId,
      this.genderId,
      this.createdBy,
      this.updatedBy,
      this.schoolId,
      this.academicId,
      this.firebaseUserAuthId,
      this.globalID,
      this.learnerSID,
      this.districtID,
      this.circuitID,
      this.firebaseLearnerUserAuthId,
      this.luritsNumber,
      this.middleName,
      this.isStudentFlagEnable,
      this.isParent1FlagEnable,
      this.isParent2FlagEnable,
      this.firebaseParent1UserAuthId,
      this.firebaseParent2UserAuthId,
      this.fathersName,
      this.fathersMobile,
      this.fathersOccupation,
      this.fathersPhoto,
      this.mothersName,
      this.mothersMobile,
      this.mothersOccupation,
      this.mothersPhoto,
      this.relation,
      this.guardiansName,
      this.guardiansMobile,
      this.guardiansEmail,
      this.guardiansOccupation,
      this.guardiansRelation,
      this.guardiansPhoto,
      this.guardiansAddress,
      this.isGuardian,
      this.guardiansNid,
      this.parent1Name,
      this.parent1Email,
      this.parent1Phone,
      this.parent1Nid,
      this.parent1Photo,
      this.parent1Occupation,
      this.parent1Relation,
      this.parent1Address,
      this.parent2Name,
      this.parent2Email,
      this.parent2Phone,
      this.parent2Nid,
      this.parent2Photo,
      this.parent2Occupation,
      this.parent2Relation,
      this.parent2Address,
      this.parent1SID,
      this.parent2SID,
      this.firebaseGuardianUserAuthId,
      this.parent1MobileUpdatedOnLogin,
      this.parent2MobileUpdatedOnLogin,
      this.guardianMobileUpdatedOnLogin,
      this.parentSID,
      this.parent1MiddleName,
      this.parent1LastName,
      this.parent2MiddleName,
      this.parent2LastName,
      this.parent1Dob,
      this.parent2Dob,
      this.className});

  UserDetails.fromJson(Map<String, dynamic> json) {
    studId = json['stud_id'];
    id = json['id'];
    admissionNo = json['admission_no'];
    rollNo = json['roll_no'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    caste = json['caste'];
    email = json['email'];
    mobile = json['mobile'];
    admissionDate = json['admission_date'];
    studentPhoto = json['student_photo'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    driverId = json['driver_id'];
    nationalIdNo = json['national_id_no'];
    localIdNo = json['local_id_no'];
    bankAccountNo = json['bank_account_no'];
    bankName = json['bank_name'];
    previousSchoolDetails = json['previous_school_details'];
    aditionalNotes = json['aditional_notes'];
    ifscCode = json['ifsc_code'];
    documentTitle1 = json['document_title_1'];
    documentFile1 = json['document_file_1'];
    documentTitle2 = json['document_title_2'];
    documentFile2 = json['document_file_2'];
    documentTitle3 = json['document_title_3'];
    documentFile3 = json['document_file_3'];
    documentTitle4 = json['document_title_4'];
    documentFile4 = json['document_file_4'];
    activeStatus = json['active_status'];
    customField = json['custom_field'];
    customFieldFormName = json['custom_field_form_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bloodgroupId = json['bloodgroup_id'];
    religionId = json['religion_id'];
    routeListId = json['route_list_id'];
    dormitoryId = json['dormitory_id'];
    vechileId = json['vechile_id'];
    roomId = json['room_id'];
    studentCategoryId = json['student_category_id'];
    studentGroupId = json['student_group_id'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    sessionId = json['session_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    roleId = json['role_id'];
    genderId = json['gender_id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
    firebaseUserAuthId = json['firebase_user_auth_id'];
    globalID = json['globalID'];
    learnerSID = json['learnerSID'];
    districtID = json['districtID'];
    circuitID = json['circuitID'];
    firebaseLearnerUserAuthId = json['firebase_learner_user_auth_id'];
    luritsNumber = json['lurits_number'];
    middleName = json['middle_name'];
    isStudentFlagEnable = json['is_student_flag_enable'];
    isParent1FlagEnable = json['is_parent1_flag_enable'];
    isParent2FlagEnable = json['is_parent2_flag_enable'];
    firebaseParent1UserAuthId = json['firebase_parent1_user_auth_id'];
    firebaseParent2UserAuthId = json['firebase_parent2_user_auth_id'];
    fathersName = json['fathers_name'];
    fathersMobile = json['fathers_mobile'];
    fathersOccupation = json['fathers_occupation'];
    fathersPhoto = json['fathers_photo'];
    mothersName = json['mothers_name'];
    mothersMobile = json['mothers_mobile'];
    mothersOccupation = json['mothers_occupation'];
    mothersPhoto = json['mothers_photo'];
    relation = json['relation'];
    guardiansName = json['guardians_name'];
    guardiansMobile = json['guardians_mobile'];
    guardiansEmail = json['guardians_email'];
    guardiansOccupation = json['guardians_occupation'];
    guardiansRelation = json['guardians_relation'];
    guardiansPhoto = json['guardians_photo'];
    guardiansAddress = json['guardians_address'];
    isGuardian = json['is_guardian'];
    guardiansNid = json['guardians_nid'];
    parent1Name = json['parent_1_name'];
    parent1Email = json['parent_1_email'];
    parent1Phone = json['parent1_phone'];
    parent1Nid = json['parent_1_nid'];
    parent1Photo = json['parent1_photo'];
    parent1Occupation = json['parent_1_occupation'];
    parent1Relation = json['parent_1_relation'];
    parent1Address = json['parent1_address'];
    parent2Name = json['parent2_name'];
    parent2Email = json['parent2_email'];
    parent2Phone = json['parent2_phone'];
    parent2Nid = json['parent_2_nid'];
    parent2Photo = json['parent2_photo'];
    parent2Occupation = json['parent2_occupation'];
    parent2Relation = json['parent_2_relation'];
    parent2Address = json['parent2_address'];
    parent1SID = json['parent1SID'];
    parent2SID = json['parent2SID'];
    firebaseGuardianUserAuthId = json['firebase_guardian_user_auth_id'];
    parent1MobileUpdatedOnLogin = json['parent1_mobile_updated_on_login'];
    parent2MobileUpdatedOnLogin = json['parent2_mobile_updated_on_login'];
    guardianMobileUpdatedOnLogin = json['guardian_mobile_updated_on_login'];
    parentSID = json['parentSID'];
    parent1MiddleName = json['parent1_middle_name'];
    parent1LastName = json['parent1_last_name'];
    parent2MiddleName = json['parent2_middle_name'];
    parent2LastName = json['parent2_last_name'];
    parent1Dob = json['parent1_dob'];
    parent2Dob = json['parent2_dob'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stud_id'] = this.studId;
    data['id'] = this.id;
    data['admission_no'] = this.admissionNo;
    data['roll_no'] = this.rollNo;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['caste'] = this.caste;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['admission_date'] = this.admissionDate;
    data['student_photo'] = this.studentPhoto;
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['driver_id'] = this.driverId;
    data['national_id_no'] = this.nationalIdNo;
    data['local_id_no'] = this.localIdNo;
    data['bank_account_no'] = this.bankAccountNo;
    data['bank_name'] = this.bankName;
    data['previous_school_details'] = this.previousSchoolDetails;
    data['aditional_notes'] = this.aditionalNotes;
    data['ifsc_code'] = this.ifscCode;
    data['document_title_1'] = this.documentTitle1;
    data['document_file_1'] = this.documentFile1;
    data['document_title_2'] = this.documentTitle2;
    data['document_file_2'] = this.documentFile2;
    data['document_title_3'] = this.documentTitle3;
    data['document_file_3'] = this.documentFile3;
    data['document_title_4'] = this.documentTitle4;
    data['document_file_4'] = this.documentFile4;
    data['active_status'] = this.activeStatus;
    data['custom_field'] = this.customField;
    data['custom_field_form_name'] = this.customFieldFormName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bloodgroup_id'] = this.bloodgroupId;
    data['religion_id'] = this.religionId;
    data['route_list_id'] = this.routeListId;
    data['dormitory_id'] = this.dormitoryId;
    data['vechile_id'] = this.vechileId;
    data['room_id'] = this.roomId;
    data['student_category_id'] = this.studentCategoryId;
    data['student_group_id'] = this.studentGroupId;
    data['class_id'] = this.classId;
    data['section_id'] = this.sectionId;
    data['session_id'] = this.sessionId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['gender_id'] = this.genderId;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    data['firebase_user_auth_id'] = this.firebaseUserAuthId;
    data['globalID'] = this.globalID;
    data['learnerSID'] = this.learnerSID;
    data['districtID'] = this.districtID;
    data['circuitID'] = this.circuitID;
    data['firebase_learner_user_auth_id'] = this.firebaseLearnerUserAuthId;
    data['lurits_number'] = this.luritsNumber;
    data['middle_name'] = this.middleName;
    data['is_student_flag_enable'] = this.isStudentFlagEnable;
    data['is_parent1_flag_enable'] = this.isParent1FlagEnable;
    data['is_parent2_flag_enable'] = this.isParent2FlagEnable;
    data['firebase_parent1_user_auth_id'] = this.firebaseParent1UserAuthId;
    data['firebase_parent2_user_auth_id'] = this.firebaseParent2UserAuthId;
    data['fathers_name'] = this.fathersName;
    data['fathers_mobile'] = this.fathersMobile;
    data['fathers_occupation'] = this.fathersOccupation;
    data['fathers_photo'] = this.fathersPhoto;
    data['mothers_name'] = this.mothersName;
    data['mothers_mobile'] = this.mothersMobile;
    data['mothers_occupation'] = this.mothersOccupation;
    data['mothers_photo'] = this.mothersPhoto;
    data['relation'] = this.relation;
    data['guardians_name'] = this.guardiansName;
    data['guardians_mobile'] = this.guardiansMobile;
    data['guardians_email'] = this.guardiansEmail;
    data['guardians_occupation'] = this.guardiansOccupation;
    data['guardians_relation'] = this.guardiansRelation;
    data['guardians_photo'] = this.guardiansPhoto;
    data['guardians_address'] = this.guardiansAddress;
    data['is_guardian'] = this.isGuardian;
    data['guardians_nid'] = this.guardiansNid;
    data['parent_1_name'] = this.parent1Name;
    data['parent_1_email'] = this.parent1Email;
    data['parent1_phone'] = this.parent1Phone;
    data['parent_1_nid'] = this.parent1Nid;
    data['parent1_photo'] = this.parent1Photo;
    data['parent_1_occupation'] = this.parent1Occupation;
    data['parent_1_relation'] = this.parent1Relation;
    data['parent1_address'] = this.parent1Address;
    data['parent2_name'] = this.parent2Name;
    data['parent2_email'] = this.parent2Email;
    data['parent2_phone'] = this.parent2Phone;
    data['parent_2_nid'] = this.parent2Nid;
    data['parent2_photo'] = this.parent2Photo;
    data['parent2_occupation'] = this.parent2Occupation;
    data['parent_2_relation'] = this.parent2Relation;
    data['parent2_address'] = this.parent2Address;
    data['parent1SID'] = this.parent1SID;
    data['parent2SID'] = this.parent2SID;
    data['firebase_guardian_user_auth_id'] = this.firebaseGuardianUserAuthId;
    data['parent1_mobile_updated_on_login'] = this.parent1MobileUpdatedOnLogin;
    data['parent2_mobile_updated_on_login'] = this.parent2MobileUpdatedOnLogin;
    data['guardian_mobile_updated_on_login'] =
        this.guardianMobileUpdatedOnLogin;
    data['parentSID'] = this.parentSID;
    data['parent1_middle_name'] = this.parent1MiddleName;
    data['parent1_last_name'] = this.parent1LastName;
    data['parent2_middle_name'] = this.parent2MiddleName;
    data['parent2_last_name'] = this.parent2LastName;
    data['parent1_dob'] = this.parent1Dob;
    data['parent2_dob'] = this.parent2Dob;
    data['class_name'] = this.className;
    return data;
  }
}

class ParentLoginDetails {
  String? parent1Dob;
  String? p1Pass;
  String? parent2Dob;
  String? p2Pass;

  ParentLoginDetails(
      {this.parent1Dob, this.p1Pass, this.parent2Dob, this.p2Pass});

  ParentLoginDetails.fromJson(Map<String, dynamic> json) {
    parent1Dob = json['parent1_dob'];
    p1Pass = json['p1_pass'];
    parent2Dob = json['parent2_dob'];
    p2Pass = json['p2_pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent1_dob'] = this.parent1Dob;
    data['p1_pass'] = this.p1Pass;
    data['parent2_dob'] = this.parent2Dob;
    data['p2_pass'] = this.p2Pass;
    return data;
  }
}
