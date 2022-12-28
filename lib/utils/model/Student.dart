class Student {
  int id;
  int uid;
  int sId;
  String? photo;
  String name;
  int? roll;
  String? className;
  String? attendanceType;

  Student(
      {required this.id,
      required this.sId,
      this.photo,
      required this.name,
      this.roll,
      this.className,
      required this.uid,
      this.attendanceType});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      sId: json['student_id'],
      photo: json['student_photo'],
      name: json['full_name'],
      roll: json['roll_no'],
      className: json['class_name'],
      attendanceType: json['attendance_type'],
      uid: json['student_user_id'],
    );
  }
}

class StudentList {
  List<Student> students;

  StudentList(this.students);

  factory StudentList.fromJson(List<dynamic> json) {
    List<Student> studentlist = [];

    studentlist = json.map((i) => Student.fromJson(i)).toList();

    return StudentList(studentlist);
  }
}
