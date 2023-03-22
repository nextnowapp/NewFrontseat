class KycStatusModel {
  final bool? success;
  final Data? data;
  final String? message;

  KycStatusModel({
    this.success,
    this.data,
    this.message,
  });

  KycStatusModel.fromJson(Map<String, dynamic> json)
    : success = json['success'] as bool?,
      data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null,
      message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'data' : data?.toJson(),
    'message' : message
  };
}

class Data {
  final AgentKYCDetails? agentKYCDetails;

  Data({
    this.agentKYCDetails,
  });

  Data.fromJson(Map<String, dynamic> json)
    : agentKYCDetails = (json['AgentKYCDetails'] as Map<String,dynamic>?) != null ? AgentKYCDetails.fromJson(json['AgentKYCDetails'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'AgentKYCDetails' : agentKYCDetails?.toJson()
  };
}

class AgentKYCDetails {
  final bool? profileUpdated;
  final bool? govtIdUploaded;
  final bool? personalInformationUpdated;
  final bool? bankingDocument;
  final bool? emailVerifiedAt;
  final bool? mobileVerified;
  final dynamic agentStatus;

  AgentKYCDetails({
    this.profileUpdated,
    this.govtIdUploaded,
    this.personalInformationUpdated,
    this.bankingDocument,
    this.emailVerifiedAt,
    this.mobileVerified,
    this.agentStatus,
  });

  AgentKYCDetails.fromJson(Map<String, dynamic> json)
    : profileUpdated = json['profileUpdated'] as bool?,
      govtIdUploaded = json['govtIdUploaded'] as bool?,
      personalInformationUpdated = json['personalInformationUpdated'] as bool?,
      bankingDocument = json['banking_document'] as bool?,
      emailVerifiedAt = json['email_verified_at'] as bool?,
      mobileVerified = json['mobile_verified'] as bool?,
      agentStatus = json['agent_status'];

  Map<String, dynamic> toJson() => {
    'profileUpdated' : profileUpdated,
    'govtIdUploaded' : govtIdUploaded,
    'personalInformationUpdated' : personalInformationUpdated,
    'banking_document' : bankingDocument,
    'email_verified_at' : emailVerifiedAt,
    'mobile_verified' : mobileVerified,
    'agent_status' : agentStatus
  };
}