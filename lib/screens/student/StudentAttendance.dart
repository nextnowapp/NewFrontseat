// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Child.dart';
import 'package:nextschool/utils/model/StudentAttendance.dart';

// ignore: must_be_immutable
class StudentAttendanceScreen extends StatefulWidget {
  var id;
  var token;
  String? studentName;
  String? studentGrade;
  String? studentClass;
  String? studentPhoto;
  StudentAttendanceScreen(
      {this.id,
      this.token,
      this.studentName,
      this.studentGrade,
      this.studentClass,
      this.studentPhoto});

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState(id: id, token: token);
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  var id;
  String? token;
  Future<StudentAttendanceList?>? attendances;
  Future<ChildList?>? childs;
  _StudentAttendanceScreenState({this.id, this.token});

  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    token = userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (id != null) {
      DateTime date = DateTime.now();
      attendances = getAllStudentAttendance(id, date.month, date.year, token);
    } else {
      Utils.getStringValue('id').then((value) {
        print(value);
        setState(() {
          id = int.parse(value!);
          DateTime date = DateTime.now();
          attendances =
              getAllStudentAttendance(id, date.month, date.year, token);
        });
        Utils.getStringValue('id').then((value) {
          setState(() {
            childs = getAllStudent(value);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = widget.studentPhoto == null || widget.studentPhoto == ''
        ? 'http://saskolhmg.com/images/studentprofile.png'
        : InfixApi().root + widget.studentPhoto!;
    Size size = MediaQuery.of(context).size;
    var _currentDate;
    var _markedDateMap;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Attendance',
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          userDetailsController.roleId != 3
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: Colors.white,
                        boxShadow: [
                          const BoxShadow(
                            blurRadius: 0.1,
                          ),
                        ],
                      ),
                      width: 350,
                      height: 120,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          minVerticalPadding: 0,
                          horizontalTitleGap: 0,
                          leading: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(image),
                            backgroundColor: Colors.grey,
                          ),
                          subtitle: Text(
                            'Grade:' + widget.studentGrade.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#94a4b9')),
                          ),
                          title: Text(
                            widget.studentName.toString(),
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(width: 10, color: HexColor('#74d1b6'))

                      // top: BorderSide(width: 10, color: Colors.green),
                      // left: BorderSide(width: 10, color: Colors.green),
                      // right: BorderSide(width: 10, color: Colors.green),
                      // bottom: BorderSide(width: 10, color: Colors.green)),
                      ),
                  padding: const EdgeInsets.all(20),
                  child: CalendarCarousel<Event>(
                      // height: MediaQuery.of(context).size.height * 0.5,
                      weekDayPadding: const EdgeInsets.all(5),
                      onDayPressed: (DateTime date, List<Event> events) {
                        this.setState(() => _currentDate = date);
                      },
                      onCalendarChanged: (DateTime date) {
                        setState(() {
                          attendances = getAllStudentAttendance(
                              widget.id, date.month, date.year, token);
                        });
                      },
                      showHeader: true,
                      leftButtonIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor('#88d7c0')),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      rightButtonIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor('#88d7c0')),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      headerMargin: const EdgeInsets.symmetric(vertical: 16.0),
                      // headerText:
                      //     '${DateFormat.yMMMMd().format(DateTime.no())}'
                      //         .toString(),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      thisMonthDayBorderColor: Colors.grey,
                      daysTextStyle: Theme.of(context).textTheme.headline4,
                      showOnlyCurrentMonthDate: false,
                      headerTitleTouchable: true,
                      prevMonthDayBorderColor: Colors.green,
                      headerTextStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: ScreenUtil().setSp(14.0)),
                      weekdayTextStyle: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(
                              fontSize: ScreenUtil().setSp(13.0),
                              fontWeight: FontWeight.w500,
                              color: HexColor('#9abbff')),
                      customDayBuilder: (
                        /// you can provide your own build function to make custom day containers
                        bool isSelectable,
                        int index,
                        bool isSelectedDay,
                        bool isToday,
                        bool isPrevMonthDay,
                        TextStyle textStyle,
                        bool isNextMonthDay,
                        bool isThisMonthDay,
                        DateTime day,
                      ) {
                        return FutureBuilder<StudentAttendanceList?>(
                          future: attendances,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              //Utils.showToast(getAttendanceStatus(day.day, snapshot.data.attendances));

                              String? status = getAttendanceStatus(
                                  day.day, snapshot.data!.attendances);

                              // print('DAY : ${day.day} STATUS : $status');
                              // print('STATUS : $status');
                              if (isThisMonthDay) {
                                if (isToday) {
                                  return Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: ScreenUtil().setWidth(35),
                                          height: ScreenUtil().setHeight(20),
                                          decoration: BoxDecoration(
                                              color: HexColor('#4e88ff'),
                                              shape: BoxShape.circle
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.grey.withOpacity(0.5),
                                              //     spreadRadius: 2,
                                              //     blurRadius: 5,
                                              //     offset: const Offset(0, 3),
                                              //   ),
                                              // ],
                                              ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(day.day.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: ScreenUtil()
                                                            .setSp(14.0),
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 1.5,
                                      ),
                                      Container(
                                        width: 5.0,
                                        height: 5.0,
                                        decoration: BoxDecoration(
                                          color: getStatusColor(status),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                day.day.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                      color:
                                                          HexColor('#6f83a0'),
                                                      fontSize: ScreenUtil()
                                                          .setSp(14.0),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 1.5,
                                      ),
                                      Container(
                                        width: 5.0,
                                        height: 5.0,
                                        decoration: BoxDecoration(
                                          color: getStatusColor(status),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        child: Text(day.day.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    fontSize: ScreenUtil()
                                                        .setSp(14.0),
                                                    color: isToday == true
                                                        ? Colors.white
                                                        : Colors
                                                            .grey.shade300)),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return Column(
                                children: [
                                  Center(
                                    child: Container(
                                      child: Text(day.day.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color:
                                                      const Color(0xFF727FC8))),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                      weekFormat: false,
                      markedDatesMap: _markedDateMap,
                      selectedDateTime: _currentDate,
                      // daysHaveCircularBorder: true,
                      todayButtonColor: Colors.transparent,
                      todayBorderColor: Colors.transparent,
                      todayTextStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white)),
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                const Text(
                  'Monthly Attendance Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),

                bottomDesign('Present', 'P', Colors.green),
                bottomDesign('Absent', 'A', Colors.red),
                bottomDesign('Late', 'L', const Color(0xFFEDD200)),
                // bottomDesign('Halfday', 'H', Colors.purpleAccent),
                bottomDesign('Holiday', 'H', Colors.deepPurpleAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomDesign(String title, String titleVal, Color color) {
    return FutureBuilder<StudentAttendanceList?>(
        future: attendances,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 20.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: color,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black45, fontWeight: FontWeight.w500),
                  )),
                  Text(getStatusCount(titleVal, snapshot.data!.attendances),
                      style: Theme.of(context).textTheme.headline5),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 100,
                  //     child: PieChart(
                  //       dataMap: {
                  //         title: double.parse(
                  //           (getStatusCount(
                  //                   titleVal, snapshot.data!.attendances)
                  //               .replaceAll('days', '')),
                  //         ),
                  //       },
                  //       chartType: ChartType.ring,
                  //       // colorList: getStatusColor(titleVal),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Future<StudentAttendanceList?>? getAllStudentAttendance(
      var id, int month, int year, String? token) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentAttendence(id, month, year)),
        headers: Utils.setHeader(token!));

    debugPrint(InfixApi.getStudentAttendence(id, month, year));
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      print('JSON: $jsonData');

      return StudentAttendanceList.fromJson(jsonData['data']['attendances']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  String? getAttendanceStatus(int date, List<StudentAttendance> attendances) {
    // print("ATTENTDENCE LEN : ${attendances.length}");
    return getStatus(0, attendances.length - 1, attendances, date);
  }

  String? getStatus(
      int i, int j, List<StudentAttendance> attendances, int date) {
    String? status;
    for (int a = i; a <= j; a++) {
      if (int.parse(AppFunction.getDay(attendances[a].date!)) == date) {
        status = attendances[a].type;
        // print(AppFunction.getDay(attendances[a].date).substring(1));
        // print(date.toString());
        // break;
      }
    }
    return status;
  }

  getStatusColor(String? status) {
    switch (status) {
      case 'P':
        return Colors.green;
        break;
      case 'A':
        return Colors.red;
        break;
      case 'L':
        return const Color(0xFFEDD200);
        break;
      case 'H':
        return Colors.purpleAccent;
        break;
      case 'F':
        return Colors.deepPurple;
        break;
      default:
        return Colors.transparent;
        break;
    }
  }

  String getStatusCount(String titleVal, List<StudentAttendance> attendances) {
    int count = 0;
    for (int i = 0; i < attendances.length; i++) {
      if (attendances[i].type == titleVal) {
        count = count + 1;
      }
    }
    //debugPrint('count $count');
    return '$count days';
  }

  Future<ChildList?>? getAllStudent(String? id) async {
    final response = await http.get(Uri.parse(InfixApi.getParentChildList(id)),
        headers: Utils.setHeader(token.toString()));
    print(id);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ChildList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
