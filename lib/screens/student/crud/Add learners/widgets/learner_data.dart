import 'dart:io';

class LearnerDetails {
   String? learnerFName;
   String? learnerMName;
   String? learnerLName;
   String? learnerClass;
   String? learnerGrade;
   String? learnerDOB;
   String? learnerId;
   String? genderId;
   File? learnerPhoto;
   String? parent1FName;
   String? parent1MName;
   String? parent1LName;
   String? parent1Email;
   String? parent1Phone;
   String? parent1Nid;
   String? parent1DOB;
   String? parent1Occupation;
   String? parent1Relation;
   String? parent1LAddress;
   File? parent1Photo;
   String? parent2FName;
   String? parent2MName;
   String? parent2LName;
   String? parent2Email;
   String? parent2Phone;
   String? parent2Nid;
   String? parent2DOB;
   String? parent2Occupation;
   String? parent2Relation;
   String? parent2LAddress;
   File? parent2Photo;
   File? document1;
   File? document2;
   File? document3;

  LearnerDetails(
      {this.learnerFName,
      this.learnerMName,
      this.learnerLName,
      this.learnerClass,
      this.learnerGrade,
      this.learnerDOB,
      this.learnerId,
      this.genderId,
      this.learnerPhoto,
      this.parent1FName,
      this.parent1MName,
      this.parent1LName,
      this.parent1Email,
      this.parent1Phone,
      this.parent1Nid,
      this.parent1DOB,
      this.parent1Occupation,
      this.parent1Relation,
      this.parent1LAddress,
      this.parent1Photo,
      this.parent2FName,
      this.parent2MName,
      this.parent2LName,
      this.parent2Email,
      this.parent2Phone,
      this.parent2Nid,
      this.parent2DOB,
      this.parent2Occupation,
      this.parent2Relation,
      this.parent2LAddress,
      this.parent2Photo,
      this.document1,
      this.document2,
      this.document3});
  
LearnerDetails copyWith({
   String? learnerFName,
   String? learnerMName,
   String? learnerLName,
   String? learnerClass,
   String? learnerGrade,
   String? learnerDOB,
   String? learnerId,
   String? genderId,
   File? learnerPhoto,
   String? parent1FName,
   String? parent1MName,
   String? parent1LName,
   String? parent1Email,
   String? parent1Phone,
   String? parent1Nid,
   String? parent1DOB,
   String? parent1Occupation,
   String? parent1Relation,
   String? parent1LAddress,
   File? parent1Photo,
   String? parent2FName,
   String? parent2MName,
   String? parent2LName,
   String? parent2Email,
   String? parent2Phone,
   String? parent2Nid,
   String? parent2DOB,
   String? parent2Occupation,
   String? parent2Relation,
   String? parent2LAddress,
   File? parent2Photo,
   File? document1,
   File? document2,
   File? document3,
  }) {
    return LearnerDetails(
        learnerFName: learnerFName ?? this.learnerFName,
      learnerMName: learnerMName ?? this.learnerMName,
      learnerLName: learnerLName ?? this.learnerLName,
      learnerClass: learnerClass ?? this.learnerClass,
      learnerGrade: learnerGrade ?? this.learnerGrade,
      learnerDOB: learnerDOB ?? this.learnerDOB,
      learnerId: learnerId ?? this.learnerId,
      genderId: genderId ?? this.genderId,
      learnerPhoto: learnerPhoto ?? this.learnerPhoto,
      parent1FName: parent1FName ?? this.parent1FName,
      parent1MName: parent1MName ?? this.parent1MName,
      parent1LName: parent1LName ?? this.parent1LName,
      parent1Email: parent1Email ?? this.parent1Email,
      parent1Phone: parent1Phone ?? this.parent1Phone,
      parent1Nid: parent1Nid ?? this.parent1Nid,
      parent1DOB: parent1DOB ?? this.parent1DOB,
      parent1Occupation: parent1Occupation ?? this.parent1Occupation,
      parent1Relation: parent1Relation ?? this.parent1Relation,
      parent1LAddress: parent1LAddress ?? this.parent1LAddress,
      parent1Photo: parent1Photo ?? this.parent1Photo,
      parent2FName: parent2FName ?? this.parent2FName,
      parent2MName: parent2MName ?? this.parent2MName,
      parent2LName: parent2LName ?? this.parent2LName,
      parent2Email: parent2Email ?? this.parent2Email,
      parent2Phone: parent2Phone ?? this.parent2Phone,
      parent2Nid: parent2Nid ?? this.parent2Nid,
      parent2DOB: parent2DOB ?? this.parent2DOB,
      parent2Occupation: parent2Occupation ?? this.parent2Occupation,
      parent2Relation: parent2Relation ?? this.parent2Relation,
      parent2LAddress: parent2LAddress ?? this.parent2LAddress,
      parent2Photo: parent2Photo ?? this.parent2Photo,
      document1: document1 ?? this.document1,
      document2: document2 ?? this.document2,
      document3: document3 ?? this.document3,
    );
  }
}
