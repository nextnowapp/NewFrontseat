// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/model/ClassExamList.dart';

import '../FunctionsData.dart';

// ignore: must_be_immutable
class StudentExamRow extends StatelessWidget {
  classExam exam;

  StudentExamRow(this.exam);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  // color: Colors.purple,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Subject:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Text(
                          exam.subjectName == null ? 'N/A' : exam.subjectName!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Room No : ',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      exam.roomNo == null ? 'N/A' : exam.roomNo!,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              exam.date == null ? 'N/A' : exam.date!,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Start',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              exam.startTime == null
                                  ? 'N/A'
                                  : AppFunction.getAmPm(exam.startTime!),
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'End',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              exam.endTime == null
                                  ? 'N/A'
                                  : AppFunction.getAmPm(exam.endTime!),
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 0.5,
                //   margin: EdgeInsets.only(top: 10.0),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //         begin: Alignment.centerRight,
                //         end: Alignment.centerLeft,
                //         colors: [Colors.purple, Colors.deepPurple]),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
