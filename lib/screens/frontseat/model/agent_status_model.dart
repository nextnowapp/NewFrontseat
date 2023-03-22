class AgentStatusModel {
  final bool? success;
  final Data? data;
  final String? message;

  AgentStatusModel({
    this.success,
    this.data,
    this.message,
  });

  AgentStatusModel.fromJson(Map<String, dynamic> json)
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
  final AgentStatusDetails? agentStatusDetails;

  Data({
    this.agentStatusDetails,
  });

  Data.fromJson(Map<String, dynamic> json)
    : agentStatusDetails = (json['AgentStatusDetails'] as Map<String,dynamic>?) != null ? AgentStatusDetails.fromJson(json['AgentStatusDetails'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'AgentStatusDetails' : agentStatusDetails?.toJson()
  };
}

class AgentStatusDetails {
  final dynamic latestComment;
  final String? latestStatus;
  final String? agentUnder;
  final dynamic finalDoc;

  AgentStatusDetails({
    this.latestComment,
    this.latestStatus,
    this.agentUnder,
    this.finalDoc,
  });

  AgentStatusDetails.fromJson(Map<String, dynamic> json)
    : latestComment = json['latest_comment'],
      latestStatus = json['latest_status'] as String?,
      agentUnder = json['agent_under'] as String?,
      finalDoc = json['final_doc'];

  Map<String, dynamic> toJson() => {
    'latest_comment' : latestComment,
    'latest_status' : latestStatus,
    'agent_under' : agentUnder,
    'final_doc' : finalDoc
  };
}