class Attendance {
  int? id;
  int? uid;
  int? sId;
  String? photo;
  String? name;
  int? roll;
  String? className;
  String? attendanceType;
  String attendanceStatus;

  Attendance(
      {this.id,
      this.sId,
      this.photo,
      this.name,
      this.roll,
      this.className,
      this.attendanceType,
      required this.attendanceStatus,
      this.uid});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      sId: json['student_id'],
      photo: json['student_photo'],
      name: json['full_name'],
      roll: json['roll_no'],
      className: json['class_name'],
      attendanceType: json['attendance_type'],
      uid: json['user_id'],
      attendanceStatus: json['attendance_type'] ?? 'P',
    );
  }
}

class AttendanceList {
  List<Attendance> attendances;

  AttendanceList(this.attendances);

  factory AttendanceList.fromJson(List<dynamic> json) {
    List<Attendance> attendanceList = [];

    attendanceList = json.map((i) => Attendance.fromJson(i)).toList();

    return AttendanceList(attendanceList);
  }
}
