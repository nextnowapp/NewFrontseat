// To parse this JSON data, do
//
//     final designationModel = designationModelFromJson(jsonString);

import 'dart:convert';

DesignationModel designationModelFromJson(String str) => DesignationModel.fromJson(json.decode(str));

String designationModelToJson(DesignationModel data) => json.encode(data.toJson());

class DesignationModel {
    DesignationModel({
        this.success,
        this.data,
        this.message,
    });

    bool? success;
    List<DesignationData>? data;
    dynamic? message;

    factory DesignationModel.fromJson(Map<String, dynamic> json) => DesignationModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : List<DesignationData>.from(json["data"].map((x) => DesignationData.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DesignationData {
    DesignationData({
        this.id,
        this.title,
        this.activeStatus,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.schoolId,
        this.isSaas,
    });

    int? id;
    String? title;
    int? activeStatus;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? createdBy;
    int? updatedBy;
    int? schoolId;
    int? isSaas;

    factory DesignationData.fromJson(Map<String, dynamic> json) => DesignationData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        activeStatus: json["active_status"] == null ? null : json["active_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        schoolId: json["school_id"] == null ? null : json["school_id"],
        isSaas: json["is_saas"] == null ? null : json["is_saas"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "active_status": activeStatus == null ? null : activeStatus,
        "created_at": createdAt == null ? null : createdAt.toString(),
        "updated_at": updatedAt == null ? null : updatedAt.toString(),
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "school_id": schoolId == null ? null : schoolId,
        "is_saas": isSaas == null ? null : isSaas,
    };
}
