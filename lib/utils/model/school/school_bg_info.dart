class SchoolBgInfo {
  final String? favicon;
  final String? schoolName;
  final String? founded;
  final String? ourSlogan;
  final String? ourVision;
  final String? ourValues;
  final String? ourMission;
  final String? ourHistory;

//define constructor
  SchoolBgInfo({
    this.favicon,
    this.schoolName,
    this.founded,
    this.ourSlogan,
    this.ourVision,
    this.ourValues,
    this.ourMission,
    this.ourHistory,
  });

//define fromJson method
  factory SchoolBgInfo.fromJson(Map<String, dynamic> json) {
    return SchoolBgInfo(
      favicon: json['favicon'] ?? '',
      schoolName: json['school_name'] ?? '',
      founded: json['founded'] ?? '',
      ourSlogan: json['our_slogan'] ?? '',
      ourVision: json['our_vision'] ?? '',
      ourValues: json['our_values'] ?? '',
      ourMission: json['our_mission'] ?? '',
      ourHistory: json['our_history'] ?? '',
    );
  }
}
