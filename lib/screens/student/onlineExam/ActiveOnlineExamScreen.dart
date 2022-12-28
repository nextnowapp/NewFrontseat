// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ActiveOnlineExam.dart';
import 'package:nextschool/utils/widget/ActiveOnlineExam.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class ActiveOnlineExamScreen extends StatefulWidget {
  var id;

  ActiveOnlineExamScreen({this.id});

  @override
  _ActiveOnlineExamScreenState createState() =>
      _ActiveOnlineExamScreenState(id: id);
}

class _ActiveOnlineExamScreenState extends State<ActiveOnlineExamScreen> {
  Future<ActiveExamList?>? exams;
  var id;

  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  _ActiveOnlineExamScreenState({this.id});

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = id != null ? id : value;
        exams = getAllActiveExam(id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Active Exam'),
      backgroundColor: Colors.white,
      body: FutureBuilder<ActiveExamList?>(
        future: exams,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.activeExams.length > 0) {
              return Column(
                children: <Widget>[Expanded(child: getExamList())],
              );
            } else {
              return Utils.noDataTextWidget();
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
    );
  }

  Widget getExamList() {
    return FutureBuilder<ActiveExamList?>(
      future: exams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.activeExams.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ActiveOnlineExamRow(snapshot.data!.activeExams[index]);
            },
          );
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
    );
  }

  Future<ActiveExamList?>? getAllActiveExam(var id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOnlineActiveExam(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ActiveExamList.fromJson(jsonData['data']['online_exams']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
