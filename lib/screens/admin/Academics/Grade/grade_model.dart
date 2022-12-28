// To parse this JSON data, do
//
//     final gradeModel = gradeModelFromJson(jsonString);

import 'dart:convert';

GradeModel gradeModelFromJson(String str) => GradeModel.fromJson(json.decode(str));

String gradeModelToJson(GradeModel data) => json.encode(data.toJson());

class GradeModel {
  GradeModel({
    this.success,
    this.data,
  });

  bool? success;
  Data? data;

  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
    success: json['success'],
    data: Data.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data!.toJson(),
  };
}

class Data {
  Data({
    this.classes,
  });

  List<Class>? classes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    classes: List<Class>.from(json['classes'].map((x) => Class.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'classes': List<dynamic>.from(classes!.map((x) => x.toJson())),
  };
}

class Class {
  Class({
    this.id,
    this.className,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.assignedSectionsName,
    this.assignedSectionId,
  });

  int? id;
  String? className;
  int? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;
  List<String>? assignedSectionsName;
  List<int>? assignedSectionId;

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    id: json['id'],
    className: json['class_name'],
    activeStatus: json['active_status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    schoolId: json['school_id'],
    academicId: json['academic_id'],
    // assignedSectionsName: List<String>.from(json['assigned_sections_name'].map((x) => x)),
    // assignedSectionId: List<int>.from(json['assigned_section_id'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'class_name': className,
    'active_status': activeStatus,
    'created_at': createdAt!.toIso8601String(),
    'updated_at': updatedAt!.toIso8601String(),
    'created_by': createdBy,
    'updated_by': updatedBy,
    'school_id': schoolId,
    'academic_id': academicId,
    'assigned_sections_name': List<dynamic>.from(assignedSectionsName!.map((x) => x)),
    'assigned_section_id': List<dynamic>.from(assignedSectionId!.map((x) => x)),
  };
}
