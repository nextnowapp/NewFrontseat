class UserDetailModel {
  bool? success;
  Data? data;
  String? message;

  UserDetailModel({
    this.success,
    this.data,
    this.message,
  });

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;
    message = json['message'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    json['data'] = data?.toJson();
    json['message'] = message;
    return json;
  }
}

class Data {
  AgentDetails? agentDetails;

  Data({
    this.agentDetails,
  });

  Data.fromJson(Map<String, dynamic> json) {
    agentDetails = (json['AgentDetails'] as Map<String,dynamic>?) != null ? AgentDetails.fromJson(json['AgentDetails'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['AgentDetails'] = agentDetails?.toJson();
    return json;
  }
}

class AgentDetails {
  int? agentId;
  int? userId;
  int? admissionNo;
  String? title;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? dateOfBirth;
  String? email;
  String? mobile;
  String? applicationEmail;
  String? applicationPhone;
  String? agentPhoto;
  String? gender;
  bool? profileUpdated;
  bool? govtIdUploaded;
  bool? personalInformationUpdated;
  bool? bankingDocument;
  bool? emailVerifiedAt;
  bool? mobileVerified;
  String? passportNumber;
  String? maritalStatus;
  String? equityGroup;
  String? incomeTax;
  String? disability;
  String? nationality;
  String? countryOfBirth;
  String? residentialAddress;
  String? residentialCity;
  String? residentialprovince;
  String? residentialPostalCode;
  String? postalAddress;
  String? postalCity;
  String? postalprovince;
  String? postalPostalCode;
  String? emergencyContactRelation;
  String? emergencyContactFullName;
  String? emergencyContactNumber;
  String? emergencyAlternativeNumber;
  String? workLocation;
  String? workCity;
  String? workProvince;
  dynamic documentType;
  String? drivingLicenseId;
  String? idNumber;
  dynamic countryName;
  dynamic asylumDocNo;
  dynamic passportNo;
  String? accountType;
  String? accHolderRelationship;
  String? bankName;
  String? bankBranchName;
  String? bankBranchCode;
  String? bankAccountNumber;
  String? bankAccountHolderName;
  dynamic agentStatus;
  dynamic agentStatusComments;

  AgentDetails({
    this.agentId,
    this.userId,
    this.admissionNo,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.dateOfBirth,
    this.email,
    this.mobile,
    this.applicationEmail,
    this.applicationPhone,
    this.agentPhoto,
    this.gender,
    this.profileUpdated,
    this.govtIdUploaded,
    this.personalInformationUpdated,
    this.bankingDocument,
    this.emailVerifiedAt,
    this.mobileVerified,
    this.passportNumber,
    this.maritalStatus,
    this.equityGroup,
    this.incomeTax,
    this.disability,
    this.nationality,
    this.countryOfBirth,
    this.residentialAddress,
    this.residentialCity,
    this.residentialprovince,
    this.residentialPostalCode,
    this.postalAddress,
    this.postalCity,
    this.postalprovince,
    this.postalPostalCode,
    this.emergencyContactRelation,
    this.emergencyContactFullName,
    this.emergencyContactNumber,
    this.emergencyAlternativeNumber,
    this.workLocation,
    this.workCity,
    this.workProvince,
    this.documentType,
    this.drivingLicenseId,
    this.idNumber,
    this.countryName,
    this.asylumDocNo,
    this.passportNo,
    this.accountType,
    this.accHolderRelationship,
    this.bankName,
    this.bankBranchName,
    this.bankBranchCode,
    this.bankAccountNumber,
    this.bankAccountHolderName,
    this.agentStatus,
    this.agentStatusComments,
  });

  AgentDetails.fromJson(Map<String, dynamic> json) {
    agentId = json['agent_id'] as int?;
    userId = json['user_id'] as int?;
    admissionNo = json['admission_no'] as int?;
    title = json['title'] as String?;
    firstName = json['first_name'] as String?;
    middleName = json['middle_name'] as String?;
    lastName = json['last_name'] as String?;
    fullName = json['full_name'] as String?;
    dateOfBirth = json['date_of_birth'] as String?;
    email = json['email'] as String?;
    mobile = json['mobile'] as String?;
    applicationEmail = json['application_email'] as String?;
    applicationPhone = json['application_phone'] as String?;
    agentPhoto = json['agent_photo'] as String?;
    gender = json['gender'] as String?;
    profileUpdated = json['profileUpdated'] as bool?;
    govtIdUploaded = json['govtIdUploaded'] as bool?;
    personalInformationUpdated = json['personalInformationUpdated'] as bool?;
    bankingDocument = json['banking_document'] as bool?;
    emailVerifiedAt = json['email_verified_at'] as bool?;
    mobileVerified = json['mobile_verified'] as bool?;
    passportNumber = json['passportNumber'] as String?;
    maritalStatus = json['maritalStatus'] as String?;
    equityGroup = json['equityGroup'] as String?;
    incomeTax = json['incomeTax'] as String?;
    disability = json['disability'] as String?;
    nationality = json['nationality'] as String?;
    countryOfBirth = json['country_of_birth'] as String?;
    residentialAddress = json['residentialAddress'] as String?;
    residentialCity = json['residentialCity'] as String?;
    residentialprovince = json['residentialprovince'] as String?;
    residentialPostalCode = json['residentialPostalCode'] as String?;
    postalAddress = json['postalAddress'] as String?;
    postalCity = json['postalCity'] as String?;
    postalprovince = json['postalprovince'] as String?;
    postalPostalCode = json['postalPostalCode'] as String?;
    emergencyContactRelation = json['emergencyContactRelation'] as String?;
    emergencyContactFullName = json['emergencyContactFullName'] as String?;
    emergencyContactNumber = json['emergencyContactNumber'] as String?;
    emergencyAlternativeNumber = json['emergencyAlternativeNumber'] as String?;
    workLocation = json['workLocation'] as String?;
    workCity = json['workCity'] as String?;
    workProvince = json['workProvince'] as String?;
    documentType = json['documentType'];
    drivingLicenseId = json['drivingLicenseId'] as String?;
    idNumber = json['id_number'] as String?;
    countryName = json['countryName'];
    asylumDocNo = json['asylumDocNo'];
    passportNo = json['passportNo'];
    accountType = json['accountType'] as String?;
    accHolderRelationship = json['accHolderRelationship'] as String?;
    bankName = json['bankName'] as String?;
    bankBranchName = json['bankBranchName'] as String?;
    bankBranchCode = json['bankBranchCode'] as String?;
    bankAccountNumber = json['bankAccountNumber'] as String?;
    bankAccountHolderName = json['bankAccountHolderName'] as String?;
    agentStatus = json['agent_status'];
    agentStatusComments = json['agent_status_comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['agent_id'] = agentId;
    json['user_id'] = userId;
    json['admission_no'] = admissionNo;
    json['title'] = title;
    json['first_name'] = firstName;
    json['middle_name'] = middleName;
    json['last_name'] = lastName;
    json['full_name'] = fullName;
    json['date_of_birth'] = dateOfBirth;
    json['email'] = email;
    json['mobile'] = mobile;
    json['application_email'] = applicationEmail;
    json['application_phone'] = applicationPhone;
    json['agent_photo'] = agentPhoto;
    json['gender'] = gender;
    json['profileUpdated'] = profileUpdated;
    json['govtIdUploaded'] = govtIdUploaded;
    json['personalInformationUpdated'] = personalInformationUpdated;
    json['banking_document'] = bankingDocument;
    json['email_verified_at'] = emailVerifiedAt;
    json['mobile_verified'] = mobileVerified;
    json['passportNumber'] = passportNumber;
    json['maritalStatus'] = maritalStatus;
    json['equityGroup'] = equityGroup;
    json['incomeTax'] = incomeTax;
    json['disability'] = disability;
    json['nationality'] = nationality;
    json['country_of_birth'] = countryOfBirth;
    json['residentialAddress'] = residentialAddress;
    json['residentialCity'] = residentialCity;
    json['residentialprovince'] = residentialprovince;
    json['residentialPostalCode'] = residentialPostalCode;
    json['postalAddress'] = postalAddress;
    json['postalCity'] = postalCity;
    json['postalprovince'] = postalprovince;
    json['postalPostalCode'] = postalPostalCode;
    json['emergencyContactRelation'] = emergencyContactRelation;
    json['emergencyContactFullName'] = emergencyContactFullName;
    json['emergencyContactNumber'] = emergencyContactNumber;
    json['emergencyAlternativeNumber'] = emergencyAlternativeNumber;
    json['workLocation'] = workLocation;
    json['workCity'] = workCity;
    json['workProvince'] = workProvince;
    json['documentType'] = documentType;
    json['drivingLicenseId'] = drivingLicenseId;
    json['id_number'] = idNumber;
    json['countryName'] = countryName;
    json['asylumDocNo'] = asylumDocNo;
    json['passportNo'] = passportNo;
    json['accountType'] = accountType;
    json['accHolderRelationship'] = accHolderRelationship;
    json['bankName'] = bankName;
    json['bankBranchName'] = bankBranchName;
    json['bankBranchCode'] = bankBranchCode;
    json['bankAccountNumber'] = bankAccountNumber;
    json['bankAccountHolderName'] = bankAccountHolderName;
    json['agent_status'] = agentStatus;
    json['agent_status_comments'] = agentStatusComments;
    return json;
  }
}