// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/notice/notice_list.dart';
import 'package:nextschool/screens/student/StudentAttendance.dart';
import 'package:nextschool/screens/student/homework/StudentHomework.dart';
import 'package:nextschool/screens/student/studyMaterials/StudentAssignment.dart';
import 'package:nextschool/screens/student/studyMaterials/StudentOtherDownloads.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialList.dart';
import 'package:nextschool/screens/teacher/content/staffContentScreen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/UserNotifications.dart';
// Project imports:
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

import 'student/notice/NoticeScreen.dart';

// ignore: must_be_immutable
class NotificationListScreen extends StatefulWidget {
  String? id;
  String? token;

  NotificationListScreen({
    this.id,
    this.token,
  });

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  Future<UserNotificationList?>? notifications;

  _NotificationListScreenState();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      notifications = getNotifications(int.parse(widget.id!));
    });
  }

  @override
  void initState() {
    super.initState();

    widget.token = _userDetailsController.token;

    widget.id = _userDetailsController.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Notifications',
        showNotification: false,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () {},
                  label: const TextWidget(
                    txt: 'Mark as Read',
                    clr: Colors.blue,
                  ),
                  icon: const Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.blue,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10, right: 10, bottom: 20),
              child: FutureBuilder<UserNotificationList?>(
                future: notifications,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.userNotifications.length == 0) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'No new notifications!!',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Divider(thickness: 1),
                          );
                        },
                        itemCount: snapshot.data!.userNotifications.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () => {
                                    navigateToDetailPage(
                                        snapshot
                                            .data!.userNotifications[index].url,
                                        snapshot
                                            .data!.userNotifications[index].id,
                                        snapshot.data!.userNotifications[index]
                                                .routingId ??
                                            0),
                                  },
                              child: ListTile(
                                title: Row(
                                  children: [
                                    snapshot.data!.userNotifications[index]
                                                .isRead ==
                                            0
                                        ? const CircleAvatar(
                                            radius: 4.5,
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextWidget(
                                        txt: snapshot.data!
                                            .userNotifications[index].message!,
                                        size: 16,
                                        clr: Colors.black,
                                        weight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: CircleAvatar(
                                  backgroundColor: snapshot
                                              .data!
                                              .userNotifications[index]
                                              .isRead ==
                                          0
                                      ? Colors.blue
                                      : Colors.grey,
                                  radius: 20,
                                  child: const Icon(
                                    Icons.notifications_active,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 18),
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        txt: snapshot
                                            .data!.userNotifications[index].date
                                            .toString(),
                                        clr: Colors.grey,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                  } else {
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ShimmerList(
                          itemCount: 1,
                          height: 80,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  navigateToDetailPage(
      String? title, int? notificationId, int routeUserId) async {
    print(title);
    switch (title) {
      //routing for staff role
      // digital content
      case 'staff-content':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffContentScreen(),
          ),
        );
        break;

      // notice
      case 'staff-notice':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoticeListScreen(),
          ),
        );
        break;

      case 'notice-list':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoticeListScreen(),
          ),
        );
        break;

      //routing for parent role
      // digital content
      case 'parent-attendance':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentAttendanceScreen(
                id: routeUserId, token: _userDetailsController.token),
          ),
        );
        break;

      // homework
      case 'parent-homework':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomework(id: routeUserId.toString()),
          ),
        );
        break;

      // digital content
      case 'parent-ot-content':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentOtherDownloads(
              id: routeUserId.toString(),
            ),
          ),
        );
        break;

      case 'parent-st-content':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudyMaterialList(
              id: routeUserId.toString(),
            ),
          ),
        );
        break;

      case 'parent-as-content':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentAssignment(
              id: routeUserId.toString(),
            ),
          ),
        );
        break;

      // notice
      case 'parent-notice':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeScreen(),
          ),
        );
        break;

      // case 'assignment-list':
      //   if (rule == '1') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   } else if (rule == '2') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentAssignment(id: (widget.id)),
      //       ),
      //     );
      //   } else if (rule == '3') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentAssignment(id: (widget.id)),
      //       ),
      //     );
      //   } else if (rule == '4') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   }

      //   break;
      // case 'student-study-material':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => StudyMaterialList(
      //               id: (int.parse(this.widget.id!) - 1).toString(),
      //             )),
      //   );
      //   break;

      // case 'study-material':
      //   if (rule == '1') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   } else if (rule == '2') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudyMaterialList(id: (widget.id)),
      //       ),
      //     );
      //   } else if (rule == '3') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudyMaterialList(id: (widget.id)),
      //       ),
      //     );
      //   } else if (rule == '4') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   }

      //   break;

      // case 'student-assignment':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => StudentAssignment(
      //               id: (int.parse(this.widget.id!) - 1).toString(),
      //             )),
      //   );
      //   break;

      // case 'student-syllabus':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => StudentSyllabus(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;
      // case 'parent-homework':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => StudentHomework(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;

      // case 'notice-list':
      //   if (rule == '1') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const NoticeListScreen(),
      //       ),
      //     );
      //   } else if (rule == '2') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => NoticeScreen(),
      //       ),
      //     );
      //   } else if (rule == '3') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => NoticeScreen(),
      //       ),
      //     );
      //   } else if (rule == '4') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => NoticeScreen(),
      //       ),
      //     );
      //   }

      //   break;

      // case 'parent-noticeboard':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NoticeScreen(),
      //     ),
      //   );
      //   break;
      // case 'other-download-list':
      //   if (rule == '1') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   } else if (rule == '2') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentOtherDownloads(
      //           id: (int.parse(this.widget.id!) - 1).toString(),
      //         ),
      //       ),
      //     );
      //   } else if (rule == '3') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentOtherDownloads(
      //           id: (int.parse(this.widget.id!) - 1).toString(),
      //         ),
      //       ),
      //     );
      //   } else if (rule == '4') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ContentListScreen(),
      //       ),
      //     );
      //   }

      //   break;

      // case 'student-others-download':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => StudentOtherDownloads(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;

      // case 'homework-list':
      //   if (rule == '1') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => TeacherHomework(),
      //       ),
      //     );
      //   } else if (rule == '2') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentHomework(
      //           id: (int.parse(this.widget.id!) - 1).toString(),
      //         ),
      //       ),
      //     );
      //   } else if (rule == '3') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => StudentHomework(
      //           id: (int.parse(this.widget.id!) - 1).toString(),
      //         ),
      //       ),
      //     );
      //   } else if (rule == '4') {
      //     return Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => TeacherHomework(),
      //       ),
      //     );
      //   }

      //   break;

      // case 'pending-leave':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LeaveListStudent(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;

      // case 'approved-leave':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LeaveListStudent(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;

      // case 'rejected-leave':
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LeaveListStudent(
      //         id: (int.parse(this.widget.id!) - 1).toString(),
      //       ),
      //     ),
      //   );
      //   break;
    }

    var response = await http.get(
        Uri.parse(InfixApi.readMyNotifications(
            int.parse(this.widget.id!), notificationId)),
        headers: Utils.setHeader(this.widget.token.toString()));
    if (response.statusCode == 200) {
      Map<String, dynamic> notifications =
          (jsonDecode(response.body) as Map) as Map<String, dynamic>;
      bool? status = notifications['data']['status'];
      if (status == true) {
        setState(() {
          print('Index :$notificationId');
        });
      }
    } else {
      print('Error retrieving from api');
    }
  }

  Future<UserNotificationList?>? getNotifications(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),
        headers: Utils.setHeader(widget.token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UserNotificationList.fromJson(jsonData['data']['notifications']);
    } else {
      throw Exception('failed to load');
    }
  }
}

// ignore: must_be_immutable
class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  AppBarWidget({this.title});

  String? title;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  int i = 0;
  Future? notificationCount;

  int? rtlValue;
  String? _email;
  String? _password;
  String? _rule;
  String? _id;
  String? schoolId;
  String? isAdministrator;
  String? _token;

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF222744),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    child: IconButton(
                        tooltip: 'Back',
                        icon: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(20),
                        ),
                        onPressed: () {
                          navigateToPreviousPage(context);
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      widget.title!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: ScreenUtil().setSp(20),
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}
