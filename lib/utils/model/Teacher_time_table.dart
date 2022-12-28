class TeacherTimeTable {
  bool? success;
  Data? data;
  String? message;

  TeacherTimeTable({this.success, this.data, this.message});

  TeacherTimeTable.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Classes>? classes;
  List<ClassTimes>? classTimes;
  String? classId;
  String? sectionId;
  List<SmWeekends>? smWeekends;

  Data(
      {this.classes,
      this.classTimes,
      this.classId,
      this.sectionId,
      this.smWeekends});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['classes'] != null) {
      classes = <Classes>[];
      json['classes'].forEach((v) {
        classes!.add(new Classes.fromJson(v));
      });
    }
    if (json['class_times'] != null) {
      classTimes = <ClassTimes>[];
      json['class_times'].forEach((v) {
        classTimes!.add(new ClassTimes.fromJson(v));
      });
    }
    classId = json['class_id'];
    sectionId = json['section_id'];
    if (json['sm_weekends'] != null) {
      smWeekends = <SmWeekends>[];
      json['sm_weekends'].forEach((v) {
        smWeekends!.add(new SmWeekends.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classes != null) {
      data['classes'] = this.classes!.map((v) => v.toJson()).toList();
    }
    if (this.classTimes != null) {
      data['class_times'] = this.classTimes!.map((v) => v.toJson()).toList();
    }
    data['class_id'] = this.classId;
    data['section_id'] = this.sectionId;
    if (this.smWeekends != null) {
      data['sm_weekends'] = this.smWeekends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classes {
  int? id;
  String? className;
  int? activeStatus;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;

  Classes(
      {this.id,
      this.className,
      this.activeStatus,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.schoolId,
      this.academicId});

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    activeStatus = json['active_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_name'] = this.className;
    data['active_status'] = this.activeStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    return data;
  }
}

class ClassTimes {
  int? id;
  String? type;
  String? period;
  String? startTime;
  String? endTime;
  String? isBreak;
  String? createdAt;
  String? updatedAt;
  int? schoolId;
  int? academicId;
  String? classTimeType;

  ClassTimes(
      {this.id,
      this.type,
      this.period,
      this.startTime,
      this.endTime,
      this.isBreak,
      this.createdAt,
      this.updatedAt,
      this.schoolId,
      this.academicId,
      this.classTimeType});

  ClassTimes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    period = json['period'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isBreak = json['is_break'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
    classTimeType = json['class_time_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['period'] = this.period;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_break'] = this.isBreak;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    data['class_time_type'] = this.classTimeType;
    return data;
  }
}

class SmWeekends {
  int? id;
  String? name;
  int? order;
  int? isWeekend;
  int? activeStatus;
  int? schoolId;
  String? createdAt;
  String? updatedAt;
  int? academicId;

  SmWeekends(
      {this.id,
      this.name,
      this.order,
      this.isWeekend,
      this.activeStatus,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.academicId});

  SmWeekends.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
    isWeekend = json['is_weekend'];
    activeStatus = json['active_status'];
    schoolId = json['school_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    academicId = json['academic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['is_weekend'] = this.isWeekend;
    data['active_status'] = this.activeStatus;
    data['school_id'] = this.schoolId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['academic_id'] = this.academicId;
    return data;
  }
}
