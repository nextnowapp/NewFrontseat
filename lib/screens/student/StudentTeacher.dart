// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:http/http.dart' as http;
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Teacher.dart';
import 'package:nextschool/utils/server/About.dart';
import 'package:nextschool/utils/widget/Student_teacher_row_layout.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class StudentTeacher extends StatefulWidget {
  String? id;
  String? token;

  StudentTeacher({this.id, this.token});

  @override
  _StudentTeacherState createState() => _StudentTeacherState();
}

class _StudentTeacherState extends State<StudentTeacher>
    with SingleTickerProviderStateMixin {
  Future<TeacherList?>? teachers;
  int? mId;
  int? perm = -1;
  late AnimationController controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('id').then((value) {
      setState(() {
        mId = widget.id != null ? int.parse(widget.id!) : int.parse(value!);
        teachers = getAllTeacher(mId);
      });
    });
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Teacher'),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: FutureBuilder<TeacherList?>(
          future: teachers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.teachers.length > 0) {
                About.phonePermission(widget.token).then((val) {
                  if (mounted) {
                    setState(() {
                      perm = val;
                    });
                  }
                });
                return perm != -1
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 200),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.teachers.length,
                        itemBuilder: (context, index) {
                          return StudentTeacherRowLayout(
                              snapshot.data!.teachers[index], perm);
                        },
                      )
                    : Container();
              } else {
                return Utils.noDataTextWidget(message: 'No Teacher Found');
              }
            } else {
              return const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CustomLoader(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<TeacherList?>? getAllTeacher(int? id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentTeacherUrl(id)),
        headers: Utils.setHeader(widget.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TeacherList.fromJson(jsonData['data']['teacher_list']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
