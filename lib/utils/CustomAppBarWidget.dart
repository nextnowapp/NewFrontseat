// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/notification_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/main.dart';
import 'package:nextschool/screens/NotificationList.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/UserNotifications.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarWidget(
      {this.title, this.showNotification = false, this.appBarColor});
  Color? appBarColor;
  String? title;
  bool showNotification;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  int i = 0;

  int? rtlValue;
  String? _email;
  String? _password;
  String? _rule;
  String? _id;
  String? schoolId;
  String? adsBanner;
  String? isAdministrator;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  NotificationController _notificationController =
      Get.put(NotificationController());

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        'Cancel',
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.red,
            ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        'Yes',
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.green,
            ),
      ),
      onPressed: () async {
        Utils.clearAllValue();
        // Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
        Route route = MaterialPageRoute(
            builder: (context) => const MyApp(
                  rule: null,
                  zoom: null,
                  isLogged: false,
                  homeWidget: null,
                ));
        Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));

        var response = await http.post(Uri.parse(InfixApi.logout()),
            headers: Utils.setHeader(_token.toString()));
        // if (response.statusCode == 200) {
        // } else {
        //   Utils.showToast('Unable to logout');
        // }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: const Text('Would you like to logout?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future fetchSchool() async {
    var docRef;
    var _url = InfixApi().root;
    await FirebaseFirestore.instance
        .collection('school')
        .where('school_base_url', isEqualTo: _url)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        schoolId = value.docs[0].id;
        docRef = value.docs[0].data();
        adsBanner = docRef['sponsor_image_url'];
      }
    });
    return docRef;
  }

  Future<String> getImageUrl(String email, String password, String rule) async {
    var image = 'http://saskolhmg.com/images/studentprofile.png';
    var role = _userDetailsController.role;

    var response = await http.get(Uri.parse(InfixApi.login(email, password)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic>? user =
          (jsonDecode(response.body) as Map?) as Map<String, dynamic>?;
      if (rule == '2')
        image = InfixApi().root + user!['data']['userDetails']['student_photo'];
      else if (rule == '3')
        image = InfixApi().root + user!['data']['userDetails']['fathers_photo'];
      else
        image = InfixApi().root + user!['data']['userDetails']['staff_photo'];
    }
    return image == InfixApi().root
        ? 'http://saskolhmg.com/images/studentprofile.png'
        : '$image';
  }

  Future<UserNotificationList> getNotifications(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UserNotificationList.fromJson(jsonData['data']['notifications']);
    } else {
      throw Exception('failed to load');
    }
  }

  @override
  void initState() {
    _token = _userDetailsController.token;
    _email = _userDetailsController.email;
    Utils.getStringValue('password').then((value) {
      _password = value;
    });
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });
    _rule = _userDetailsController.roleId.toString();
    _id = _userDetailsController.id.toString();
    Utils.getStringValue('isAdministrator').then((value) {
      isAdministrator = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      leading: IconButton(
        onPressed: (() {
          navigateToPreviousPage(context);
        }),
        icon: SvgPicture.asset(
          'assets/svg/angle.svg',
          color: Colors.black,
          height: ScreenUtil().setSp(18),
        ),
      ),
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          widget.title!,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontFamily:
                    GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                fontSize: 18.sp,
                color: Colors.black,
              ),
        ),
      ),
      actions: [
        Visibility(
          visible: widget.showNotification,
          child: IconButton(
            icon: Stack(
              children: [
                SvgPicture.asset(
                  'assets/svg/bell.svg',
                  color: Colors.black,
                  height: ScreenUtil().setSp(20),
                ),
                Obx(
                  () => _notificationController.dataFetched
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(12),
                            height: ScreenUtil().setHeight(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _notificationController.unreadNotificationCount
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(8)),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => NotificationListScreen(
                    id: _id,
                    token: _token,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 5,
        )
      ],
    );
  }
}
