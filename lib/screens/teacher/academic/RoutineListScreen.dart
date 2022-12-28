// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/widget/Routine_row.dart';

// ignore: must_be_immutable
class StudentRoutine extends StatelessWidget {
  List<String> weeks = AppFunction.weeks;
  int? classCode;
  int? sectionCode;

  StudentRoutine(this.classCode, this.sectionCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'TimeTable'),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: weeks.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.hardEdge,
            elevation: 2.0,
            child: RoutineRow(
              title: weeks[index],
              classCode: classCode,
              sectionCode: sectionCode,
            ),
          );
        },
      ),
    );
  }
}
