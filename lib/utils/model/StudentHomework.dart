class Homework {
  int? id;
  String? description;
  String? subjectName;
  String? className;
  String? sectionName;
  String? homeworkDate;
  String? submissionDate;
  String? evaluationDate;
  String? fileUrl;
  String? status;
  String? marks;
  int? classId;
  int? sectionId;
  int? subjectId;
  String? obtainedMarks;

  Homework(
      {this.id,
      this.description,
      this.subjectName,
      this.className,
      this.sectionName,
      this.homeworkDate,
      this.submissionDate,
      this.evaluationDate,
      this.fileUrl,
      this.status,
      this.marks,
      this.classId,
      this.sectionId,
      this.subjectId,
      this.obtainedMarks});

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      description: json['description'],
      subjectName: json['subject_name'],
      className: json['class_name'],
      sectionName: json['section_name'],
      homeworkDate: json['homework_date'],
      submissionDate: json['submission_date'],
      evaluationDate: json['evaluation_date'],
      fileUrl: json['file'],
      status: json['status'],
      marks: json['marks'],
      obtainedMarks: json['obtained_marks'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      subjectId: json['subject_id'],
    );
  }
}

class HomeworkList {
  List<Homework> homeworks;

  HomeworkList(this.homeworks);

  factory HomeworkList.fromJson(List<dynamic> json) {
    List<Homework> homeworklist = [];
    homeworklist.clear();
    homeworklist = json.map((i) => Homework.fromJson(i)).toList();

    return HomeworkList(homeworklist);
  }
}


//new

// class HomeworkList {
//   bool? success;
//   List<Data>? data;
//   String? message;

//   HomeworkList({this.success, this.data, this.message});

//   HomeworkList.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? homeworkDate;
//   String? submissionDate;
//   String? createdBy;
//   String? className;
//   String? subjectName;
//   String? marks;
//   String? file;
//   String? description;
//   String? obtainedMarks;
//   String? status;

//   Data(
//       {this.id,
//       this.homeworkDate,
//       this.submissionDate,
//       this.createdBy,
//       this.className,
//       this.subjectName,
//       this.marks,
//       this.file,
//       this.description,
//       this.obtainedMarks,
//       this.status});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     homeworkDate = json['homework_date'];
//     submissionDate = json['submission_date'];
//     createdBy = json['created_by'];
//     className = json['class_name'];
//     subjectName = json['subject_name'];
//     marks = json['marks'];
//     file = json['file'];
//     description = json['description'];
//     obtainedMarks = json['obtained_marks'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['homework_date'] = this.homeworkDate;
//     data['submission_date'] = this.submissionDate;
//     data['created_by'] = this.createdBy;
//     data['class_name'] = this.className;
//     data['subject_name'] = this.subjectName;
//     data['marks'] = this.marks;
//     data['file'] = this.file;
//     data['description'] = this.description;
//     data['obtained_marks'] = this.obtainedMarks;
//     data['status'] = this.status;
//     return data;
//   }
// }