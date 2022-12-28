// To parse this JSON data, do
//
//     final adminNoticeModel = adminNoticeModelFromJson(jsonString);

import 'dart:convert';

AdminNoticeModel adminNoticeModelFromJson(String str) =>
    AdminNoticeModel.fromJson(json.decode(str));

String adminNoticeModelToJson(AdminNoticeModel data) =>
    json.encode(data.toJson());

class AdminNoticeModel {
  AdminNoticeModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<Datum>? data;
  dynamic message;

  factory AdminNoticeModel.fromJson(Map<String, dynamic> json) =>
      AdminNoticeModel(
        success: json['success'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data!.map((x) => x.toJson())),
        'message': message,
      };
}

class Datum {
  Datum({
    this.id,
    this.noticeTitle,
    this.noticeMessage,
    this.noticeDate,
    this.publishOn,
    this.informTo,
    this.activeStatus,
    this.isPublished,
    this.createdBy,
    this.updatedBy,
    this.noticeImage,
    this.imageUrl,
  });

  int? id;
  String? noticeTitle;
  String? noticeMessage;
  String? noticeDate;
  String? publishOn;
  String? informTo;
  int? activeStatus;
  int? isPublished;
  int? createdBy;
  int? updatedBy;
  String? noticeImage;
  String? imageUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'],
        noticeTitle: json['notice_title'],
        noticeMessage: json['notice_message'],
        noticeDate: json['notice_date'],
        publishOn: json['publish_on'],
        informTo: json['inform_to'],
        activeStatus: json['active_status'],
        isPublished: json['is_published'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        noticeImage: json['notice_image'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'notice_title': noticeTitle,
        'notice_message': noticeMessage,
        'notice_date': noticeDate,
        'publish_on': publishOn,
        'inform_to': informTo,
        'active_status': activeStatus,
        'is_published': isPublished,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'notice_image': noticeImage,
        'image_url': imageUrl,
      };
}
