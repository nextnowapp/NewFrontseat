// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:http/http.dart' as http;
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/Student.dart';
import 'package:nextschool/utils/widget/StudentSearchRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class StudentSearchNameRoll extends StatefulWidget {
  String? name;
  String? roll;
  String? url;
  String? token;

  StudentSearchNameRoll({this.name, this.roll, this.url, this.token});

  @override
  _StudentSearchNameRollState createState() => _StudentSearchNameRollState(
      name: name, roll: roll, url: url, token: token);
}

class _StudentSearchNameRollState extends State<StudentSearchNameRoll> {
  String? name;
  String? roll;
  String? url;
  Future<StudentList>? student;
  String? token;

  _StudentSearchNameRollState({this.name, this.roll, this.url, this.token});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      student = getSearchStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: ''),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<StudentList>(
        future: student,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.students.length,
              itemBuilder: (context, index) {
                return StudentRow(snapshot.data!.students[index]);
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
      ),
    );
  }

  Future<StudentList> getSearchStudent() async {
    print(url);
    final response = await http.get(Uri.parse(url!),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
