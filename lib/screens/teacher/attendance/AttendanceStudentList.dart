// // Dart imports:
//
// // Flutter imports:
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide FormData;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// // Package imports:
// import 'package:http/http.dart' as http;
// import 'package:nextschool/controller/attendance_list_controller.dart';
// import 'package:nextschool/controller/attendance_stat_controller.dart';
// import 'package:nextschool/controller/user_controller.dart';
// import 'package:nextschool/screens/teacher/ClassAttendanceHome.dart';
// import 'package:nextschool/screens/teacher/attendance/AttendanceScreen.dart';
// // Project imports:
// import 'package:nextschool/utils/CustomAppBarWidget.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/apis/Apis.dart';
// import 'package:nextschool/utils/model/GlobalClass.dart';
// import 'package:nextschool/utils/model/Student.dart';
// import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
// import 'package:nextschool/utils/widget/StudentAttendanceRow.dart';
// import 'package:nextschool/utils/widget/submit_button.dart';
// import 'package:sizer/sizer.dart';
// import 'package:animated_button/animated_button.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
//
//
// // ignore: must_be_immutable
// class StudentListAttendance extends StatefulWidget {
//   int? classCode;
//   String? url;
//   String? date;
//   String? token;
//
//   StudentListAttendance({this.classCode, this.url, this.date, this.token});
//
//   @override
//   _StudentListAttendanceState createState() => _StudentListAttendanceState(
//       classCode: classCode, date: date, url: url, token: token);
// }
//
// class _StudentListAttendanceState extends State<StudentListAttendance> {
//   int? classCode;
//   String? url;
//   Future<StudentList>? students;
//   String? date;
//   List<String> absent = [];
//   var function = GlobalDatae();
//   GlobalKey _key = GlobalKey();
//   String? token;
//   bool attendanceDone = false;
//
//   late SimulatedSubmitController _simulatedSubmitAttendanceController;
//   String? _errorMessage;
//   AttendanceListController attendanceListController =
//       Get.put(AttendanceListController());
//
//   UserDetailsController userDetailsController =
//       Get.put(UserDetailsController());
//
//   _StudentListAttendanceState(
//       {this.classCode, this.url, this.date, this.token});
//
//   final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//
//   void _doSomething() async {
//     Timer(Duration(seconds: 1), () {
//       _btnController.success();
//     });
//                   AttendanceStatController attendanceStatController =
//                       Get.put(AttendanceStatController());
//                   await attendanceStatController.fetchAttendanceStat();
//                   attendanceListController.getStatus();
//                   setAttendance();
//   }
//
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   setState(() {
//   //     newStudents = getAttendance();
//   //   });
//   // }
//
//   @override
//   void initState() {
//     _simulatedSubmitAttendanceController = SimulatedSubmitController(
//       onOpenError: () {
//         // Utils.showErrorBottomSheet(context, 'Error ⚠️', _errorMessage);
//       },
//       onOpenSuccess: () {
//         // Utils.showSuccessBottomSheet(context, 'Attendance added Successfully 🚀');
//       },
//       onPressed: onPressed,
//     );
//
//     attendanceListController.fetchStudentList(url!);
//     super.initState();
//   }
//
//   Future<void> onPressed() async {
//     Utils.showProcessingToast();
//     AttendanceStatController attendanceStatController =
//     Get.put(AttendanceStatController());
//     await attendanceStatController.fetchAttendanceStat();
//     attendanceListController.getStatus();
//     setAttendance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       appBar: CustomAppBarWidget(
//         title: 'Take Attendance for $date',
//       ),
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: Obx(() {
//               return attendanceListController.dataFetched
//                   ? ListView.builder(
//                       itemCount: attendanceListController.totalCount,
//                       key: UniqueKey(),
//                       itemBuilder: (context, index) {
//                         return StudentAttendanceRow(
//                           index,
//                         );
//                       },
//                     )
//                   : ListView.builder(
//                       itemCount: 10,
//                       itemBuilder: (context, index) {
//                         return ShimmerList(
//                           itemCount: 1,
//                           height: 80,
//                         );
//                       },
//                     );
//             }),
//           ),
//         ],
//       ),
//       bottomNavigationBar:  Container(
//         alignment: Alignment.center,
//           height: 70,
//           child:RoundedLoadingButton(
//             color: HexColor('#6f9eff'),
//             child: Text('Submit Attendance', style: TextStyle(color: Colors.white)),
//             controller: _btnController,
//             onPressed: _doSomething,
//             resetAfterDuration: true,
//             resetDuration: Duration(seconds: 4),
//             successColor: HexColor('#6f9eff'),
//           )
//         ),
//     );
//   }
//
//   void sentNotificationToSection() async {
//     final response = await http.get(Uri.parse(
//         InfixApi.sentNotificationToSection(
//             'Attendance', 'Attendance sunmitted', '$classCode')));
//     if (response.statusCode == 200) {}
//   }
//
//   setAttendance() async {
//     var response = await http.post(
//       Uri.parse(InfixApi.markAttendance()),
//       body: {
//         'date': date,
//         'present': attendanceListController.presentStudentList.toString(),
//         'absent': attendanceListController.absentStudentList.toString(),
//         'late': attendanceListController.lateStudentList.toString(),
//       },
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': userDetailsController.token.toString(),
//       },
//     );
//
//     jsonDecode(response.body);
//     print(response.body);
//     if (response.statusCode == 200) {
//       showAlertDialog(context);
//     } else {
//       Utils.showToast('Failed to load');
//     }
//   }
//
//   showAlertDialog(BuildContext context1) {
//     showDialog<void>(
//       barrierDismissible: false,
//       context: _key.currentContext!,
//       builder: (BuildContext context) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height * 0.5,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.white,
//               child: Material(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       width: double.infinity,
//                       height: 45,
//                       color: const Color(0xffecf8ff),
//                       child: Center(
//                         child: Text(
//                           'Daily Attendance Report',
//                           style: TextStyle(
//                             color: const Color(0xfff222744),
//                             fontFamily:
//                                 GoogleFonts.inter(fontWeight: FontWeight.w700)
//                                     .fontFamily,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20, bottom: 10.0),
//                       child: Icon(Icons.check_circle_rounded,
//                           size: 60, color: HexColor('#4FBE9E')),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: Text(
//                           'Success',
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 85, 192, 161),
//                             fontFamily:
//                                 GoogleFonts.inter(fontWeight: FontWeight.w600)
//                                     .fontFamily,
//                             fontSize: 14.sp,
//                           ),
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 15, bottom: 10, left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Class : ${attendanceListController.attendanceList.first.className}',
//                             style: TextStyle(
//                                 color: const Color(0xfff222744),
//
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.calendar_month,
//                                 color: Color(0xffff2b346d),
//                                 size: 20,
//                               ),
//                               Text(
//                                 date!,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 'Total',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 'Present',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Obx(
//                                 () => Text(
//                                   '${attendanceListController.totalPresentCount}',
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: const Color(0xfff222744),
//                                       fontFamily:
//                                           GoogleFonts.inter().fontFamily,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             height: 80,
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 'Total',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 'Absent',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Obx(
//                                 () => Text(
//                                   '${attendanceListController.totalAbsentCount}',
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: const Color(0xfff222744),
//                                       fontFamily:
//                                           GoogleFonts.inter().fontFamily,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             height: 80,
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 'Total',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 'Late',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Obx(
//                                 () => Text(
//                                   '${attendanceListController.totalLateCount}',
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: const Color(0xfff222744),
//                                       fontFamily:
//                                           GoogleFonts.inter().fontFamily,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             height: 80,
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 'Total',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 'Student',
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: const Color(0xfff222744),
//
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Obx(
//                                 () => Text(
//                                   '${attendanceListController.totalCount}',
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: const Color(0xfff222744),
//                                       fontFamily:
//                                           GoogleFonts.inter().fontFamily,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         GestureDetector(
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             height: 50.0,
//                             decoration: BoxDecoration(
//                                 // color: HexColor('#073763'),
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 border: Border.all(color: HexColor('#111B5B'))),
//                             child: Text(
//                               'Modify',
//                               style: TextStyle(
//                                 color: HexColor('#111B5B'),
//                                 fontFamily: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w700)
//                                     .fontFamily,
//                                 fontSize: 12.sp,
//                               ),
//                             ),
//                           ),
//                           onTap: () {
//                             sentNotificationToSection();
//                             Navigator.pop(context);
//                           },
//                         ),
//                         InkWell(
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             height: 50.0,
//                             decoration: BoxDecoration(
//                               color: HexColor('#111B5B'),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Text(
//                               'Done',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w700)
//                                     .fontFamily,
//                                 fontSize: 12.sp,
//                               ),
//                             ),
//                           ),
//                           onTap: () {
//                             sentNotificationToSection();
//                             Navigator.of(context).popUntil((route) => route.isFirst);
//                             Navigator.of(context).popUntil( (Route<dynamic> route) => true);
//                             // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => StudentAttendanceHome()));
//                           },
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
// Dart imports:

// Flutter imports:
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/attendance_list_controller.dart';
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/GlobalClass.dart';
import 'package:nextschool/utils/model/Student.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
import 'package:nextschool/utils/widget/StudentAttendanceRow.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class StudentListAttendance extends StatefulWidget {
  int? classCode;
  String? url;
  String? date;
  String? token;

  StudentListAttendance({this.classCode, this.url, this.date, this.token});

  @override
  _StudentListAttendanceState createState() => _StudentListAttendanceState(
      classCode: classCode, date: date, url: url, token: token);
}

class _StudentListAttendanceState extends State<StudentListAttendance> {
  int? classCode;
  String? url;
  Future<StudentList>? students;
  String? date;
  List<String> absent = [];
  var function = GlobalDatae();
  String? token;
  bool attendanceDone = false;
  AttendanceListController attendanceListController =
      Get.put(AttendanceListController());

  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());
  AttendanceStatController attendanceStatController =
      Get.put(AttendanceStatController());

  _StudentListAttendanceState(
      {this.classCode, this.url, this.date, this.token});

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     newStudents = getAttendance();
  //   });
  // }

  void _doSomething() async {
    Timer(const Duration(seconds: 1), () {
      _btnController.success();
    });
    Utils.showProcessingToast();

    attendanceListController.getStatus();
    setAttendance();
  }

  @override
  void initState() {
    attendanceListController.fetchStudentList(url!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Take Attendance for $date',
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() {
              return attendanceListController.dataFetched
                  ? ListView.builder(
                      itemCount: attendanceListController.totalCount,
                      key: UniqueKey(),
                      itemBuilder: (context, index) {
                        return StudentAttendanceRow(
                          index,
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ShimmerList(
                          itemCount: 1,
                          height: 80,
                        );
                      },
                    );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          alignment: Alignment.center,
          height: 70,
          child: RoundedLoadingButton(
            color: HexColor('#6f9eff'),
            child: const Text('Submit Attendance',
                style: TextStyle(color: Colors.white)),
            controller: _btnController,
            onPressed: _doSomething,
            resetAfterDuration: true,
            resetDuration: const Duration(seconds: 2),
            successColor: HexColor('#6f9eff'),
          )),
    );
    // SizedBox(
    //   height: 70,
    //   child: Container(
    //     alignment: Alignment.center,
    //     child: Padding(
    //       padding: const EdgeInsets.only(
    //           bottom: 15.0, left: 10.0, right: 10.0, top: 10.0),
    //       child: InkWell(
    //         child: Container(
    //           alignment: Alignment.center,
    //           height: 50.0,
    //           // decoration: Utils.BtnDecoration,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(25),
    //               border: Border.all(
    //                 color: HexColor('#6f9eff'), // red as border color
    //               ),
    //               color: HexColor('#6f9eff')),
    //           child: const Text('',
    //               style: TextStyle(
    //                   fontWeight: FontWeight.w500, color: Colors.white)),
    //         ),
    //         onTap: () async {
    //           Utils.showProcessingToast();
    //           AttendanceStatController attendanceStatController =
    //           Get.put(AttendanceStatController());
    //           await attendanceStatController.fetchAttendanceStat();
    //           attendanceListController.getStatus();
    //           setAttendance();
    //         },
    //       ),
    //     ),
    //   ),
    // ),
    // );
  }

  setAttendance() async {
    var response = await http.post(
      Uri.parse(InfixApi.markAttendance()),
      body: {
        'date': date,
        'present': attendanceListController.presentStudentList.toString(),
        'absent': attendanceListController.absentStudentList.toString(),
        'late': attendanceListController.lateStudentList.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': userDetailsController.token.toString(),
      },
    ).catchError((e) {
      var msg = e.response.data['message'];
      Utils.showErrorToast(msg);
    });

    jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      showAlertDialog(context);
      await attendanceStatController.fetchAttendanceStat();
    } else if (response.statusCode == 500) {
      var msg = jsonDecode(response.body)['message'];
      Utils.showErrorToast(msg);
    } else {
      Utils.showErrorToast('Something went wrong');
    }
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context2).size.height * 0.5,
              width: MediaQuery.of(context2).size.width,
              color: Colors.white,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 45,
                      color: const Color(0xffecf8ff),
                      child: Center(
                        child: Text(
                          'Daily Attendance Report',
                          style: TextStyle(
                            color: const Color(0xfff222744),
                            fontFamily:
                                GoogleFonts.inter(fontWeight: FontWeight.w700)
                                    .fontFamily,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                      child: Icon(Icons.check_circle_rounded,
                          size: 60, color: HexColor('#4FBE9E')),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Success',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 85, 192, 161),
                            fontFamily:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)
                                    .fontFamily,
                            fontSize: 14.sp,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 10, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Class : ${attendanceListController.attendanceList.first.className.toString()}',
                            style: TextStyle(
                                color: const Color(0xfff222744),
                                //
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Color(0xffff2b346d),
                                size: 20,
                              ),
                              Text(
                                date!,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    //
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Present',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    //
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Obx(
                                () => Text(
                                  '${attendanceListController.totalPresentCount}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: const Color(0xfff222744),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 80,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Absent',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Obx(
                                () => Text(
                                  '${attendanceListController.totalAbsentCount}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: const Color(0xfff222744),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 80,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Late',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Obx(
                                () => Text(
                                  '${attendanceListController.totalLateCount}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: const Color(0xfff222744),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 80,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Student',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color(0xfff222744),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Obx(
                                () => Text(
                                  '${attendanceListController.totalCount}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: const Color(0xfff222744),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context2).size.width * 0.4,
                            height: 50.0,
                            decoration: BoxDecoration(
                                // color: HexColor('#073763'),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: HexColor('#111B5B'))),
                            child: Text(
                              'Modify',
                              style: TextStyle(
                                color: HexColor('#111B5B'),
                                fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700)
                                    .fontFamily,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context2);
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context2).size.width * 0.4,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: HexColor('#111B5B'),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700)
                                    .fontFamily,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(
                              context2,
                              rootNavigator: true,
                            ).pop('dialog');
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
