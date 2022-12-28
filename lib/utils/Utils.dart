// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/notification_controller.dart';
import 'package:nextschool/controller/subject_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  static Future<bool> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<bool> saveIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  static Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<String?> getStringValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString(key));
    return prefs.getString(key);
  }

  static Future<int?> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    return prefs.getInt(key);
  }

  static Future<bool> clearAllValue() async {
    //this function clear all values from shared preferences and getx state
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    GradeListController gradeListController = Get.put(GradeListController());
    AttendanceStatController attendanceStatController =
        Get.put(AttendanceStatController());
    SubjectListController subjectListController =
        Get.put(SubjectListController());

    NotificationController notificationController =
        Get.put(NotificationController());
    userDetailsController.reset();
    gradeListController.reset();
    subjectListController.reset();
    attendanceStatController.reset();
    notificationController.reset();

    //logout from firebase
    return prefs.clear();
  }

  static setHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    return header;
  }

  static String getDateFromTimeStamp(Timestamp timestamp) {
    var time = timestamp.toDate();
    var timeString = DateFormat.yMMMd().format(time);
    return timeString;
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF222744),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showProcessingToast() {
    Fluttertoast.showToast(
      msg: 'Processing... please wait',
      textColor: Colors.white,
      backgroundColor: const Color(0xFF222744),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static double getWidth(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return size.width;
  }

  static void showThemeToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF222744),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  static Widget sizedBoxWidth(double value) {
    return SizedBox(
      width: value,
    );
  }

  static Widget sizedBoxHeight(double value) {
    return SizedBox(
      height: value,
    );
  }

  static String getImagePath(String imageName) {
    return 'assets/images/$imageName';
  }

  static void showLoginToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static String formatDate(String date) {
    return DateFormat('MM/dd/yy')
        .format(DateFormat('MM/dd/yy').parse('04/03/20'));
  }

  static String parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  //default avatars

  static ImageProvider principalAvatar =
      const AssetImage('assets/images/principal.png');

  static BoxDecoration BtnDecoration = BoxDecoration(
    color: const Color(0xFF222744),
    borderRadius: BorderRadius.circular(10),
  );

  static Text checkTextValue(text, value) {
    return Text(
      '$text:: ' + value.toString(),
      style: const TextStyle(fontSize: 18),
    );
  }

  static int calculateLeaveDays(String from, String to) {
    //coonvert dd/mm/yyyy to yyyy-mm-dd
    var fromDate =
        DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(from));
    var toDate =
        DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(to));
    var date1 = DateTime.parse(fromDate);
    var date2 = DateTime.parse(toDate);
    var difference = date2.difference(date1);
    var days = difference.inDays;
    return days;
  }

  static String getLeaveDays(String toDate, String fromDate) {
    final df = new DateFormat('dd/MM/yyyy');
    //return toDate - fromDate

    DateTime from = DateTime.parse(fromDate);
    DateTime to = DateTime.parse(toDate);
    Duration difference = to.difference(from);
    int days = difference.inDays;
    print('Days: $days');
    return days.toString();
  }

  static Widget noDataTextWidget({String? message}) {
    return Center(
        child: Text(message ?? 'No data available.',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: ScreenUtil().setSp(16.0),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF415094),
            )));
  }

  static Widget noDataImageWidgetWithText(String message) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: ScreenUtil().setSp(100.0),
          ),
        ),
        Text(message)
      ],
    ));
  }

  static Widget documentViewer(String url, context) => SafeArea(
          child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Document Viewer',
        ),
        body: InteractiveViewer(
          panEnabled: true,
          maxScale: 4,
          scaleEnabled: true,
          constrained: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ));

  static Widget offlineDocumentViewer(String url, context) => SafeArea(
          child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Document Viewer',
        ),
        body: InteractiveViewer(
          panEnabled: true,
          maxScale: 4,
          scaleEnabled: true,
          constrained: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(url)),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ));

  static Widget fullScreenImageView(String url) => Scaffold(
        body: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => const CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl: InfixApi().root + 'public/uploads/staff/demo/staff.jpg',
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );

  static late PackageInfo packageInfo;

  //file upload progress idicator dialog from sent and total
  static Future<bool?> showUploadProgressDialog(
      BuildContext context, int sent, int total) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Uploading...',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: ScreenUtil().setSp(16.0),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF415094),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LinearProgressIndicator(
                  value: sent / total,
                ),
                Text(
                  '${(sent / total * 100).toStringAsFixed(0) + '%'}',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: ScreenUtil().setSp(16.0),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF415094),
                  ),
                ),
              ],
            ),
          );
        });
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  static void showSuccessBottomSheet(
    BuildContext context,
    String message,
  ) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[50]!,
                  ),
                ],
              ),
              height: ScreenUtil().setHeight(250),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/successfully-done.json',
                      height: ScreenUtil().setHeight(70),
                      width: ScreenUtil().setHeight(70),
                      frameRate: FrameRate(60),
                      repeat: false,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop('dialog');
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: Size(
                          ScreenUtil().setWidth(120),
                          ScreenUtil().setHeight(30),
                        ),
                        backgroundColor: const Color(0xFF222744),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showErrorBottomSheet(
      BuildContext context, String? title, String? message) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[50]!,
                  ),
                ],
              ),
              height: ScreenUtil().setHeight(250),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title ?? 'Error',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10.0),
                      child: Text(
                        message ?? 'Something went wrong',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop('dialog');
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: Size(
                          ScreenUtil().setWidth(120),
                          ScreenUtil().setHeight(30),
                        ),
                        backgroundColor: const Color(0xFF222744),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget documentViewer(String url, context) => SafeArea(
        child: Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Document Viewer',
      ),
      body: InteractiveViewer(
        panEnabled: true,
        maxScale: 4,
        scaleEnabled: true,
        constrained: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    ));
