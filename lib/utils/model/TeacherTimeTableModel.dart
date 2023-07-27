// To parse this JSON data, do
//
//     final teacherTimeTableModel = teacherTimeTableModelFromJson(jsonString);

import 'dart:convert';

TeacherTimeTableModel teacherTimeTableModelFromJson(String str) => TeacherTimeTableModel.fromJson(json.decode(str));

String teacherTimeTableModelToJson(TeacherTimeTableModel data) => json.encode(data.toJson());

class TeacherTimeTableModel {
    TeacherTimeTableModel({
        this.success,
        this.data,
        this.message,
    });

    bool? success;
    Data? data;
    dynamic message;

    factory TeacherTimeTableModel.fromJson(Map<String, dynamic> json) => TeacherTimeTableModel(
        success: json['success'] == null ? null : json['success'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
        message: json['message'],
    );

    Map<String, dynamic> toJson() => {
        'success': success == null ? null : success,
        'data': data == null ? null : data!.toJson(),
        'message': message,
    };
}

class Data {
    Data({
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
    });

    List<Day>? monday;
    List<Day>? tuesday;
    List<Day>? wednesday;
    List<Day>? thursday;
    List<Day>? friday;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        monday: json['Monday'] == null ? null : List<Day>.from(json['Monday'].map((x) => Day.fromJson(x))),
        tuesday: json['Tuesday'] == null ? null : List<Day>.from(json['Tuesday'].map((x) => Day.fromJson(x))),
        wednesday: json['Wednesday'] == null ? null : List<Day>.from(json['Wednesday'].map((x) => Day.fromJson(x))),
        thursday: json['Thursday'] == null ? null : List<Day>.from(json['Thursday'].map((x) => Day.fromJson(x))),
        friday: json['Friday'] == null ? null : List<Day>.from(json['Friday'].map((x) => Day.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'Monday': monday == null ? null : List<dynamic>.from(monday!.map((x) => x.toJson())),
        'Tuesday': tuesday == null ? null : List<dynamic>.from(tuesday!.map((x) => x.toJson())),
        'Wednesday': wednesday == null ? null : List<dynamic>.from(wednesday!.map((x) => x.toJson())),
        'Thursday': thursday == null ? null : List<dynamic>.from(thursday!.map((x) => x.toJson())),
        'Friday': friday == null ? null : List<dynamic>.from(friday!.map((x) => x.toJson())),
    };
}

class Day {
    Day({
        this.period,
        this.startTime,
        this.endTime,
        this.subjectName,
    });

    String? period;
    String? startTime;
    String? endTime;
    String? subjectName;

    factory Day.fromJson(Map<String, dynamic> json) => Day(
        period: json['period'] == null ? null : json['period'],
        startTime: json['start_time'] == null ? null : json['start_time'],
        endTime: json['end_time'] == null ? null : json['end_time'],
        subjectName: json['subject_name'] == null ? null : json['subject_name'],
    );

    Map<String, dynamic> toJson() => {
        'period': period == null ? null : period,
        'start_time': startTime == null ? null : startTime,
        'end_time': endTime == null ? null : endTime,
        'subject_name': subjectName == null ? null : subjectName,
    };
}
