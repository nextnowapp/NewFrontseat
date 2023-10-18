import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:sizer/sizer.dart';

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

class ClassSectionWiseCount extends StatefulWidget {
  const ClassSectionWiseCount({Key? key}) : super(key: key);

  @override
  State<ClassSectionWiseCount> createState() => _ClassSectionWiseCountState();
}

class _ClassSectionWiseCountState extends State<ClassSectionWiseCount> {
  var _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Today\'s Attendance Report',
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<dynamic>(
          future: getGradeWiseStudentCount(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Classes',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(
                                  snapshot.data.length,
                                  (index) => Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: size.width,
                                    decoration: const BoxDecoration(
                                      //add border
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Class ' +
                                          snapshot.data[index]['grade']
                                              .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: (snapshot.data.length + 1) * 50.0,
                        width: 100.w - 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Column(children: [
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Boys',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Girls',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Attendance',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...List.generate(snapshot.data.length, (index) {
                                int totalBoys =
                                    snapshot.data[index]['total_boys'] ?? 0;
                                int totalGirls =
                                    snapshot.data[index]['total_girls'] ?? 0;
                                int total = totalBoys + totalGirls;
                                int totalPresent =
                                    snapshot.data[index]['total_present'] ?? 0;
                                String totalAttendance = snapshot.data[index]
                                        ['total_attendence_percentage'] ??
                                    '0';
                                return Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        totalBoys.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        totalGirls.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        total.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                        //add border
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        (totalAttendance),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    //add border
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'M',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'T',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'W',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'T',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'F',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...List.generate(
                                  snapshot.data.length,
                                  (index) => Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                      //add border
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                    width: 200,
                                    child: AttendanceStatusRow(
                                      data: snapshot.data[index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ), // Row(
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future getGradeWiseStudentCount() async {
    //post request using dio
    Dio dio = new Dio();
    var response = await dio.post(
      InfixApi.gradeWiseStudentsCount,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          // progress = (received / total * 100).toDouble();
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });

    if (response.statusCode == 200) {
      print(response.data['data']);
      List<dynamic>? data = response.data['data'];
      return data;
    } else {
      print(response.statusCode);
    }
  }
}

class AttendanceStatusRow extends StatelessWidget {
  final Map<String, dynamic>? data;

  const AttendanceStatusRow({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: () {
            if (data!['attendance']['mon'] == 0) {
              return AbsentIcon;
            } else if (data!['attendance']['mon'] == 1 ||
                data!['attendance']['mon'] == null) {
              return PresentIcon;
            } else {
              return NoAttendanceIcon;
            }
          }(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: () {
            if (data!['attendance']['tues'] == 0) {
              return AbsentIcon;
            } else if (data!['attendance']['tues'] == 1 ||
                data!['attendance']['tues'] == null) {
              return PresentIcon;
            } else {
              return NoAttendanceIcon;
            }
          }(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: () {
            if (data!['attendance']['wed'] == 0) {
              return AbsentIcon;
            } else if (data!['attendance']['wed'] == 1 ||
                data!['attendance']['wed'] == null) {
              return PresentIcon;
            } else {
              return NoAttendanceIcon;
            }
          }(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: () {
            if (data!['attendance']['thurs'] == 0) {
              return AbsentIcon;
            } else if (data!['attendance']['thurs'] == 1 ||
                data!['attendance']['thurs'] == null) {
              return PresentIcon;
            } else {
              return NoAttendanceIcon;
            }
          }(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: () {
            if (data!['attendance']['fri'] == 0) {
              return AbsentIcon;
            } else if (data!['attendance']['fri'] == 1 ||
                data!['attendance']['fri'] == null) {
              return PresentIcon;
            } else {
              return NoAttendanceIcon;
            }
          }(),
        ),
      ],
    );
  }
}
