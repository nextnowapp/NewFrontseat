// Dart imports:

// Package imports:

import 'dart:developer';

import 'package:dio/dio.dart' as DIO;
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/notification_controller.dart';
import 'package:nextschool/controller/subject_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String email;
  final String password;

  Login(this.email, this.password);

  Future<String?> getData2(BuildContext context) async {
    //initializing values which will be further used to initlize the user controller
    bool isSuccessed = false;
    int id;
    int roleId;
    String role;
    String fullName;
    String mobile;
    String dob;
    String photo;
    int age;
    int genderId;
    String gender;
    String designation;
    int zoom;
    String is_administrator;
    String user_type;
    String token;
    bool isLogged;
    String schoolUrl;
    var message;

    //intializing the required controller
    UserDetailsController controller = Get.put(UserDetailsController());
    GradeListController gradeController = Get.put(GradeListController());
    SubjectListController subjectListController =
        Get.put(SubjectListController());
    AttendanceStatController attendanceStatController =
        Get.put(AttendanceStatController());
    NotificationController notificationController =
        Get.put(NotificationController());
    bool isNullOrEmpty(Object? o) => o == null || o == '';

    // calling login api using email and password authentication
    try {
      log('Trying to Login using $email and $password',
          name: 'Login : getData2()');
      DIO.Dio dio = DIO.Dio();
      DIO.Response response = await dio.get(InfixApi.login(email, password));

      //checking if the response is successfull or not
      if (response.statusCode == 200) {
        //storing the response in a variable
        var user = response.data;
        isSuccessed = user['success'] as bool;
        message = user['message'];
        var userData = user['data']['user'];

        // getting the required data from the response
        id = userData['id'] as int;
        roleId = userData['role_id'];
        role = userData['role'];
        fullName = userData['fullname'];
        mobile = userData['mobile'] ?? '';
        dob = userData['dob'];
        photo = userData['image'] ?? (userData['photo'] ?? '');
        age = userData['age'];
        genderId = userData['genderId'] ?? 1;
        gender = userData['gender'] ?? '';
        designation = userData['designation'] ?? '';
        zoom = userData['zoom'];
        is_administrator = userData['is_administrator'];
        user_type = userData['user_type'];
        is_administrator = userData['is_administrator'];
        token = userData['accessToken'];
        isLogged = isSuccessed;
        schoolUrl = InfixApi().root;

        if (isSuccessed) {
          // storing the required data in the shared preferences
          saveIntValue('id', id);
          saveIntValue('roleId', roleId);
          saveStringValue('rule', role);
          saveStringValue('fullname', fullName);
          saveStringValue('email', email);
          saveStringValue('mobile', mobile);
          saveStringValue('dob', dob);
          saveStringValue('image', photo);
          saveStringValue('photo', photo);
          saveIntValue('age', age);
          saveIntValue('genderId', genderId);
          saveStringValue('gender', gender);
          saveStringValue('designation', designation);
          saveIntValue('zoom', zoom);
          saveStringValue('isAdministrator', is_administrator);
          saveStringValue('user_type', user_type);
          saveStringValue('token', token);
          saveBooleanValue('isLogged', isLogged);
          saveStringValue('schoolUrl', controller.schoolUrl);

          //intialize the user controller with the required data
          controller.id = id;
          controller.roleId = roleId;
          controller.role = role;
          controller.fullName = fullName;
          controller.email = email;
          controller.mobile = mobile;
          controller.dob = dob;
          controller.photo = photo;
          controller.age = age;
          controller.genderId = genderId;
          controller.gender = gender;
          controller.designation = designation;
          controller.zoom = zoom;
          controller.is_administrator = is_administrator;
          controller.user_type = user_type;
          controller.token = token;
          controller.isLogged = isLogged;

          notificationController.fetchUnreadNotificationCount();
          if (controller.roleId != 3) {
            gradeController.fetchGradeList();
            subjectListController.fetchSubjectList();
            attendanceStatController.fetchAttendanceStat();
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return AppFunction.getFunctions(
                context, roleId.toString(), zoom.toString());
          }));
        }
        return message;
      }
    } catch (e) {
      message = (e as DIO.DioException).response!.data['message'];
      throw message;
    }
    return message;
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  //getString
  Future<String?> getStringValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  //save int
  Future<bool> saveIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  //getInt
  Future<int?> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}

class Login2 {
  final Map<String, dynamic> params;

  Login2(this.params);

  Future<String?> getData2(BuildContext context) async {
    //initializing values which will be further used to initlize the user controller
    bool isSuccessed = false;
    int id;
    int roleId;
    String role;
    String fullName;
    String email;
    String mobile;
    String dob;
    String photo;
    int age;
    int genderId;
    String gender;
    String designation;
    int zoom;
    String is_administrator;
    String user_type;
    String token;
    bool isLogged;
    String schoolUrl;
    var message;

    //intializing the required controller
    UserDetailsController controller = Get.put(UserDetailsController());
    GradeListController gradeController = Get.put(GradeListController());
    SubjectListController subjectListController =
        Get.put(SubjectListController());
    AttendanceStatController attendanceStatController =
        Get.put(AttendanceStatController());
    NotificationController notificationController =
        Get.put(NotificationController());
    bool isNullOrEmpty(Object? o) => o == null || o == '';

    // calling login api using email and password authentication
    try {
      DIO.Dio dio = DIO.Dio();
      FormData data = FormData.fromMap(params);
      DIO.Response response = await dio.post(
        InfixApi.login2(),
        data: data,
      );

      //checking if the response is successfull or not
      if (response.statusCode == 200) {
        //storing the response in a variable
        var user = response.data;
        isSuccessed = user['success'] as bool;

        message = user['message'];
        var userData = user['data']['user'];

        // getting the required data from the response
        id = userData['id'];
        roleId = userData['role_id'];
        role = userData['role'];
        fullName = userData['fullname'];
        email = userData['email'] ?? '';
        mobile = userData['mobile'] ?? '';
        dob = userData['dob'];
        photo = userData['image'] ?? (userData['photo'] ?? '');
        age = userData['age'];
        genderId = userData['genderId'] ?? 1;
        gender = userData['gender'] ?? '';
        designation = userData['designation'] ?? '';
        zoom = userData['zoom'];
        is_administrator = userData['is_administrator'];
        user_type = userData['user_type'];
        is_administrator = userData['is_administrator'];
        token = userData['accessToken'];
        isLogged = isSuccessed;
        schoolUrl = InfixApi().root;

        if (isSuccessed) {
          // storing the required data in the shared preferences
          saveIntValue('id', id);
          saveIntValue('roleId', roleId);
          saveStringValue('rule', role);
          saveStringValue('fullname', fullName);
          saveStringValue('email', email);
          saveStringValue('mobile', mobile);
          saveStringValue('dob', dob);
          saveStringValue('image', photo);
          saveStringValue('photo', photo);
          saveIntValue('age', age);
          saveIntValue('genderId', genderId);
          saveStringValue('gender', gender);
          saveStringValue('designation', designation);
          saveIntValue('zoom', zoom);
          saveStringValue('isAdministrator', is_administrator);
          saveStringValue('user_type', user_type);
          saveStringValue('token', token);
          saveBooleanValue('isLogged', isLogged);
          saveStringValue('schoolUrl', controller.schoolUrl);

          //intialize the user controller with the required data
          controller.id = id;
          controller.roleId = roleId;
          controller.role = role;
          controller.fullName = fullName;
          controller.email = email;
          controller.mobile = mobile;
          controller.dob = dob;
          controller.photo = photo;
          controller.age = age;
          controller.genderId = genderId;
          controller.gender = gender;
          controller.designation = designation;
          controller.zoom = zoom;
          controller.is_administrator = is_administrator;
          controller.user_type = user_type;
          controller.token = token;
          controller.isLogged = isLogged;

          notificationController.fetchUnreadNotificationCount();
          if (controller.roleId != 3) {
            gradeController.fetchGradeList();
            subjectListController.fetchSubjectList();
            attendanceStatController.fetchAttendanceStat();
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return AppFunction.getFunctions(
                context, roleId.toString(), zoom.toString());
          }));
        }
        return message;
      }
    } catch (e) {
      message = (e as DIO.DioException).response!.data['message'];
      throw message;
    }
    return message;
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  //getString
  Future<String?> getStringValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  //save int
  Future<bool> saveIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  //getInt
  Future<int?> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
