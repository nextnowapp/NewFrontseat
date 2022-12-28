// To parse this JSON data, do
//
//     final sectionModel = sectionModelFromJson(jsonString);

import 'dart:convert';

SectionModel sectionModelFromJson(String str) =>
    SectionModel.fromJson(json.decode(str));

String sectionModelToJson(SectionModel data) => json.encode(data.toJson());

class SectionModel {
  SectionModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<SectionList>? data;
  dynamic message;

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        success: json['success'],
        data: List<SectionList>.from(
            json['data'].map((x) => SectionList.fromJson(x))),
        message: json['message'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data!.map((x) => x.toJson())),
        'message': message,
      };
}

class SectionList {
  SectionList({
    this.id,
    this.sectionName,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
  });

  int? id;
  String? sectionName;
  int? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;

  factory SectionList.fromJson(Map<String, dynamic> json) => SectionList(
        id: json['id'],
        sectionName: json['section_name'],
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
        'section_name': sectionName,
        'active_status': activeStatus,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
        'created_by': createdBy,
        'updated_by': updatedBy,
        'school_id': schoolId,
        'academic_id': academicId,
      };
}
