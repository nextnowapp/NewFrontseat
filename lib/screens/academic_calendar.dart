import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';

class AcademicCalendar extends StatefulWidget {
  const AcademicCalendar({Key? key}) : super(key: key);

  @override
  State<AcademicCalendar> createState() => _AcademicCalendarState();
}

class _AcademicCalendarState extends State<AcademicCalendar> {
  var schoolId;

  @override
  void initState() {
    super.initState();
  }

  var academicCalendar =
      'https://firebasestorage.googleapis.com/v0/b/nextschool-1bc0d.appspot.com/o/Calendar.jpeg?alt=media&token=46a65f0f-78de-48d6-88c9-02275b999cc0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Academic Calendar',
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Academic Calendar helps you to keep track of your school's academic calendar. It is a great way to keep track of your school's academic calendar and to make sure that you are on track to be successful in your studies.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: InteractiveViewer(
                        maxScale: 3,
                        panEnabled: true,
                        scaleEnabled: true,
                        child: Image.network(academicCalendar,
                            fit: BoxFit.contain),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
