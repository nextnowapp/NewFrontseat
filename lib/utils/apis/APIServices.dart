import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ProfileModel.dart';

import '../Utils.dart';

class APIServices {
  late http.Response response;

  Future<ProfileModel> getTeacherInfo(
      BuildContext context, String id, String token) async {
    response = await http.get(
        Uri.parse(InfixApi().root + 'api/' + 'teacherInfo/$id'),
        headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return ProfileModel.fromJson(decodedData);
    } else if (response.statusCode == 404) {
      var decodedData = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg: '404 Error Page not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return ProfileModel.fromJson(decodedData);
    } else {
      throw Exception('Failed to load');
    }
  }
}
