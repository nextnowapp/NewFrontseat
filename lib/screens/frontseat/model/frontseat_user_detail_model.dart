class UserDetailModel {
  final bool? success;
  final Data? data;
  final String? message;

  UserDetailModel({
    this.success,
    this.data,
    this.message,
  });

  UserDetailModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() =>
      {'success': success, 'data': data?.toJson(), 'message': message};
}

class Data {
  final AgentDetails? agentDetails;

  Data({
    this.agentDetails,
  });

  Data.fromJson(Map<String, dynamic> json)
      : agentDetails = (json['AgentDetails'] as Map<String, dynamic>?) != null
            ? AgentDetails.fromJson(
                json['AgentDetails'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'AgentDetails': agentDetails?.toJson()};
}

class AgentDetails {
  final int? agentId;
  final int? userId;
  final int? admissionNo;
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final String? dateOfBirth;
  final String? email;
  final String? mobile;
  final String? applicationEmail;
  final String? applicationPhone;
  final String? agentPhoto;
  final String? gender;
  final bool? profileUpdated;
  final bool? govtIdUploaded;
  final bool? personalInformationUpdated;
  final bool? bankingDocument;
  final bool? emailVerifiedAt;
  final bool? mobileVerified;
  final String? passportNumber;
  final String? maritalStatus;
  final String? equityGroup;
  final String? incomeTax;
  final String? disability;
  final String? nationality;
  final String? countryOfBirth;
  final String? residentialUnit;
  final String? residentialStreet;
  final String? residentialComplex;
  final String? residentialSuburb;
  final String? residentialCity;
  final String? residentialprovince;
  final String? residentialPostalCode;
  final String? postalUnit;
  final String? postalStreet;
  final String? postalComplex;
  final String? postalSuburb;
  final String? postalCity;
  final String? postalprovince;
  final String? postalPostalCode;
  final String? emergencyContactRelation;
  final String? emergencyContactFullName;
  final String? emergencyContactNumber;
  final String? emergencyAlternativeNumber;
  final String? workLocation;
  final String? workCity;
  final String? workProvince;
  final String? documentType;
  final String? drivingLicenseId;
  final String? idNumber;
  final String? countryName;
  final String? asylumDocNo;
  final String? passportNo;
  final String? accountType;
  final String? accHolderRelationship;
  final String? bankName;
  final String? bankBranchName;
  final String? bankBranchCode;
  final String? bankAccountNumber;
  final String? bankAccountHolderName;
  final String? agentStatus;
  final String? agentStatusComments;
  final String? drivingLicenceFrontImage;
  final String? drivingLicenceRearImage;
  final String? nationalIdFrontImage;
  final String? nationalIdRearImage;
  final String? bankStatement;
  final String? mtnNo;
  final String? agentCode;
  final List<AgentDocArray>? agentDocArray;

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
    this.residentialComplex,
    this.residentialStreet,
    this.residentialSuburb,
    this.residentialUnit,
    this.residentialCity,
    this.residentialprovince,
    this.residentialPostalCode,
    this.postalComplex,
    this.postalStreet,
    this.postalSuburb,
    this.postalUnit,
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
    this.drivingLicenceFrontImage,
    this.drivingLicenceRearImage,
    this.nationalIdFrontImage,
    this.nationalIdRearImage,
    this.bankStatement,
    this.mtnNo,
    this.agentCode,
    this.agentDocArray,
  });

  AgentDetails.fromJson(Map<String, dynamic> json)
      : agentId = json['agent_id'] as int?,
        userId = json['user_id'] as int?,
        admissionNo = json['admission_no'] as int?,
        title = json['title'] as String?,
        firstName = json['first_name'] as String?,
        middleName = json['middle_name'] as String?,
        lastName = json['last_name'] as String?,
        fullName = json['full_name'] as String?,
        dateOfBirth = json['date_of_birth'] as String?,
        email = json['email'] as String?,
        mobile = json['mobile'] as String?,
        applicationEmail = json['application_email'] as String?,
        applicationPhone = json['application_phone'] as String?,
        agentPhoto = json['agent_photo'] as String?,
        gender = json['gender'] as String?,
        profileUpdated = json['profileUpdated'] as bool?,
        govtIdUploaded = json['govtIdUploaded'] as bool?,
        personalInformationUpdated =
            json['personalInformationUpdated'] as bool?,
        bankingDocument = json['banking_document'] as bool?,
        emailVerifiedAt = json['email_verified_at'] as bool?,
        mobileVerified = json['mobile_verified'] as bool?,
        passportNumber = json['passportNumber'] as String?,
        maritalStatus = json['maritalStatus'] as String?,
        equityGroup = json['equityGroup'] as String?,
        incomeTax = json['incomeTax'] as String?,
        disability = json['disability'] as String?,
        nationality = json['nationality'] as String?,
        countryOfBirth = json['country_of_birth'] as String?,
        residentialUnit = json['residentialUnitNo'] as String?,
        residentialStreet = json['residentialStreetNo'] as String?,
        residentialComplex = json['residentialComplexName'] as String?,
        residentialSuburb = json['residentialSuburb'] as String?,
        residentialCity = json['residentialCity'] as String?,
        residentialprovince = json['residentialprovince'] as String?,
        residentialPostalCode = json['residentialPostalCode'] as String?,
        postalUnit = json['postalUnitNo'] as String?,
        postalStreet = json['postalStreetNo'] as String?,
        postalComplex = json['postalComplexName'] as String?,
        postalSuburb = json['postalSuburb'] as String?,
        postalCity = json['postalCity'] as String?,
        postalprovince = json['postalprovince'] as String?,
        postalPostalCode = json['postalPostalCode'] as String?,
        emergencyContactRelation = json['emergencyContactRelation'] as String?,
        emergencyContactFullName = json['emergencyContactFullName'] as String?,
        emergencyContactNumber = json['emergencyContactNumber'] as String?,
        emergencyAlternativeNumber =
            json['emergencyAlternativeNumber'] as String?,
        workLocation = json['workLocation'] as String?,
        workCity = json['workCity'] as String?,
        workProvince = json['workProvince'] as String?,
        documentType = json['documentType'] as String?,
        drivingLicenseId = json['drivingLicenseId'] as String?,
        idNumber = json['id_number'] as String?,
        countryName = json['countryName'] as String?,
        asylumDocNo = json['asylumDocNo'] as String?,
        passportNo = json['passportNo'] as String?,
        accountType = json['accountType'] as String?,
        accHolderRelationship = json['accHolderRelationship'] as String?,
        bankName = json['bankName'] as String?,
        bankBranchName = json['bankBranchName'] as String?,
        bankBranchCode = json['bankBranchCode'] as String?,
        bankAccountNumber = json['bankAccountNumber'] as String?,
        bankAccountHolderName = json['bankAccountHolderName'] as String?,
        agentStatus = json['agent_status'] as String?,
        agentStatusComments = json['agent_status_comments'] as String?,
        drivingLicenceFrontImage = json['drivingLicenceFrontImage'] as String?,
        drivingLicenceRearImage = json['drivingLicenceRearImage'] as String?,
        nationalIdFrontImage = json['nationalIdFrontImage'] as String?,
        nationalIdRearImage = json['nationalIdRearImage'] as String?,
        bankStatement = json['bankStatement'] as String?,
        mtnNo = json['mtn_mobile_no'] as String?,
        agentCode = json['agent_code'] as String?,
        agentDocArray = (json['AgentDocArray'] as List?)
            ?.map((dynamic e) =>
                AgentDocArray.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'agent_id': agentId,
        'user_id': userId,
        'admission_no': admissionNo,
        'title': title,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'email': email,
        'mobile': mobile,
        'application_email': applicationEmail,
        'application_phone': applicationPhone,
        'agent_photo': agentPhoto,
        'gender': gender,
        'profileUpdated': profileUpdated,
        'govtIdUploaded': govtIdUploaded,
        'personalInformationUpdated': personalInformationUpdated,
        'banking_document': bankingDocument,
        'email_verified_at': emailVerifiedAt,
        'mobile_verified': mobileVerified,
        'passportNumber': passportNumber,
        'maritalStatus': maritalStatus,
        'equityGroup': equityGroup,
        'incomeTax': incomeTax,
        'disability': disability,
        'nationality': nationality,
        'country_of_birth': countryOfBirth,
        'residentialUnitNo': residentialUnit,
        'residentialComplexName': residentialComplex,
        'residentialStreetNo': residentialStreet,
        'residentialSuburb': residentialSuburb,
        'residentialCity': residentialCity,
        'residentialprovince': residentialprovince,
        'residentialPostalCode': residentialPostalCode,
        'postalUnitNo': postalUnit,
        'postalComplexName': postalComplex,
        'postalStreetNo': postalStreet,
        'postalSuburb': postalSuburb,
        'postalCity': postalCity,
        'postalprovince': postalprovince,
        'postalPostalCode': postalPostalCode,
        'emergencyContactRelation': emergencyContactRelation,
        'emergencyContactFullName': emergencyContactFullName,
        'emergencyContactNumber': emergencyContactNumber,
        'emergencyAlternativeNumber': emergencyAlternativeNumber,
        'workLocation': workLocation,
        'workCity': workCity,
        'workProvince': workProvince,
        'documentType': documentType,
        'drivingLicenseId': drivingLicenseId,
        'id_number': idNumber,
        'countryName': countryName,
        'asylumDocNo': asylumDocNo,
        'passportNo': passportNo,
        'accountType': accountType,
        'accHolderRelationship': accHolderRelationship,
        'bankName': bankName,
        'bankBranchName': bankBranchName,
        'bankBranchCode': bankBranchCode,
        'bankAccountNumber': bankAccountNumber,
        'bankAccountHolderName': bankAccountHolderName,
        'agent_status': agentStatus,
        'agent_status_comments': agentStatusComments,
        'drivingLicenceFrontImage': drivingLicenceFrontImage,
        'drivingLicenceRearImage': drivingLicenceRearImage,
        'nationalIdFrontImage': nationalIdFrontImage,
        'nationalIdRearImage': nationalIdRearImage,
        'bankStatement': bankStatement,
        'mtn_mobile_no': mtnNo,
        'agent_code': agentCode,
        'AgentDocArray': agentDocArray?.map((e) => e.toJson()).toList()
      };
}

class AgentDocArray {
  final String? fileName;
  final String? filePath;

  AgentDocArray({
    this.fileName,
    this.filePath,
  });

  AgentDocArray.fromJson(Map<String, dynamic> json)
      : fileName = json['file_name'] as String?,
        filePath = json['file_path'] as String?;

  Map<String, dynamic> toJson() =>
      {'file_name': fileName, 'file_path': filePath};
}
