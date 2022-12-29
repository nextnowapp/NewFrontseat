class UserDetailModel {
  final bool? status;
  final String? message;
  final UserData? userData;

  UserDetailModel({
    this.status,
    this.message,
    this.userData,
  });

  UserDetailModel.fromJson(Map<String, dynamic> json)
    : status = json['status'] as bool?,
      message = json['message'] as String?,
      userData = (json['user_data'] as Map<String,dynamic>?) != null ? UserData.fromJson(json['user_data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'user_data' : userData?.toJson()
  };
}

class UserData {
  final String? staffid;
  final String? email;
  final String? firstname;
  final String? lastname;
  final String? facebook;
  final String? linkedin;
  final String? phonenumber;
  final String? skype;
  final String? password;
  final String? datecreated;
  final dynamic profileImage;
  final dynamic lastIp;
  final dynamic lastLogin;
  final dynamic lastActivity;
  final dynamic lastPasswordChange;
  final dynamic newPassKey;
  final dynamic newPassKeyRequested;
  final String? admin;
  final String? role;
  final String? active;
  final String? defaultLanguage;
  final String? direction;
  final String? mediaPathSlug;
  final String? isNotStaff;
  final String? hourlyRate;
  final String? twoFactorAuthEnabled;
  final dynamic twoFactorAuthCode;
  final dynamic twoFactorAuthCodeRequested;
  final String? emailSignature;
  final dynamic birthday;
  final dynamic birthplace;
  final dynamic sex;
  final String? maritalStatus;
  final dynamic nation;
  final String? religion;
  final dynamic identification;
  final dynamic daysForIdentity;
  final dynamic homeTown;
  final dynamic resident;
  final dynamic currentAddress;
  final dynamic literacy;
  final dynamic ortherInfor;
  final dynamic jobPosition;
  final dynamic workplace;
  final dynamic placeOfIssue;
  final String? accountNumber;
  final dynamic nameAccount;
  final dynamic issueBank;
  final dynamic recordsReceived;
  final dynamic personalTaxCode;
  final dynamic googleAuthSecret;
  final dynamic token;
  final String? teamManage;
  final dynamic staffIdentifi;
  final dynamic statusWork;
  final dynamic dateUpdate;
  final dynamic agentStatus;
  final dynamic agentUnder;
  final dynamic reasonWhyRejected;
  final dynamic agentProfileStatus;
  final String? govtIdUploaded;
  final String? personalInformationUpdated;
  final String? profileUpdated;
  final String? bankingDocument;
  final String? emailVerifiedAt;
  final String? mobileVerified;
  final String? branchCode;
  final String? residentialTownCity;
  final String? residentialProvince;
  final String? postalAddress;
  final String? postalCode;
  final String? postalTownCity;
  final String? postalProvince;
  final String? bankName;
  final String? accountHolder;
  final String? branchName;
  final String? residentialPostalCode;
  final String? accountType;
  final String? accountHolderRelationship;
  final String? drivingLicenseId;
  final String? gender;
  final String? idNumber;
  final String? drivingLicenceFrontImage;
  final String? drivingLicenceRearImage;
  final String? nationalIdFrontImage;
  final String? nationalIdRearImage;
  final String? residentialAddress;
  final String? dateOfBirth;
  final String? age;
  final String? nationalIdNumber;
  final String? passportNumber;
  final String? incomeTaxNumber;
  final String? nationality;
  final String? countryOfBirth;
  final String? race;
  final String? disability;
  final String? languages;
  final String? workLocation;
  final String? workProvince;
  final String? workCity;
  final String? teamLeader;
  final String? regionalAdministrator;
  final String? relationWithContactPerson;
  final String? emergencyAlternativeNo;
  final String? emergencyMobileNo;
  final String? emergencyContactsFullName;

  UserData({
    this.staffid,
    this.email,
    this.firstname,
    this.lastname,
    this.facebook,
    this.linkedin,
    this.phonenumber,
    this.skype,
    this.password,
    this.datecreated,
    this.profileImage,
    this.lastIp,
    this.lastLogin,
    this.lastActivity,
    this.lastPasswordChange,
    this.newPassKey,
    this.newPassKeyRequested,
    this.admin,
    this.role,
    this.active,
    this.defaultLanguage,
    this.direction,
    this.mediaPathSlug,
    this.isNotStaff,
    this.hourlyRate,
    this.twoFactorAuthEnabled,
    this.twoFactorAuthCode,
    this.twoFactorAuthCodeRequested,
    this.emailSignature,
    this.birthday,
    this.birthplace,
    this.sex,
    this.maritalStatus,
    this.nation,
    this.religion,
    this.identification,
    this.daysForIdentity,
    this.homeTown,
    this.resident,
    this.currentAddress,
    this.literacy,
    this.ortherInfor,
    this.jobPosition,
    this.workplace,
    this.placeOfIssue,
    this.accountNumber,
    this.nameAccount,
    this.issueBank,
    this.recordsReceived,
    this.personalTaxCode,
    this.googleAuthSecret,
    this.token,
    this.teamManage,
    this.staffIdentifi,
    this.statusWork,
    this.dateUpdate,
    this.agentStatus,
    this.agentUnder,
    this.reasonWhyRejected,
    this.agentProfileStatus,
    this.govtIdUploaded,
    this.personalInformationUpdated,
    this.profileUpdated,
    this.bankingDocument,
    this.emailVerifiedAt,
    this.mobileVerified,
    this.branchCode,
    this.residentialTownCity,
    this.residentialProvince,
    this.postalAddress,
    this.postalCode,
    this.postalTownCity,
    this.postalProvince,
    this.bankName,
    this.accountHolder,
    this.branchName,
    this.residentialPostalCode,
    this.accountType,
    this.accountHolderRelationship,
    this.drivingLicenseId,
    this.gender,
    this.idNumber,
    this.drivingLicenceFrontImage,
    this.drivingLicenceRearImage,
    this.nationalIdFrontImage,
    this.nationalIdRearImage,
    this.residentialAddress,
    this.dateOfBirth,
    this.age,
    this.nationalIdNumber,
    this.passportNumber,
    this.incomeTaxNumber,
    this.nationality,
    this.countryOfBirth,
    this.race,
    this.disability,
    this.languages,
    this.workLocation,
    this.workProvince,
    this.workCity,
    this.teamLeader,
    this.regionalAdministrator,
    this.relationWithContactPerson,
    this.emergencyAlternativeNo,
    this.emergencyMobileNo,
    this.emergencyContactsFullName,
  });

  UserData.fromJson(Map<String, dynamic> json)
    : staffid = json['staffid'] as String?,
      email = json['email'] as String?,
      firstname = json['firstname'] as String?,
      lastname = json['lastname'] as String?,
      facebook = json['facebook'] as String?,
      linkedin = json['linkedin'] as String?,
      phonenumber = json['phonenumber'] as String?,
      skype = json['skype'] as String?,
      password = json['password'] as String?,
      datecreated = json['datecreated'] as String?,
      profileImage = json['profile_image'],
      lastIp = json['last_ip'],
      lastLogin = json['last_login'],
      lastActivity = json['last_activity'],
      lastPasswordChange = json['last_password_change'],
      newPassKey = json['new_pass_key'],
      newPassKeyRequested = json['new_pass_key_requested'],
      admin = json['admin'] as String?,
      role = json['role'] as String?,
      active = json['active'] as String?,
      defaultLanguage = json['default_language'] as String?,
      direction = json['direction'] as String?,
      mediaPathSlug = json['media_path_slug'] as String?,
      isNotStaff = json['is_not_staff'] as String?,
      hourlyRate = json['hourly_rate'] as String?,
      twoFactorAuthEnabled = json['two_factor_auth_enabled'] as String?,
      twoFactorAuthCode = json['two_factor_auth_code'],
      twoFactorAuthCodeRequested = json['two_factor_auth_code_requested'],
      emailSignature = json['email_signature'] as String?,
      birthday = json['birthday'],
      birthplace = json['birthplace'],
      sex = json['sex'],
      maritalStatus = json['marital_status'] as String?,
      nation = json['nation'],
      religion = json['religion'] as String?,
      identification = json['identification'],
      daysForIdentity = json['days_for_identity'],
      homeTown = json['home_town'],
      resident = json['resident'],
      currentAddress = json['current_address'],
      literacy = json['literacy'],
      ortherInfor = json['orther_infor'],
      jobPosition = json['job_position'],
      workplace = json['workplace'],
      placeOfIssue = json['place_of_issue'],
      accountNumber = json['account_number'] as String?,
      nameAccount = json['name_account'],
      issueBank = json['issue_bank'],
      recordsReceived = json['records_received'],
      personalTaxCode = json['Personal_tax_code'],
      googleAuthSecret = json['google_auth_secret'],
      token = json['token'],
      teamManage = json['team_manage'] as String?,
      staffIdentifi = json['staff_identifi'],
      statusWork = json['status_work'],
      dateUpdate = json['date_update'],
      agentStatus = json['agent_status'],
      agentUnder = json['agent_under'],
      reasonWhyRejected = json['reason_why_rejected'],
      agentProfileStatus = json['agent_profile_status'],
      govtIdUploaded = json['govtIdUploaded'] as String?,
      personalInformationUpdated = json['personalInformationUpdated'] as String?,
      profileUpdated = json['profileUpdated'] as String?,
      bankingDocument = json['banking_document'] as String?,
      emailVerifiedAt = json['email_verified_at'] as String?,
      mobileVerified = json['mobile_verified'] as String?,
      branchCode = json['branch_code'] as String?,
      residentialTownCity = json['residential_town_city'] as String?,
      residentialProvince = json['residential_province'] as String?,
      postalAddress = json['postal_address'] as String?,
      postalCode = json['postal_code'] as String?,
      postalTownCity = json['postal_town_city'] as String?,
      postalProvince = json['postal_province'] as String?,
      bankName = json['bank_name'] as String?,
      accountHolder = json['account_holder'] as String?,
      branchName = json['branch_name'] as String?,
      residentialPostalCode = json['residential_postal_code'] as String?,
      accountType = json['account_type'] as String?,
      accountHolderRelationship = json['account_holder_relationship'] as String?,
      drivingLicenseId = json['driving_license_id'] as String?,
      gender = json['gender'] as String?,
      idNumber = json['id_number'] as String?,
      drivingLicenceFrontImage = json['driving_licence_front_image'] as String?,
      drivingLicenceRearImage = json['driving_licence_rear_image'] as String?,
      nationalIdFrontImage = json['national_id_front_image'] as String?,
      nationalIdRearImage = json['national_id_rear_image'] as String?,
      residentialAddress = json['residential_address'] as String?,
      dateOfBirth = json['date_of_birth'] as String?,
      age = json['age'] as String?,
      nationalIdNumber = json['national_id_number'] as String?,
      passportNumber = json['passport_number'] as String?,
      incomeTaxNumber = json['income_tax_number'] as String?,
      nationality = json['nationality'] as String?,
      countryOfBirth = json['country_of_birth'] as String?,
      race = json['race'] as String?,
      disability = json['disability'] as String?,
      languages = json['languages'] as String?,
      workLocation = json['work_location'] as String?,
      workProvince = json['work_province'] as String?,
      workCity = json['work_city'] as String?,
      teamLeader = json['team_leader'] as String?,
      regionalAdministrator = json['regional_administrator'] as String?,
      relationWithContactPerson = json['relation_with_contact_person'] as String?,
      emergencyAlternativeNo = json['emergency_alternative_no'] as String?,
      emergencyMobileNo = json['emergency_mobile_no'] as String?,
      emergencyContactsFullName = json['emergency_contacts_full_name'] as String?;

  Map<String, dynamic> toJson() => {
    'staffid' : staffid,
    'email' : email,
    'firstname' : firstname,
    'lastname' : lastname,
    'facebook' : facebook,
    'linkedin' : linkedin,
    'phonenumber' : phonenumber,
    'skype' : skype,
    'password' : password,
    'datecreated' : datecreated,
    'profile_image' : profileImage,
    'last_ip' : lastIp,
    'last_login' : lastLogin,
    'last_activity' : lastActivity,
    'last_password_change' : lastPasswordChange,
    'new_pass_key' : newPassKey,
    'new_pass_key_requested' : newPassKeyRequested,
    'admin' : admin,
    'role' : role,
    'active' : active,
    'default_language' : defaultLanguage,
    'direction' : direction,
    'media_path_slug' : mediaPathSlug,
    'is_not_staff' : isNotStaff,
    'hourly_rate' : hourlyRate,
    'two_factor_auth_enabled' : twoFactorAuthEnabled,
    'two_factor_auth_code' : twoFactorAuthCode,
    'two_factor_auth_code_requested' : twoFactorAuthCodeRequested,
    'email_signature' : emailSignature,
    'birthday' : birthday,
    'birthplace' : birthplace,
    'sex' : sex,
    'marital_status' : maritalStatus,
    'nation' : nation,
    'religion' : religion,
    'identification' : identification,
    'days_for_identity' : daysForIdentity,
    'home_town' : homeTown,
    'resident' : resident,
    'current_address' : currentAddress,
    'literacy' : literacy,
    'orther_infor' : ortherInfor,
    'job_position' : jobPosition,
    'workplace' : workplace,
    'place_of_issue' : placeOfIssue,
    'account_number' : accountNumber,
    'name_account' : nameAccount,
    'issue_bank' : issueBank,
    'records_received' : recordsReceived,
    'Personal_tax_code' : personalTaxCode,
    'google_auth_secret' : googleAuthSecret,
    'token' : token,
    'team_manage' : teamManage,
    'staff_identifi' : staffIdentifi,
    'status_work' : statusWork,
    'date_update' : dateUpdate,
    'agent_status' : agentStatus,
    'agent_under' : agentUnder,
    'reason_why_rejected' : reasonWhyRejected,
    'agent_profile_status' : agentProfileStatus,
    'govtIdUploaded' : govtIdUploaded,
    'personalInformationUpdated' : personalInformationUpdated,
    'profileUpdated' : profileUpdated,
    'banking_document' : bankingDocument,
    'email_verified_at' : emailVerifiedAt,
    'mobile_verified' : mobileVerified,
    'branch_code' : branchCode,
    'residential_town_city' : residentialTownCity,
    'residential_province' : residentialProvince,
    'postal_address' : postalAddress,
    'postal_code' : postalCode,
    'postal_town_city' : postalTownCity,
    'postal_province' : postalProvince,
    'bank_name' : bankName,
    'account_holder' : accountHolder,
    'branch_name' : branchName,
    'residential_postal_code' : residentialPostalCode,
    'account_type' : accountType,
    'account_holder_relationship' : accountHolderRelationship,
    'driving_license_id' : drivingLicenseId,
    'gender' : gender,
    'id_number' : idNumber,
    'driving_licence_front_image' : drivingLicenceFrontImage,
    'driving_licence_rear_image' : drivingLicenceRearImage,
    'national_id_front_image' : nationalIdFrontImage,
    'national_id_rear_image' : nationalIdRearImage,
    'residential_address' : residentialAddress,
    'date_of_birth' : dateOfBirth,
    'age' : age,
    'national_id_number' : nationalIdNumber,
    'passport_number' : passportNumber,
    'income_tax_number' : incomeTaxNumber,
    'nationality' : nationality,
    'country_of_birth' : countryOfBirth,
    'race' : race,
    'disability' : disability,
    'languages' : languages,
    'work_location' : workLocation,
    'work_province' : workProvince,
    'work_city' : workCity,
    'team_leader' : teamLeader,
    'regional_administrator' : regionalAdministrator,
    'relation_with_contact_person' : relationWithContactPerson,
    'emergency_alternative_no' : emergencyAlternativeNo,
    'emergency_mobile_no' : emergencyMobileNo,
    'emergency_contacts_full_name' : emergencyContactsFullName
  };
}