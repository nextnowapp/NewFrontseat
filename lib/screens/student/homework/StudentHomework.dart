// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/widget/404ErrorWidget.dart';
import 'package:nextschool/utils/widget/Homework_row.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class StudentHomework extends StatefulWidget {
  String id;
  final String? notificationId;

  StudentHomework({required this.id, this.notificationId});

  @override
  _StudentHomeworkState createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework>
    with SingleTickerProviderStateMixin {
  Future<HomeworkList?>? homeworks;
  String? _token;
  late TabController _tabController;
  @override
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  List days = [];
  void initState() {
    _token = _userDetailsController.token;
    setState(() {
      homeworks = fetchHomework(
        int.parse(
          widget.id,
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: CustomAppBarWidget(
      //   title: 'Homework List',
      //   appBarColor: HexColor('#ddf0f9'),
      // ),
      backgroundColor: Colors.white,
      body: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: HexColor('#ddf0f9'),
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: Stack(
              children: [
                Container(
                    height: size.height * 0.2,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: HexColor('#ddf0f9'))),
                Positioned(
                  top: 0,
                  left: 0,
                  // top: 35,
                  // left: 1,
                  // child: SvgPicture.asset('assets/images/Mask Group 34.svg'),
                  // child: SvgPicture.asset('assets/images/Homework list.svg'),
                  // child: SvgPicture.asset('assets/images/Top Image.svg'),
                  child: SvgPicture.asset('assets/images/Mask Group 34.svg'),
                  height: size.height * 0.2,
                ),
                const Positioned(
                  top: 90,
                  left: 200,
                  child: Text(
                    'Homework List',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder<HomeworkList?>(
              future: fetchHomework(
                int.parse(widget.id),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.homeworks.length == 0) {
                    return Center(child: Utils.noDataTextWidget());
                  } else
                    return ListView.builder(
                      itemCount: snapshot.data!.homeworks.length,
                      itemBuilder: (context, index) {
                        return StudentHomeworkRow(
//                           //reversed the list to show latest first
                            snapshot.data!.homeworks[(index)],
                            'student');
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
          ),
        ]),
      ),
    );
  }

  Future<HomeworkList?>? fetchHomework(int id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudenthomeWorksUrl(id)),
        headers: Utils.setHeader(_userDetailsController.token));

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return HomeworkList.fromJson(jsonData['data']);
      //reverse the list

    } else {
      var jsonData = jsonDecode(response.body);
      throw Exception('failed to load');
    }
    return null;
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }
}
