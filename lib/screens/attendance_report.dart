import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  var _token;
  Future? _attendanceReport;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    _attendanceReport = getAttendanceReport();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Attendance Report',
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: FutureBuilder<dynamic>(
            future: _attendanceReport,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data.length);
                      return AttendanceReportCard(
                        data: snapshot.data[index],
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future getAttendanceReport() async {
    final response = await http.post(
        Uri.parse(InfixApi.teacherAttendanceReport()),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return jsonData['data'];
      throw Exception('Failed to load');
    }
  }
}

class AttendanceReportCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  AttendanceReportCard({
    Key? key,
    this.data,
  }) : super(key: key);

  var PresentIcon = const Icon(
    Icons.check_circle,
    color: Colors.green,
    size: 20,
  );

  var NoAttendanceIcon = const Icon(
    Icons.remove_circle_rounded,
    color: Colors.grey,
    size: 20,
  );

  var AbsentIcon = const Icon(
    Icons.cancel,
    color: Colors.red,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 10,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                       InfixApi().root + '${data!['staff_photo']}',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data!['first_name']} ${data!['last_name']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'Grade: ${data!['grade']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Class: ${data!['class']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF222744),
              ),
              child: Center(
                child: Text(
                  'Attendance from: ' +
                      data!['attendance_start_date'] +
                      ' to ' +
                      data!['attendance_end_date'],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),

            //row containing days with attendance
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 243, 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'M',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          data!.containsKey('attendance')
                              ? (data!['attendance']['mon'] == 0
                                  ? AbsentIcon
                                  : PresentIcon)
                              : NoAttendanceIcon,
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'T',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          data!.containsKey('attendance')
                              ? (data!['attendance']['tues'] == 0
                                  ? AbsentIcon
                                  : PresentIcon)
                              : NoAttendanceIcon,
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'W',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          data!.containsKey('attendance')
                              ? (data!['attendance']['wed'] == 0
                                  ? AbsentIcon
                                  : PresentIcon)
                              : NoAttendanceIcon,
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'T',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          data!.containsKey('attendance')
                              ? (data!['attendance']['thurs'] == 0
                                  ? AbsentIcon
                                  : PresentIcon)
                              : NoAttendanceIcon,
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'F',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          data!.containsKey('attendance')
                              ? (data!['attendance']['fri'] == 0
                                  ? AbsentIcon
                                  : PresentIcon)
                              : NoAttendanceIcon,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
