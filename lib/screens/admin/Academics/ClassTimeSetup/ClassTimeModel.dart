// To parse this JSON data, do
//
//     final classTimeModel = classTimeModelFromJson(jsonString);

import 'dart:convert';

ClassTimeModel classTimeModelFromJson(String str) =>
    ClassTimeModel.fromJson(json.decode(str));

String classTimeModelToJson(ClassTimeModel data) => json.encode(data.toJson());

class ClassTimeModel {
  ClassTimeModel({
    this.success,
    this.data,
  });

  bool? success;
  List<ClassTimeData>? data;

  factory ClassTimeModel.fromJson(Map<String, dynamic> json) => ClassTimeModel(
        success: json['success'] == null ? null : json['success'],
        data: json['data'] == null
            ? null
            : List<ClassTimeData>.from(
                json['data'].map((x) => ClassTimeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success == null ? null : success,
        'data': data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ClassTimeData {
  ClassTimeData({
    this.stTime,
    this.className,
    this.teacherName,
    this.dayName,
    this.classId,
    this.classPeriodId,
    this.routineId,
    this.teacherId,
    this.subjectId,
    this.subjectName,
    this.startTime,
    this.endTime,
    this.isBreak,
  });

  String? stTime;
  String? className;
  String? teacherName;
  String? dayName;
  int? classPeriodId;
  int? routineId;
  int? classId;
  int? teacherId;
  int? subjectId;
  String? subjectName;
  String? startTime;
  String? endTime;
  int? isBreak;

  factory ClassTimeData.fromJson(Map<String, dynamic> json) => ClassTimeData(
        stTime: json['st_time'] == null ? null : json['st_time'],
        className: json['class_name'] == null ? null : json['class_name'],
        classId: json['class_id'] == null ? null : json['class_id'],
        teacherName: json['teacher_name'] == null ? null : json['teacher_name'],
        dayName: json['day_name'] == null ? null : json['day_name'],
        classPeriodId:
            json['class_period_id'] == null ? null : json['class_period_id'],
        routineId: json['routine_id'] == null ? null : json['routine_id'],
        teacherId: json['teacher_id'] == null ? null : json['teacher_id'],
        subjectId: json['subject_id'] == null ? null : json['subject_id'],
        subjectName: json['subject_name'] == null ? null : json['subject_name'],
        startTime: json['start_time'] == null ? null : json['start_time'],
        endTime: json['end_time'] == null ? null : json['end_time'],
        isBreak: json['is_break'] == null ? null : json['is_break'],
      );

  Map<String, dynamic> toJson() => {
        'st_time': stTime == null ? null : stTime,
        'class_name': className == null ? null : className,
        'teacher_name': teacherName == null ? null : teacherName,
        'day_name': dayName == null ? null : dayName,
        'class_period_id': classPeriodId == null ? null : classPeriodId,
        'routine_id': routineId == null ? null : routineId,
        'teacher_id': teacherId == null ? null : teacherId,
        'subject_id': subjectId == null ? null : subjectId,
        'subject_name': subjectName == null ? null : subjectName,
        'start_time': startTime == null ? null : startTime,
        'end_time': endTime == null ? null : endTime,
        'is_break': isBreak == null ? null : isBreak,
      };
}
