// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/widget/404ErrorWidget.dart';
import 'package:nextschool/utils/widget/TeacherHomeworkRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

class TeacherHomework extends StatefulWidget {
  @override
  _TeacherHomeworkState createState() => _TeacherHomeworkState();
}

class _TeacherHomeworkState extends State<TeacherHomework>
    with SingleTickerProviderStateMixin {
  Future<HomeworkList>? homeworks;
  late TabController _tabController;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  String? _token;

  @override
  final startDate = DateTime.now().subtract(const Duration(days: 30));
  final endDate = DateTime.now();
  List days = [];
  void initState() {
    super.initState();
    days = getDays(startDate, endDate);
    _tabController = TabController(length: days.length, vsync: this);
    _token = _userDetailsController.token;
    homeworks = fetchHomework(_userDetailsController.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<Null> _refresh() async {
      setState(() {
        homeworks = fetchHomework(_userDetailsController.id);
      });
    }

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homework List'),
      backgroundColor: HexColor('#EAEAEA'),

      body: FutureBuilder<HomeworkList>(
        future: homeworks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.homeworks.length == 0) {
              return Center(child: Utils.noDataTextWidget());
            } else
              return ListView.builder(
                itemCount: snapshot.data!.homeworks.length,
                itemBuilder: (context, index) {
                  return TeacherHomeworkRow(
                      snapshot.data!.homeworks[index], _token);
                },
              );
          } else if (snapshot.hasError) {
            return const widget_error_404();
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),

      // floatingActionButton: ,
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddHomeworkScrren()),
      //     );
      //   },
      //   child: Align(
      //     alignment: Alignment.bottomRight,
      //     child: Container(
      //       height: 50,
      //       width: 150.0,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(30),
      //           color: HexColor('#1E3377')),
      //       child: SizedBox(
      //         width: 200,
      //         child: Row(
      //           children: [
      //             const SizedBox(width: 20),
      //             SvgPicture.asset(
      //               'assets/images/Group 265.svg',
      //               color: Colors.white,
      //             ),
      //             // SvgPicture.asset('assets/images/PDF Doc.svg'),
      //             const SizedBox(
      //               width: 10,
      //             ),
      //             const Text(
      //               'Add\nHomework',
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 13),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Future<HomeworkList> fetchHomework(int id) async {
    final response = await http
        .get(Uri.parse(InfixApi.getHomeWorkListUrl(id)),
            headers: Utils.setHeader(_token.toString()))
        .catchError((e) {
      Utils.showErrorToast(e.response.data['message']);
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return HomeworkList.fromJson(jsonData['data']['homeworkLists']);
    } else {
      throw Exception('failed to load');
    }
  }

  List<DateTime> getDays(DateTime startdate, DateTime enddate) {
    List<DateTime> days = [];
    for (int i = enddate.difference(startdate).inDays; i >= 1; i--) {
      days.add(startdate.add(Duration(days: i)));
    }
    return days;
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }
}
