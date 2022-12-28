// To parse this JSON data, do
//
//     final remarksModel = remarksModelFromJson(jsonString);

import 'dart:convert';

RemarksModel remarksModelFromJson(String str) => RemarksModel.fromJson(json.decode(str));

String remarksModelToJson(RemarksModel data) => json.encode(data.toJson());

class RemarksModel {
    RemarksModel({
        this.success,
        this.data,
        this.message,
    });

    bool? success;
    Remark? data;
    String? message;

    factory RemarksModel.fromJson(Map<String, dynamic> json) => RemarksModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Remark.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data!.toJson(),
        "message": message == null ? null : message,
    };
}

class Remark {
    Remark({
        this.merit,
        this.demerit,
    });

    List<Merit>? merit;
    List<Merit>? demerit;

    factory Remark.fromJson(Map<String, dynamic> json) => Remark(
        merit: json["Merit"] == null ? null : List<Merit>.from(json["Merit"].map((x) => Merit.fromJson(x))),
        demerit: json["Demerit"] == null ? null : List<Merit>.from(json["Demerit"].map((x) => Merit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Merit": merit == null ? null : List<dynamic>.from(merit!.map((x) => x.toJson())),
        "Demerit": demerit == null ? null : List<dynamic>.from(demerit!.map((x) => x.toJson())),
    };
}

class Merit {
    Merit({
        this.id,
        this.meritsType,
        this.meritDate,
        this.teacherName,
        this.studentsName,
        this.className,
        this.remarks,
    });

    int? id;
    String? meritsType;
    DateTime? meritDate;
    String? teacherName;
    String? studentsName;
    String? className;
    String? remarks;

    factory Merit.fromJson(Map<String, dynamic> json) => Merit(
        id: json["id"] == null ? null : json["id"],
        meritsType: json["merits_type"] == null ? null : json["merits_type"],
        meritDate: json["merit_date"] == null ? null : DateTime.parse(json["merit_date"]),
        teacherName: json["teacher_name"] == null ? null : json["teacher_name"],
        studentsName: json["students_name"] == null ? null : json["students_name"],
        className: json["class_name"] == null ? null : json["class_name"],
        remarks: json["remarks"] == null ? null : json["remarks"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "merits_type": meritsType == null ? null : meritsType,
        "merit_date": meritDate == null ? null : "${meritDate!.day.toString().padLeft(2, '0')}-${meritDate!.month.toString().padLeft(2, '0')}-${meritDate!.year.toString().padLeft(4, '0')}",
        "teacher_name": teacherName == null ? null : teacherName,
        "students_name": studentsName == null ? null : studentsName,
        "class_name": className == null ? null : className,
        "remarks": remarks == null ? null : remarks,
    };
}
