// To parse this JSON data, do
//
//     final timeTypeModel = timeTypeModelFromJson(jsonString);

import 'dart:convert';

TimeTypeModel timeTypeModelFromJson(String str) => TimeTypeModel.fromJson(json.decode(str));

String timeTypeModelToJson(TimeTypeModel data) => json.encode(data.toJson());

class TimeTypeModel {
  TimeTypeModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<TypeList>? data;
  dynamic message;

  factory TimeTypeModel.fromJson(Map<String, dynamic> json) => TimeTypeModel(
    success: json['success'],
    data: List<TypeList>.from(json['data'].map((x) => TypeList.fromJson(x))),
    message: json['message'],
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': List<dynamic>.from(data!.map((x) => x.toJson())),
    'message': message,
  };
}

class TypeList {
  TypeList({
    this.id,
    this.typeName,
    this.assignGrades,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.className,
  });

  int? id;
  String? typeName;
  String? assignGrades;
  String? className;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TypeList.fromJson(Map<String, dynamic> json) => TypeList(
    id: json['id'],
    typeName: json['type_name'],
    className: json['class_name'],
    assignGrades: json['assign_grades'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type_name': typeName,
    'class_name': className,
    'assign_grades': assignGrades,
    'status': status,
    'created_at': createdAt!.toIso8601String(),
    'updated_at': updatedAt!.toIso8601String(),
  };
}
