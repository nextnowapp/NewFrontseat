// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/model/class_wise_timetable.dart';

import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../../utils/model/TeacherTimeTableModel.dart';
import '../../utils/widget/customLoader.dart';

// ignore: must_be_immutable
class ClassWiseTimeTableScreen extends StatefulWidget {
  String? id;
  int? classId;
  String className;

  ClassWiseTimeTableScreen({this.id, this.classId, required this.className});

  @override
  State<ClassWiseTimeTableScreen> createState() =>
      _ClassWiseTimeTableScreenState();
}

class _ClassWiseTimeTableScreenState extends State<ClassWiseTimeTableScreen>
    with SingleTickerProviderStateMixin {
  List<String> weeks = AppFunction.weeks;
  String? _token;
  Future<TeacherTimeTable?>? routine;
  DateTime date = DateTime.now();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? currentDay;
  late TabController _tabController;
  static List<Tab> _tabs = <Tab>[
    Tab(
      text: 'Monday'.toUpperCase(),
    ),
    Tab(
      text: 'Tuesday'.toUpperCase(),
    ),
    Tab(
      text: 'Wednesday'.toUpperCase(),
    ),
    Tab(
      text: 'Thursday'.toUpperCase(),
    ),
    Tab(
      text: 'Friday'.toUpperCase(),
    ),
  ];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _userDetailsController.token;
    currentDay = DateFormat('EEEE').format(date);
    routine = fetchClassRoutine(int.parse(widget.id!), widget.classId);
    currentDay = DateFormat('EEEE').format(date);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      _handleTabSelection();
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Class Time table'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1)
                ]),
            child: Text('Class: ${widget.className}',
                style: TextStyle(
                    fontFamily: GoogleFonts.chivo().fontFamily,
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(
            height: 20,
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
            tabs: <Widget>[
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _tabController.index == 0 ||
                              _tabController.indexIsChanging
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
                      color: _tabController.index == 1 ||
                              _tabController.indexIsChanging
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
                      color: _tabController.index == 2 ||
                              _tabController.indexIsChanging
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
                      color: _tabController.index == 3 ||
                              _tabController.indexIsChanging
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
                      color: _tabController.index == 4 ||
                              _tabController.indexIsChanging
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
                      'Class',
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
              FutureBuilder<TeacherTimeTable?>(
                future: routine,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.data!.classTimes!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.data!.classTimes![index].dayName ==
                              'Monday') {
                            int count = index % 5;
                            Color color1 = timeColors[count];
                            Color color2 = subjectColors[count];
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
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
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(5)),
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
                                              decoration: BoxDecoration(
                                                color: color2,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(5)),
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
                                                                  .circular(5)),
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
                                                        style: const TextStyle(
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
                                                        style: const TextStyle(
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
                },
              ),

              //Tuesday===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Tuesday') {
                              int count = index % 5;

                              Color color1 = timeColors[count];
                              Color color2 = subjectColors[count];
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
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Wednesday') {
                              int count = index % 5;

                              Color color1 = timeColors[count];
                              Color color2 = subjectColors[count];
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
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Thursday') {
                              int count = index % 5;

                              Color color1 = timeColors[count];
                              Color color2 = subjectColors[count];
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
                            if (snapshot
                                    .data!.data!.classTimes![index].dayName ==
                                'Friday') {
                              int count = index % 5;

                              Color color1 = timeColors[count];
                              Color color2 = subjectColors[count];
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

  Widget getTimeTableOfMonday(AsyncSnapshot<TeacherTimeTable?> model) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
          itemCount: model.data!.data!.classTimes!.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Class Name'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(model.data!.data!.classTimes![index].className!)
                      ],
                    ),
                    Row(
                      children: [
                        const Text('StartTime :'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat.jm()
                            .format(DateFormat('hh:mm:ss').parse(model
                                .data!.data!.classTimes![index].startTime
                                .toString()))
                            .toString())
                      ],
                    ),
                    Row(
                      children: [
                        const Text('End time :'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat.jm()
                            .format(DateFormat('hh:mm:ss').parse(model
                                .data!.data!.classTimes![index].endTime
                                .toString()))
                            .toString())
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget getTimeTableOfTuesday(AsyncSnapshot<TeacherTimeTable?> model) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(model.data!.data!.smWeekends![1].name!),
    );
  }

  Widget getTimeTableOfWednesday(AsyncSnapshot<TeacherTimeTable?> model) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
          itemCount: model.data!.data!.classTimes!.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Class Name'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(model.data!.data!.classTimes![index].className!)
                      ],
                    ),
                    Row(
                      children: [
                        const Text('StartTime :'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat.jm()
                            .format(DateFormat('hh:mm:ss').parse(model
                                .data!.data!.classTimes![index].startTime
                                .toString()))
                            .toString())
                      ],
                    ),
                    Row(
                      children: [
                        const Text('End time :'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat.jm()
                            .format(DateFormat('hh:mm:ss').parse(model
                                .data!.data!.classTimes![index].endTime
                                .toString()))
                            .toString()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget getTimeTableOfThursday(AsyncSnapshot<TeacherTimeTable?> model) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: Text(model.data!.data!.smWeekends![3].name!));
  }

  Widget getTimeTableOfFriday(AsyncSnapshot<TeacherTimeTable?> model) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(model.data!.data!.smWeekends![4].name!),
    );
  }

  Widget getTimeTableOfSaturday(AsyncSnapshot<TeacherTimeTableModel> model) {
    return Expanded(
      child: Container(
        child: const Center(child: Text('Saturday')),
      ),
    );
  }

  Widget getTimeTableOfSunday(AsyncSnapshot<TeacherTimeTableModel> model) {
    return Expanded(
      child: Container(
        child: const Center(child: Text('Sunday')),
      ),
    );
  }

  Future<TeacherTimeTable?>? fetchClassRoutine(int id, int? classId) async {
    var form = {
      'class': widget.classId,
    };
    var body = jsonEncode(form);

    final response = await http.post(Uri.parse(InfixApi.classWiseTimetable()),
        body: body, headers: Utils.setHeader(_token.toString()));
    print('api hits on the server');
    print('====================${response.statusCode}==================');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      // If server returns an OK response, parse the JSON.
      return TeacherTimeTable.fromJson(jsonData);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
