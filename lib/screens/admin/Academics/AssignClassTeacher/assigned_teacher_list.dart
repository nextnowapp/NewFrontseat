import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Staff.dart';

class AssignedClassTeacherScreen extends StatefulWidget {
  const AssignedClassTeacherScreen({Key? key}) : super(key: key);

  @override
  _AssignedClassTeacherScreenState createState() =>
      _AssignedClassTeacherScreenState();
}

class _AssignedClassTeacherScreenState
    extends State<AssignedClassTeacherScreen> {
  String? _id;
  String? _token;
  Future<StaffList?>? staff;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    staff = getAllStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Assigned Teacher List',
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<StaffList?>? getAllStaff() async {
    final response = await http.get(Uri.parse(InfixApi.assignClassTeacher()),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // return StaffList.fromJson(jsonData);

    } else {
      throw Exception('Failed to load post');
    }
    return null;
  }
}
