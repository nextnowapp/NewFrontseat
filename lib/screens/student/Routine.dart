// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/model/class_wise_timetable.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../../utils/model/TeacherTimeTableModel.dart';
import '../../utils/widget/customLoader.dart';

// ignore: must_be_immutable
class Routine extends StatefulWidget {
  String? id;
  // static bool Changed = false;
  Routine({this.id});

  @override
  State<Routine> createState() => _RoutineState();
}

class _RoutineState extends State<Routine> with SingleTickerProviderStateMixin {
  List<String> weeks = AppFunction.weeks;
  String? _token;
  Future<TeacherTimeTable?>? routine;
  DateTime date = DateTime.now();
  String? currentDay;
  // TabController? controller;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  static List<Tab> _tabs = <Tab>[
    const Tab(
      text: 'Mon',
    ),
    const Tab(
      text: 'Tue',
    ),
    const Tab(
      text: 'Wed',
    ),
    const Tab(
      text: 'Thurs',
    ),
    const Tab(
      text: 'Fri',
    ),
    /* Tab(
      text: 'Saturday'.toUpperCase(),
    ),
    Tab(
      text: 'Sunday'.toUpperCase(),
    )*/
  ];
  List days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];
  int? currentIndex;
  int? classId;
  late TabController _tabController;
  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
    currentDay = DateFormat('EEEE').format(date);
    routine = fetchClassRoutine(int.parse(widget.id!));
    print(currentDay);
    currentDay = DateFormat('EEEE').format(date);

    _tabController = TabController(length: 5, vsync: this);
  }

  List timeColors = <Color>[
    const Color(0xffffda84),
    const Color(0xffff9ed2),
    const Color(0xff98b9ff),
    const Color(0xff86e5cb),
    const Color(0xffe0b0ea)
  ];
  List subjectColors = <Color>[
    const Color(0xfffff2d4),
    const Color(0xffffd4eb),
    const Color(0xffd1e0ff),
    const Color(0xffc4ece1),
    const Color(0xffe9c6f0)
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Class Time table'),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            splashFactory: InkRipple.splashFactory,
            splashBorderRadius: BorderRadius.circular(10.0),
            automaticIndicatorColorAdjustment: true,
            labelColor: Colors.white,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.blueAccent),
            isScrollable: true,
            controller: _tabController,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            tabs: <Widget>[
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 0
                          ? Colors.transparent
                          : Colors.grey[300]),
                  child: Text(
                    'Mon',
                    style: TextStyle(
                        color: _tabController.index == 0
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 1
                          ? Colors.transparent
                          : Colors.grey[300]),
                  child: Text(
                    'Tue',
                    style: TextStyle(
                        color: _tabController.index == 1
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 2
                          ? Colors.transparent
                          : Colors.grey[300]),
                  child: Text(
                    'Wed',
                    style: TextStyle(
                        color: _tabController.index == 2
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 3
                          ? Colors.transparent
                          : Colors.grey[300]),
                  child: Text(
                    'Thu',
                    style: TextStyle(
                        color: _tabController.index == 3
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 4
                          ? Colors.transparent
                          : Colors.grey[300]),
                  child: Text(
                    'Fri',
                    style: TextStyle(
                        color: _tabController.index == 4
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Center(
                      child: Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
                const Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      'Period',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              //monday===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Monday') {
                              return snapshot
                                      .data!.data!.classTimes![index].isBreak!
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 80,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .startTime! +
                                                      ' - ' +
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .endTime!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const Center(
                                                child: Text(
                                                  'Break',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color1,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .startTime!
                                                            .replaceFirst(
                                                                '.', ':') +
                                                        ' - ' +
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .endTime!
                                                            .replaceFirst(
                                                                '.', ':'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 80,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: color1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Educator: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .teacherName ??
                                                                  ''),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                                  .data!
                                                                  .data!
                                                                  .classTimes![
                                                                      index]
                                                                  .subjectName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CustomLoader());
                    }
                  }),

              //Tuesday===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Tuesday') {
                              return snapshot
                                      .data!.data!.classTimes![index].isBreak!
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 80,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .startTime! +
                                                      ' - ' +
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .endTime!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const Center(
                                                child: Text(
                                                  'Break',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .startTime!
                                                            .replaceFirst(
                                                                '.', ':') +
                                                        ' - ' +
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .endTime!
                                                            .replaceFirst(
                                                                '.', ':'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 80,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: color1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Educator: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .teacherName ??
                                                                  ''),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                                  .data!
                                                                  .data!
                                                                  .classTimes![
                                                                      index]
                                                                  .subjectName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: SizedBox());
                    }
                  }),

              //WendsDay===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Wednesday') {
                              return snapshot
                                      .data!.data!.classTimes![index].isBreak!
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 80,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .startTime! +
                                                      ' - ' +
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .endTime!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const Center(
                                                child: Text(
                                                  'Break',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .startTime!
                                                            .replaceFirst(
                                                                '.', ':') +
                                                        ' - ' +
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .endTime!
                                                            .replaceFirst(
                                                                '.', ':'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 80,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: color1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Educator: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .teacherName ??
                                                                  ''),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                                  .data!
                                                                  .data!
                                                                  .classTimes![
                                                                      index]
                                                                  .subjectName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CustomLoader());
                    }
                  }),
              //Thursday===========================================

              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Thursday') {
                              return snapshot
                                      .data!.data!.classTimes![index].isBreak!
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 80,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .startTime! +
                                                      ' - ' +
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .endTime!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const Center(
                                                child: Text(
                                                  'Break',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .startTime!
                                                            .replaceFirst(
                                                                '.', ':') +
                                                        ' - ' +
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .endTime!
                                                            .replaceFirst(
                                                                '.', ':'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 80,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: color1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Educator: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .teacherName ??
                                                                  ''),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                                  .data!
                                                                  .data!
                                                                  .classTimes![
                                                                      index]
                                                                  .subjectName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CustomLoader());
                    }
                  }),
              //Friday===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Friday') {
                              return snapshot
                                      .data!.data!.classTimes![index].isBreak!
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 80,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .startTime! +
                                                      ' - ' +
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .classTimes![index]
                                                          .endTime!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const Center(
                                                child: Text(
                                                  'Break',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10, bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .startTime!
                                                            .replaceFirst(
                                                                '.', ':') +
                                                        ' - ' +
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .classTimes![index]
                                                            .endTime!
                                                            .replaceFirst(
                                                                '.', ':'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 80,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: color2,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: color1,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Educator: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .teacherName ??
                                                                  ''),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                                  .data!
                                                                  .data!
                                                                  .classTimes![
                                                                      index]
                                                                  .subjectName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            } else {
                              return const Center(child: SizedBox());
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CustomLoader());
                    }
                  }),
            ]),
          ),
        ],
      ),
    );
  }

  Widget getTimeTableOfMonday(AsyncSnapshot<TeacherTimeTableModel?> model) {
    return ListView.builder(
        itemCount: model.data!.data!.monday!.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: model.data!.data!.monday![index].subjectName != null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: timeColors[index],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.monday![index].startTime! +
                              '\n' +
                              model.data!.data!.monday![index].endTime!,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: subjectColors[index],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          weight: FontWeight.w500,
                          txt: model.data!.data!.monday![index].subjectName ??
                              '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget getTimeTableOfTuesday(AsyncSnapshot<TeacherTimeTableModel?> model) {
    return ListView.builder(
        itemCount: model.data!.data!.tuesday!.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: model.data!.data!.tuesday![index].subjectName != null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: timeColors[index],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.tuesday![index].startTime! +
                              '\n' +
                              model.data!.data!.tuesday![index].endTime!,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: subjectColors[index],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          weight: FontWeight.w500,
                          txt: model.data!.data!.tuesday![index].subjectName ??
                              '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget getTimeTableOfWednesday(AsyncSnapshot<TeacherTimeTableModel?> model) {
    return ListView.builder(
        itemCount: model.data!.data!.wednesday!.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: model.data!.data!.wednesday![index].subjectName != null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: timeColors[index],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.wednesday![index].startTime! +
                              '\n' +
                              model.data!.data!.wednesday![index].endTime!,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: subjectColors[index],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt:
                              model.data!.data!.wednesday![index].subjectName ??
                                  '',
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget getTimeTableOfThursday(AsyncSnapshot<TeacherTimeTableModel?> model) {
    return ListView.builder(
        itemCount: model.data!.data!.thursday!.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: model.data!.data!.thursday![index].subjectName != null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: timeColors[index],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.thursday![index].startTime! +
                              '\n' +
                              model.data!.data!.thursday![index].endTime!,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: subjectColors[index],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.thursday![index].subjectName ??
                              '',
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget getTimeTableOfFriday(AsyncSnapshot<TeacherTimeTableModel?> model) {
    return ListView.builder(
        itemCount: model.data!.data!.friday!.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: model.data!.data!.friday![index].subjectName != null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: timeColors[index],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.friday![index].startTime! +
                              '\n' +
                              model.data!.data!.friday![index].endTime!,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: subjectColors[index],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextWidget(
                          txt: model.data!.data!.friday![index].subjectName ??
                              '',
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Widget getTimeTableOfSaturday(AsyncSnapshot<TeacherTimeTableModel> model) {
  //   return Expanded(
  //     child: Container(
  //       child: const Center(child: Text('Saturday')),
  //     ),
  //   );
  // }

  // Widget getTimeTableOfSunday(AsyncSnapshot<TeacherTimeTableModel> model) {
  //   return Expanded(
  //     child: Container(
  //       child: const Center(child: Text('Sunday')),
  //     ),
  //   );
  // }

  Future<TeacherTimeTable?>? fetchClassRoutine(int id) async {
    print('${id}========================');
    final response = await http.get(Uri.parse(InfixApi.classWiseRoutine(id)),
        headers: Utils.setHeader(_token.toString()));
    print('api hits on the server');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return TeacherTimeTable.fromJson(jsonData);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return null;
  }
}
