// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  EventModel({
    this.success,
    this.data,
  });

  bool? success;
  List<EventsData>? data;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        success: json['success'] == null ? null : json['success'],
        data: json['data'] == null
            ? null
            : List<EventsData>.from(
                json['data'].map((x) => EventsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success == null ? null : success,
        'data': data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EventsData {
  EventsData({
    this.id,
    this.eventTitle,
    this.forWhom,
    this.eventLocation,
    this.eventDes,
    this.fromDate,
    this.toDate,
    this.upladImageFile,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
  });

  int? id;
  String? eventTitle;
  String? forWhom;
  String? eventLocation;
  String? eventDes;
  String? fromDate;
  String? toDate;
  String? upladImageFile;
  int? activeStatus;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;

  factory EventsData.fromJson(Map<String, dynamic> json) => EventsData(
        id: json['id'],
        eventTitle: json['event_title'],
        forWhom: json['for_whom'],
        eventLocation: json['event_location'],
        eventDes: json['event_des'],
        fromDate: json['from_date'],
        toDate: json['to_date'],
        upladImageFile: json['uplad_image_file'],
        activeStatus: json['active_status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        schoolId: json['school_id'],
        academicId: json['academic_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id == null ? null : id,
        'event_title': eventTitle == null ? null : eventTitle,
        'for_whom': forWhom == null ? null : forWhom,
        'event_location': eventLocation == null ? null : eventLocation,
        'event_des': eventDes == null ? null : eventDes,
        'from_date': fromDate,
        'to_date': toDate,
        'uplad_image_file': upladImageFile == null ? null : upladImageFile,
        'active_status': activeStatus == null ? null : activeStatus,
        'created_at': createdAt == null ? null : createdAt,
        'updated_at': updatedAt == null ? null : updatedAt,
        'created_by': createdBy == null ? null : createdBy,
        'updated_by': updatedBy == null ? null : updatedBy,
        'school_id': schoolId == null ? null : schoolId,
        'academic_id': academicId == null ? null : academicId,
      };
}
