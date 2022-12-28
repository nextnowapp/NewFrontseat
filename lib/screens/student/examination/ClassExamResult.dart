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
import 'package:nextschool/utils/model/ClassExam.dart';
import 'package:nextschool/utils/model/ClassExamSchedule.dart';
import 'package:nextschool/utils/widget/ClassExamResultRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class ClassExamResultScreen extends StatefulWidget {
  var id;

  ClassExamResultScreen({this.id});

  @override
  _ClassExamResultScreenState createState() => _ClassExamResultScreenState();
}

class _ClassExamResultScreenState extends State<ClassExamResultScreen> {
  Future<ClassExamResultList>? results;
  var id;
  int? code;
  var _selected;
  Future<ClassExamList>? exams;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      id = _userDetailsController.id;
      exams = getAllClassExam(id);
      exams!.then((val) {
        _selected = val.exams.length != 0 ? val.exams[0].examName : '';
        code = val.exams.length != 0 ? val.exams[0].examId : 0;
        results = getAllClassExamResult(id, code);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Assessment Result'),
      backgroundColor: Colors.white,
      body: FutureBuilder<ClassExamList>(
        future: exams,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.exams.length > 0) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data!.exams),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Expanded(child: getExamResultList())
                ],
              );
            } else {
              return Utils.noDataTextWidget();
            }
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),
    );
  }

  Widget getDropdown(List<ClassExamName> exams) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: exams.map((item) {
          return DropdownMenuItem<String>(
            value: item.examName,
            child: Text(
              item.examName!,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 15.0),
        onChanged: (dynamic value) {
          setState(() {
            _selected = value;

            code = getExamCode(exams, value);

            debugPrint('User select $value');

            results = getAllClassExamResult(id, code);

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<ClassExamResultList> getAllClassExamResult(var id, int? code) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentClassExamResult(id, code)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<ClassExamList> getAllClassExam(var id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentClassExamName(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassExamList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int? getExamCode(List<ClassExamName> exams, String? title) {
    int? code;

    for (ClassExamName exam in exams) {
      if (exam.examName == title) {
        code = exam.examId;
        break;
      }
    }
    return code;
  }

  Widget getExamResultList() {
    return FutureBuilder<ClassExamResultList>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.results.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ClassExamResultRow(snapshot.data!.results[index]);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else {
          return const Center(
            child: CustomLoader(),
          );
        }
      },
    );
  }
}
