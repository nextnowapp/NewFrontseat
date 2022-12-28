// To parse this JSON data, do
//
//     final subjectListModel = subjectListModelFromJson(jsonString);

import 'dart:convert';

SubjectListModel subjectListModelFromJson(String str) =>
    SubjectListModel.fromJson(json.decode(str));

String subjectListModelToJson(SubjectListModel data) =>
    json.encode(data.toJson());

class SubjectListModel {
  SubjectListModel({
    this.success,
    this.data,
  });

  bool? success;
  List<Subject>? data;

  factory SubjectListModel.fromJson(Map<String, dynamic> json) =>
      SubjectListModel(
        success: json['success'],
        data: List<Subject>.from(json['data'].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Subject {
  Subject({
    this.id,
    this.subjectName,
    this.subjectType,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
  });

  int? id;
  String? subjectName;
  String? subjectType;
  int? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        subjectName: json['subject_name'],
        subjectType: json['subject_type'],
        activeStatus: json['active_status'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        schoolId: json['school_id'],
        academicId: json['academic_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_name': subjectName,
        'subject_type': subjectType,
        'active_status': activeStatus,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
        'created_by': createdBy,
        'updated_by': updatedBy,
        'school_id': schoolId,
        'academic_id': academicId,
      };
}
