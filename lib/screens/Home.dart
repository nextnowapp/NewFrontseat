// Dart imports:

import 'dart:convert';

import 'package:after_layout/after_layout.dart';
// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
// Flutter imports:
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData;
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/NotificationList.dart';
import 'package:nextschool/screens/admin/class_wise_count.dart';
import 'package:nextschool/screens/choose_school.dart';
import 'package:nextschool/screens/landing_screen.dart';
import 'package:nextschool/screens/teacher/students/StudentListScreen.dart';
import 'package:nextschool/screens/teacher/upcoming_birthday.dart';
// Project imports:
import 'package:nextschool/utils/CardItem.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ReceivedSms.dart';
import 'package:nextschool/utils/model/birthday.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

//notificatiopn handler
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

// ignore: must_be_immutable
class Home extends StatefulWidget {
  List<String> _titles;
  var _images;
  var _rule;

  Home(this._titles, this._images, this._rule);

  @override
  _HomeState createState() => _HomeState(_titles, _images, _rule);
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  bool? isTapped;
  int? currentSelectedIndex;
  int? rtlValue;
  String? _email;
  String? _password;
  String? _id;
  String? schoolId;
  String? bigAdsBanner;
  String? smallAdsBanner;
  String? isAdministrator;

  List<String>? _titles;
  var _images;
  var _token;
  String _rule;
  AttendanceStatController attendanceStatController =
      Get.put(AttendanceStatController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _notificationToken;

  _HomeState(this._titles, this._images, this._rule);

  int _currentPage = 0;
  int? _totalPage;

  // defining function to fetch school name and school logo in notice board
  Future fetchCampaignDetails() async {
    // https://schoolmanagement.co.za/signup/api/campaign-search
    //use dio for post request
    var dio = Dio();
    var data = FormData.fromMap({
      'school_id': schoolId!,
      'role_id': _userDetailsController.roleId,
      'age': _userDetailsController.age,
      'gender': _userDetailsController.genderId
    });
    var response = await dio.post(
      'https://schoolmanagement.co.za/signup/api/campaign-search',
      data: data,
    );
    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        bigAdsBanner = response.data['data']['big_banner_image_url'];
        smallAdsBanner = response.data['data']['small_banner_image_url'];
      });
    }
    return bigAdsBanner;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    //check whether the user is verified or not and display phone number addition dialogue

    Utils.getBooleanValue('IsFirstTimeLaunchedApp').then((value) {
      if (value == false) {
        showHelloWorld();
        saveBooleanValue('IsFirstTimeLaunchedApp', true);
      }
    });
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  void showHelloWorld() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FutureBuilder(
                        future: fetchCampaignDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(imageUrl: bigAdsBanner!);
                          } else
                            return Container();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 13,
                  height: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Icon(CupertinoIcons.clear_thick_circled,
                        color: Colors.black87, size: 30),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<Birthdays?>? birthday;
  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //TODO: unid fix
    // var uid = '';
    // if (_rule != '6') {
    //   uid = _userDetailsController.unid;
    // }

    _token = _userDetailsController.token;

    _email = _userDetailsController.email;
    Utils.getStringValue('password').then((value) {
      _password = value;
    });
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });
    _id = _userDetailsController.id.toString();
    Utils.getStringValue('isAdministrator').then((value) {
      isAdministrator = value;
    });

    //init settings for android
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //     onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     debugPrint('notification payload: ' + payload);
      //   }
      //   selectNotificationSubject.add(payload);
      // }
    );

    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {},
            )
          ],
        ),
      );
    });

    selectNotificationSubject.stream.listen((String? payload) async {});
    this.notificationSubscription();
    isTapped = false;

    birthday = fetchBirthday();
  }

  notificationSubscription() async {
    print('token get');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.getToken().then((value) {
      setState(() {
        _notificationToken = value;
        sendTokenToServer(_notificationToken);
        print('Notify TOKEN Got: $_notificationToken');
      });
    });
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final receivedSms = receivedSmsFromJson(message.data['message']);

      if (receivedSms.phoneNumber == null) {
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          if (mounted) {}

          RemoteNotification notification = message.notification!;

          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    });

    //push to NotificationListScreen when user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        if (mounted) {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationListScreen(
                    id: _userDetailsController.id.toString(),
                    token: _userDetailsController.token),
              ),
            );
          } catch (e) {
            print(e.toString());
          }
        }
      }
    });

    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      //route to NotificationListScreen when user taps on notification
      print('Handling a background message: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        if (mounted) {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationListScreen(
                    id: _userDetailsController.id.toString(),
                    token: _userDetailsController.token),
              ),
            );
          } catch (e) {
            print(e.toString());
          }
        }
      }
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<Birthdays?>? fetchBirthday() async {
    print('fetch birthday started');
    final response = await http.get(Uri.parse(InfixApi.getAllBirthday(_id)),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('fetch birthday completed');
      return Birthdays.fromJson(jsonData);
    } else
      throw Exception('failed to load');
  }

  //function to return itemcount for 3x3 grid
  int _getItemCount(int total, int page) {
    //return max 9 items per page
    if (total > (page + 1) * 9) {
      return 9;
    } else {
      return total - page * 9;
    }
  }

  @override
  Widget build(BuildContext context) {
    _totalPage = _titles!.length % 9 == 0
        ? _titles!.length ~/ 9
        : _titles!.length ~/ 9 +
            1; //it will automatically decide the no fof pages required for the gridview

    List<Widget> _list = List.generate(_totalPage!, (counter) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _getItemCount(_titles!.length, counter),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            childAspectRatio: 2 / 2,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return CustomWidget(
            index: (counter * 9) + index,
            isSelected: currentSelectedIndex == (counter * 9) + index,
            onSelect: () {
              setState(() {
                currentSelectedIndex = (counter * 9) + index;
              });
            },
            element: getWidget(_titles![(counter * 9) + index]),
            headline: _titles![(counter * 9) + index],
            icon: _images[(counter * 9) + index],
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  children: [
                    Visibility(
                        visible: _rule == '5',
                        child: Obx(
                          () => attendanceStatController.dataFetched
                              ? Container(
                                  height: 25.h,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        left: 10,
                                        right: 10,
                                        bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[200]!,
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Total Learners: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalLearners)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //draw a vertical line
                                            Container(
                                              height: 60,
                                              width: 1,
                                              color: Colors.grey[300],
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Total Boys: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalBoys)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              width: 1,
                                              color: Colors.grey[300],
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Total Girls: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalGirls)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.001,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Total Teachers: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalTeachers)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //draw a vertical line
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              width: 1,
                                              color: Colors.grey[300],
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Todays Attendance: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      (attendanceStatController
                                                                  .todayAttendacePercentage)
                                                              .toStringAsFixed(
                                                                  0) +
                                                          '%',
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.055,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[50]),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ClassSectionWiseCount(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'View by Class',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/icons/arrow-right.svg',
                                                  color: Colors.black,
                                                  height: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Shimmer.fromColors(
                                  child: Container(
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white70,
                                  direction: ShimmerDirection.ltr,
                                  enabled: true,
                                  loop: 1000,
                                  period: const Duration(milliseconds: 1000),
                                ),
                        )),
                    Visibility(
                        visible: _rule == '4',
                        child: Obx(
                          () => attendanceStatController.dataFetched
                              ? Container(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        left: 10,
                                        right: 10,
                                        bottom: 5),
                                    decoration: BoxDecoration(
                                      color: HexColor('#FFEED4'),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //draw a vertical line

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Total Boys in\nSchool: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalBoys)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 26.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Total Girls in\nSchool: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalGirls)
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'School Attendance\nToday: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                    .todayAttendacePercentage)
                                                                .toStringAsFixed(
                                                                    0) +
                                                            '%',
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //draw a vertical line

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Total Boys in\nClass: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalBoysinClass)
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Total Girls in\nClass: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                .totalGirlsinClass)
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 7),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: HexColor('#fffbf7'),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Class Attendance\nToday: ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        (attendanceStatController
                                                                    .classAttendacePercentage ==
                                                                'null'
                                                            ? '0'
                                                            : attendanceStatController
                                                                .classAttendacePercentage
                                                                .toString()),
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#151f3e'),
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        attendanceStatController.classs != ''
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Text(
                                                      'Class : ${attendanceStatController.classs}',
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Visibility(
                                                    visible:
                                                        attendanceStatController
                                                                .classs !=
                                                            '',
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                        height: 35,
                                                        child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      right:
                                                                          16),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25)),
                                                              backgroundColor:
                                                                  HexColor(
                                                                      '#4AC19E')),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        StudentListScreen(
                                                                  url: InfixApi
                                                                      .getStudentbyTeacher(
                                                                          _userDetailsController
                                                                              .id),
                                                                  status:
                                                                      'attendance',
                                                                  token:
                                                                      _userDetailsController
                                                                          .token,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                'View Class Attendance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              SvgPicture.asset(
                                                                'assets/icons/arrow-right.svg',
                                                                color: Colors
                                                                    .white,
                                                                height: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        'Class: Class Not Assigned!',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              : Shimmer.fromColors(
                                  child: Container(
                                    height: 22.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white70,
                                  direction: ShimmerDirection.ltr,
                                  enabled: true,
                                  loop: 1000,
                                  period: const Duration(milliseconds: 1000),
                                ),
                        )),
                    Visibility(
                      visible: _rule == '4',
                      child: Column(
                        children: [
                          FutureBuilder<Birthdays?>(
                              future: birthday,
                              builder: (context, snpahot) {
                                if (snpahot.connectionState ==
                                    ConnectionState.done) {
                                  if (snpahot.data == null) {
                                    return Container();
                                  } else if (snpahot.data!.data!.length > 0) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.cake,
                                                  color: Colors.orange,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Upcoming Birthdays',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#8799b3'),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/calendar-2852107 (1).svg',
                                                  color: HexColor('#8799b3'),
                                                  height: 12,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snpahot.data!.data![0]
                                                      .dateOfBirth!,
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#8799b3'),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 2,
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snpahot.data!.data![0]
                                                      .firstName!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UpcomingBirthDayScreen(
                                                                          id: _id,
                                                                          token:
                                                                              _token,
                                                                        )),
                                                          );
                                                        },
                                                        child: const Text(
                                                            'See all')),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.blue,
                                                      size: 12,
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 10),
                height: 50.h,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    if (this.mounted)
                      setState(() {
                        _currentPage = value;
                      });
                  },
                  children: [..._list],
                ),
              ),
              Visibility(
                visible: _totalPage == 1 ? false : true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      _totalPage!,
                      (index) => Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Container(
                          height: 2,
                          width: 20,
                          decoration: BoxDecoration(
                            color: (_currentPage == index)
                                ? Colors.black
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: !_userDetailsController.isLogged,
                child: Container(
                  child: Column(
                    children: [
                      const Text(
                        'You are not logged in. Please login to continue.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[50]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LandingScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/arrow-right.svg',
                              color: Colors.black,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? getWidget(String title) {
    if (_rule == '2') {
      return AppFunction.getDashboardPage(context, title,
          id: _id, token: _token);
    } else if (_rule == '4') {
      return AppFunction.getTeacherDashboardPage(context, title, _id);
    } else if (_rule == '3') {
      return AppFunction.getParentDashboardPage(context, title, _id, _token);
    } else if (_rule == '1' || _rule == '5') {
      if (isAdministrator == 'yes') {
        return AppFunction.getSaasAdminDashboardPage(context, title, _id);
      } else if (_rule == '6') {
        return AppFunction.getGuestDashboard(context, title, _id);
      } else {
        return AppFunction.getAdminDashboardPage(context, title, _id);
      }
    }
    return null;
  }

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  void sendTokenToServer(String? token) async {
    print('Send token: $token');
    Dio dio = Dio();
    dio.options.headers = Utils.setHeader(_token);
    var response = await dio
        .get(
      InfixApi.setToken(_id, token),
    )
        .catchError((e) {
      switch (e.response.statusCode) {
        case 400:
          Utils.showToast('${e.response.data['message']}');
          break;
        case 401:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 403:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 404:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 500:
          Utils.showToast('${e.response.data['message']}');

          break;
        default:
          Utils.showToast('${e.response.data['message']}');
      }
    });

    print(response.data);
    if (response.statusCode == 200) {
      print(response.data.toString());
      print('token updated : $token');
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [],
      ),
    );
  }
}
