class ClassTimeListClass {
  bool? success;
  List<Data>? data;
  String? message;

  ClassTimeListClass({this.success, this.data, this.message});

  ClassTimeListClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? className;
  int? id;
  String? type;
  String? period;
  String? startTime;
  String? endTime;
  int? isBreak;
  String? createdAt;
  String? updatedAt;
  int? schoolId;
  int? academicId;
  String? classTimeType;
  String? teacherName;
  String? dayName;
  int? routineId;
  int? teacherId;

  Data(
      {this.className,
      this.id,
      this.type,
      this.period,
      this.startTime,
      this.endTime,
      this.isBreak,
      this.createdAt,
      this.updatedAt,
      this.schoolId,
      this.academicId,
      this.classTimeType,
      this.teacherName,
      this.dayName,
      this.routineId,
      this.teacherId});

  Data.fromJson(Map<String, dynamic> json) {
    className = json['class_name'];
    id = json['id'];
    type = json['type'];
    period = json['period'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isBreak = json['is_break'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
    classTimeType = json['class_time_type'];
    teacherName = json['teacher_name'];
    dayName = json['day_name'];
    routineId = json['routine_id'];
    teacherId = json['teacher_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_name'] = this.className;
    data['id'] = this.id;
    data['type'] = this.type;
    data['period'] = this.period;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_break'] = this.isBreak;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    data['class_time_type'] = this.classTimeType;
    data['teacher_name'] = this.teacherName;
    data['day_name'] = this.dayName;
    data['routine_id'] = this.routineId;
    data['teacher_id'] = this.teacherId;
    return data;
  }
}
