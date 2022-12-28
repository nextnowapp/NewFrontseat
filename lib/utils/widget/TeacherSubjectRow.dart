// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/model/TeacherSubject.dart';

// ignore: must_be_immutable
class TeacherSubjectRowLayout extends StatelessWidget {
  TeacherSubject subject;

  TeacherSubjectRowLayout(this.subject);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(subject.subjectName!,
                    style: Theme.of(context).textTheme.headline5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
