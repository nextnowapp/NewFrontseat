class School {
  String? name;
  String? schoolId;
  String? isEnabled;
  String? schoolUrl;
  String? schoolLogo;

  School(
      {this.name,
      this.schoolId,
      this.schoolUrl,
      this.isEnabled,
      this.schoolLogo});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['school_name'],
      schoolId: json['school_id'],
      schoolUrl: json['school_url'],
      isEnabled: json['isEnabled'],
      schoolLogo: json['logo_url'],
    );
  }
}

class SchoolList {
  List<School> schools = [];

  SchoolList(this.schools);

  factory SchoolList.fromJson(List<dynamic> json) {
    List<School> classList;

    classList = json.map((i) => School.fromJson(i)).toList();

    return SchoolList(classList);
  }
}
