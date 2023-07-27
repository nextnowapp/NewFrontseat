// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/TeacherMyRoutine.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

import '../../../utils/model/class_wise_timetable.dart';

// ignore: must_be_immutable
class TeacherMyRoutineScreen extends StatefulWidget {
  @override
  State<TeacherMyRoutineScreen> createState() => _TeacherMyRoutineScreenState();
}

class _TeacherMyRoutineScreenState extends State<TeacherMyRoutineScreen>
    with SingleTickerProviderStateMixin {
  List<String> weeks = AppFunction.weeks;
  String? _token;
  Future<TeacherTimeTable?>? routine;
  DateTime date = DateTime.now();
  String? currentDay;
  TabController? controller;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
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
    /* Tab(
      text: 'Saturday'.toUpperCase(),
    ),
    Tab(
      text: 'Sunday'.toUpperCase(),
    )*/
  ];
  late TabController _tabController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      currentDay = DateFormat('EEEE').format(date);
      print(currentDay);
      routine = fetchClassRoutine(_userDetailsController.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;

    currentDay = DateFormat('EEEE').format(date);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Time table'),
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
            tabs: <Widget>[
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[300]),
                  child: const Text(
                    'Mon',
                    style: TextStyle(color: Colors.black),
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
          const SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
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
                Expanded(
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
              //monday===========================================
              FutureBuilder<TeacherTimeTable?>(
                  future: routine,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.classTimes!.length,
                          itemBuilder: (context, index) {
                            var times = index ~/ 5;
                            int count =
                                (index % 5).toInt() + (5 * times) - index ~/ 5;
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
                                          const Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Break',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
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
                                                          'Class: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .className ??
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
                            var times = index ~/ 5;
                            int count =
                                (index % 5).toInt() + (5 * times) - index ~/ 5;
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
                                          const Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Break',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
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
                                                          'Class: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .className ??
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
                            var times = index ~/ 5;
                            int count =
                                (index % 5).toInt() + (5 * times) - index ~/ 5;
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
                                          const Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Break',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
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
                                                          'Class: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .className ??
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
                            var times = index ~/ 5;
                            int count =
                                (index % 5).toInt() + (5 * times) - index ~/ 5;
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
                                          const Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Break',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
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
                                                          'Class: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .className ??
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
                            var times = index ~/ 5;
                            int count =
                                (index % 5).toInt() + (5 * times) - index ~/ 5;
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
                                          const Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Break',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
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
                                                          'Class: ' +
                                                              (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .classTimes![
                                                                          index]
                                                                      .className ??
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

  Future<TeacherMyRoutineList> fetchRoutine(int id, String title) async {
    // print(InfixApi.getTeacherMyRoutine(id));
    final response = await http.get(Uri.parse(InfixApi.getTeacherMyRoutine(id)),
        headers: Utils.setHeader(_token.toString()));
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return TeacherMyRoutineList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<TeacherTimeTable?>? fetchClassRoutine(int id) async {
    // print(InfixApi.getTeacherMyRoutine(id));
    final response = await http.get(Uri.parse(InfixApi.getTeacherMyRoutine(id)),
        headers: Utils.setHeader(_token.toString()));
    print(response.body);
    print('===========${response.statusCode}=====');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return TeacherTimeTable.fromJson(jsonData);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
