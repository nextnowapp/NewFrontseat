class UserDetails {
  UserDetails({
    this.id,
    this.studId,
    this.admissionNo,
    this.rollNo,
    this.firstName,
    this.lastName,
    this.middleName,
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
    this.createdAt,
    this.updatedAt,
    this.bloodgroupId,
    this.religionId,
    this.routeListId,
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
    this.className,
    this.sectionName,
    this.parent1FirstName,
    this.parent1MiddleName,
    this.parent1LastName,
    this.parent1nid,
    this.parent1Mobile,
    this.parent1Email,
    this.parent1Occupation,
    this.parent1image,
    this.parent1realtion,
    this.parent1address,
    this.parent2FirstName,
    this.parent2MiddleName,
    this.parent2LastName,
    this.parent2nid,
    this.parent2Mobile,
    this.parent2Email,
    this.parent2Occupation,
    this.parent2image,
    this.parent2realtion,
    this.parent2address,
    this.parent1Dob,
    this.parent1Pass,
    this.parent2Dob,
    this.parent2Pass,
  });

  dynamic id;
  dynamic studId;
  dynamic admissionNo;
  dynamic rollNo;
  String? firstName;
  String? lastName;
  String? middleName;
  String? fullName;
  String? dateOfBirth;
  String? caste;
  String? email;
  String? mobile;
  DateTime? admissionDate;
  String? studentPhoto;
  dynamic age;
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
  dynamic documentFile1;
  String? documentTitle2;
  dynamic documentFile2;
  String? documentTitle3;
  dynamic documentFile3;
  String? documentTitle4;
  dynamic documentFile4;
  dynamic activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic bloodgroupId;
  dynamic religionId;
  dynamic routeListId;
  dynamic vechileId;
  dynamic roomId;
  dynamic studentCategoryId;
  dynamic studentGroupId;
  dynamic classId;
  dynamic sectionId;
  dynamic sessionId;
  dynamic parentId;
  dynamic userId;
  dynamic roleId;
  dynamic genderId;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic schoolId;
  dynamic academicId;
  String? fathersName;
  String? fathersMobile;
  String? fathersOccupation;
  String? fathersPhoto;
  String? mothersName;
  String? mothersMobile;
  String? mothersOccupation;
  String? mothersPhoto;
  dynamic relation;
  String? guardiansName;
  String? guardiansMobile;
  String? guardiansEmail;
  String? guardiansOccupation;
  String? guardiansRelation;
  String? guardiansPhoto;
  String? guardiansAddress;
  dynamic isGuardian;
  String? className;
  String? sectionName;
  String? parent1FirstName;
  String? parent1MiddleName;
  String? parent1LastName;
  String? parent1Mobile;
  String? parent1nid;
  String? parent1Email;
  String? parent1Occupation;
  String? parent1image;
  String? parent1realtion;
  String? parent1address;
  String? parent2FirstName;
  String? parent2MiddleName;
  String? parent2LastName;
  String? parent2nid;
  String? parent2Mobile;
  String? parent2Email;
  String? parent2Occupation;
  String? parent2image;
  String? parent2realtion;
  String? parent2address;
  String? parent1Dob;
  String? parent1Pass;
  String? parent2Dob;
  String? parent2Pass;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json['userDetails']['id'] ?? '',
        studId: json['userDetails']['stud_id'] ?? '',
        admissionNo: json['userDetails']['admission_no'] ?? '',
        rollNo: json['userDetails']['roll_no'] ?? '',
        firstName: json['userDetails']['first_name'] ?? '',
        lastName: json['userDetails']['last_name'] ?? '',
        middleName: json['userDetails']['middle_name'] ?? '',
        fullName: json['userDetails']['full_name'] ?? '',
        dateOfBirth: json['userDetails']['date_of_birth'] ?? '',
        caste: json['userDetails']['caste'] ?? '',
        email: json['userDetails']['email'] ?? '',
        mobile: json['userDetails']['mobile'] ?? '',
        admissionDate:
            DateTime.parse(json['userDetails']['admission_date'] ?? ''),
        studentPhoto: json['userDetails']['student_photo'] ?? '',
        age: json['userDetails']['age'] ?? '',
        height: json['userDetails']['height'] ?? '',
        weight: json['userDetails']['weight'] ?? '',
        currentAddress: json['userDetails']['current_address'] ?? '',
        permanentAddress: json['userDetails']['permanent_address'] ?? '',
        driverId: json['userDetails']['driver_id'] ?? '',
        nationalIdNo: json['userDetails']['national_id_no'] ?? '',
        localIdNo: json['userDetails']['local_id_no'] ?? '',
        bankAccountNo: json['userDetails']['bank_account_no'] ?? '',
        bankName: json['userDetails']['bank_name'] ?? '',
        previousSchoolDetails:
            json['userDetails']['previous_school_details'] ?? '',
        aditionalNotes: json['userDetails']['aditional_notes'] ?? '',
        ifscCode: json['userDetails']['ifsc_code'] ?? '',
        documentTitle1: json['userDetails']['document_title_1'] ?? '',
        documentFile1: json['userDetails']['document_file_1'] ?? '',
        documentTitle2: json['userDetails']['document_title_2'] ?? '',
        documentFile2: json['userDetails']['document_file_2'] ?? '',
        documentTitle3: json['userDetails']['document_title_3'] ?? '',
        documentFile3: json['userDetails']['document_file_3'] ?? '',
        documentTitle4: json['userDetails']['document_title_4'] ?? '',
        documentFile4: json['userDetails']['document_file_4'] ?? '',
        activeStatus: json['userDetails']['active_status'] ?? '',
        createdAt: DateTime.parse(json['userDetails']['created_at'] ?? ''),
        updatedAt: DateTime.parse(json['userDetails']['updated_at'] ?? ''),
        bloodgroupId: json['userDetails']['bloodgroup_id'] ?? '',
        religionId: json['userDetails']['religion_id'] ?? '',
        routeListId: json['userDetails']['route_list_id'] ?? '',
        vechileId: json['userDetails']['vechile_id'] ?? '',
        roomId: json['userDetails']['room_id'] ?? '',
        studentCategoryId: json['userDetails']['student_category_id'] ?? '',
        studentGroupId: json['userDetails']['student_group_id'] ?? '',
        classId: json['userDetails']['class_id'] ?? '',
        sectionId: json['userDetails']['section_id'] ?? '',
        sessionId: json['userDetails']['session_id'] ?? '',
        parentId: json['userDetails']['parent_id'] ?? '',
        userId: json['userDetails']['user_id'] ?? '',
        roleId: json['userDetails']['role_id'] ?? '',
        genderId: json['userDetails']['gender_id'] ?? '',
        createdBy: json['userDetails']['created_by'] ?? '',
        updatedBy: json['userDetails']['updated_by'] ?? '',
        schoolId: json['userDetails']['school_id'] ?? '',
        academicId: json['userDetails']['academic_id'] ?? '',
        fathersName: json['userDetails']['fathers_name'] ?? '',
        fathersMobile: json['userDetails']['fathers_mobile'] ?? '',
        fathersOccupation: json['userDetails']['fathers_occupation'] ?? '',
        fathersPhoto: json['userDetails']['fathers_photo'] ?? '',
        mothersName: json['userDetails']['mothers_name'] ?? '',
        mothersMobile: json['userDetails']['mothers_mobile'] ?? '',
        mothersOccupation: json['userDetails']['mothers_occupation'] ?? '',
        mothersPhoto: json['userDetails']['mothers_photo'] ?? '',
        relation: json['userDetails']['relation'] ?? '',
        guardiansName: json['userDetails']['guardians_name'] ?? '',
        guardiansMobile: json['userDetails']['guardians_mobile'] ?? '',
        guardiansEmail: json['userDetails']['guardians_email'] ?? '',
        guardiansOccupation: json['userDetails']['guardians_occupation'] ?? '',
        guardiansRelation: json['userDetails']['guardians_relation'] ?? '',
        guardiansPhoto: json['userDetails']['guardians_photo'] ?? '',
        guardiansAddress: json['userDetails']['guardians_address'] ?? '',
        isGuardian: json['userDetails']['is_guardian'] ?? '',
        className: json['userDetails']['class_name'] ?? '',
        sectionName: json['userDetails']['section_name'] ?? '',
        parent1FirstName: json['userDetails']['parent_1_name'] ?? '',
        parent1MiddleName: json['userDetails']['parent1_middle_name'] ?? '',
        parent1LastName: json['userDetails']['parent1_last_name'] ?? '',
        // parent1Name: json['userDetails']["parent_1_name"]??"" +
        //     " " +
        //     json['userDetails']["parent1_middle_name"]??"" +
        //     " " +
        //     json['userDetails']["parent1_last_name"]??"",
        parent1Mobile: json['userDetails']['parent1_phone'] ?? '' ?? '',
        parent1Email: json['userDetails']['parent_1_email'] ?? '' ?? '',
        parent1Occupation:
            json['userDetails']['parent_1_occupation'] ?? '' ?? '',
        parent1image: json['userDetails']['parent1_photo'] ?? '' ?? '',
        parent1realtion: json['userDetails']['parent_1_relation'] ?? '' ?? '',
        parent1address: json['userDetails']['parent1_address'] ?? '' ?? '',
        parent1nid: json['userDetails']['parent_1_nid'] ?? '' ?? '',
        parent2FirstName: json['userDetails']['parent2_name'] ?? '',
        parent2MiddleName: json['userDetails']['parent2_middle_name'] ?? '',
        parent2LastName: json['userDetails']['parent2_last_name'] ?? '',
        // parent2Name: json['userDetails']["parent2_name"]??"" +
        //     " " +
        //     json['userDetails']["parent2_middle_name"]??"" +
        //     " " +
        //     json['userDetails']["parent2_last_name"]??""??"",
        parent2nid: json['userDetails']['parent_2_nid'] ?? '',
        parent2Mobile: json['userDetails']['parent2_phone'] ?? '',
        parent2Email: json['userDetails']['parent2_email'] ?? '',
        parent2Occupation: json['userDetails']['parent2_occupation'] ?? '',
        parent2image: json['userDetails']['parent2_photo'] ?? '',
        parent2realtion: json['userDetails']['parent_2_relation'] ?? '',
        parent2address: json['userDetails']['parent2_address'] ?? '',
        parent1Dob: json['parent_loginDetails']['parent1_dob'] ?? '',
        parent1Pass: json['parent_loginDetails']['p1_pass'] ?? '',
        parent2Dob: json['parent_loginDetails']['parent2_dob'] ?? '',
        parent2Pass: json['parent_loginDetails']['p2_pass'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'admission_no': admissionNo,
        'roll_no': rollNo,
        'first_name': firstName,
        'last_name': lastName,
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'caste': caste,
        'email': email,
        'mobile': mobile,
        'admission_date':
            "${admissionDate!.year.toString().padLeft(4, '0')}-${admissionDate!.month.toString().padLeft(2, '0')}-${admissionDate!.day.toString().padLeft(2, '0')}",
        'student_photo': studentPhoto,
        'age': age,
        'height': height,
        'weight': weight,
        'current_address': currentAddress,
        'permanent_address': permanentAddress,
        'driver_id': driverId,
        'national_id_no': nationalIdNo,
        'local_id_no': localIdNo,
        'bank_account_no': bankAccountNo,
        'bank_name': bankName,
        'previous_school_details': previousSchoolDetails,
        'aditional_notes': aditionalNotes,
        'ifsc_code': ifscCode,
        'document_title_1': documentTitle1,
        'document_title_2': documentTitle2,
        'document_title_3': documentTitle3,
        'document_title_4': documentTitle4,
        'document_file_1': documentFile1,
        'document_file_2': documentFile2,
        'document_file_3': documentFile3,
        'document_file_4': documentFile4,
        'active_status': activeStatus,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
        'bloodgroup_id': bloodgroupId,
        'religion_id': religionId,
        'route_list_id': routeListId,
        'vechile_id': vechileId,
        'room_id': roomId,
        'student_category_id': studentCategoryId,
        'student_group_id': studentGroupId,
        'class_id': classId,
        'section_id': sectionId,
        'session_id': sessionId,
        'parent_id': parentId,
        'user_id': userId,
        'role_id': roleId,
        'gender_id': genderId,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'school_id': schoolId,
        'academic_id': academicId,
        'fathers_name': fathersName,
        'fathers_mobile': fathersMobile,
        'fathers_occupation': fathersOccupation,
        'fathers_photo': fathersPhoto,
        'mothers_name': mothersName,
        'mothers_mobile': mothersMobile,
        'mothers_occupation': mothersOccupation,
        'mothers_photo': mothersPhoto,
        'relation': relation,
        'guardians_name': guardiansName,
        'guardians_mobile': guardiansMobile,
        'guardians_email': guardiansEmail,
        'guardians_occupation': guardiansOccupation,
        'guardians_relation': guardiansRelation,
        'guardians_photo': guardiansPhoto,
        'guardians_address': guardiansAddress,
        'is_guardian': isGuardian,
        'class_name': className,
        'section_name': sectionName,
      };
}
