// To parse this JSON data, do
//
//     final classRoomModel = classRoomModelFromJson(jsonString);

import 'dart:convert';

ClassRoomModel classRoomModelFromJson(String str) => ClassRoomModel.fromJson(json.decode(str));

String classRoomModelToJson(ClassRoomModel data) => json.encode(data.toJson());

class ClassRoomModel {
  ClassRoomModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<ClassRoomListModel>? data;
  dynamic message;

  factory ClassRoomModel.fromJson(Map<String, dynamic> json) => ClassRoomModel(
    success: json['success'],
    data: List<ClassRoomListModel>.from(json['data'].map((x) => ClassRoomListModel.fromJson(x))),
    message: json['message'],
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': List<dynamic>.from(data!.map((x) => x.toJson())),
    'message': message,
  };
}

class ClassRoomListModel {
  ClassRoomListModel({
    this.id,
    this.roomNo,
    this.capacity,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
  });

  int? id;
  String? roomNo;
  int? capacity;
  int? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;

  factory ClassRoomListModel.fromJson(Map<String, dynamic> json) => ClassRoomListModel(
    id: json['id'],
    roomNo: json['room_no'],
    capacity: json['capacity'],
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
    'room_no': roomNo,
    'capacity': capacity,
    'active_status': activeStatus,
    'created_at': createdAt!.toIso8601String(),
    'updated_at': updatedAt!.toIso8601String(),
    'created_by': createdBy,
    'updated_by': updatedBy,
    'school_id': schoolId,
    'academic_id': academicId,
  };
}
