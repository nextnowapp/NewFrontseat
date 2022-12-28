class TeacherSubject {
  String? subjectName;
  String? subjectType;
  int? subjectId;

  TeacherSubject({this.subjectName, this.subjectType, this.subjectId});

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      subjectName: json['subject_name'],
      subjectType: json['subject_type'],
      subjectId: json['id'] ?? json['id'],
    );
  }
}

class TeacherSubjectList {
  List<TeacherSubject> subjects;

  TeacherSubjectList(this.subjects);

  factory TeacherSubjectList.fromJson(List<dynamic> json) {
    List<TeacherSubject> subjects = [];

    subjects = json.map((i) => TeacherSubject.fromJson(i)).toList();

    return TeacherSubjectList(subjects);
  }
}
