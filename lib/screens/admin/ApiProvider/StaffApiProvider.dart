// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:nextschool/utils/model/LibraryCategoryMember.dart';
import 'package:nextschool/utils/model/Staff.dart';

class StaffApiProvider {
  String? token;
  String? id;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  Future<LibraryMemberList> getAllCategory() async {
    token = _userDetailsController.token;
    id = _userDetailsController.id.toString();
    final response = await http.get(Uri.parse(InfixApi.getStuffCategory),
        headers: Utils.setHeader(token!));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(int? staffId) async {
    token = _userDetailsController.token;
    id = _userDetailsController.id.toString();
    final response = await http.get(Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(token!));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data'] as List<dynamic>);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList?>? getAllLeave(
      BuildContext context, String url, String endPoint) async {
    token = _userDetailsController.token;
    id = _userDetailsController.id.toString();

    print('$url $endPoint');
    final response = await http.get(Uri.parse(url + '/' + id!),
        headers: Utils.setHeader(token!));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data'][endPoint]);
    } else {
      throw Exception('Failed to load');
    }
  }
}
