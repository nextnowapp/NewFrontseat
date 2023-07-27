//developer debug
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
// import 'package:new_version/new_version.dart';
import 'package:nextschool/controller/notification_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/ChangePassword.dart';
import 'package:nextschool/screens/Home.dart';
import 'package:nextschool/screens/ManagementProfileScreen.dart';
import 'package:nextschool/screens/NotificationList.dart';
import 'package:nextschool/screens/SettingsScreen.dart';
import 'package:nextschool/screens/calendar.dart';
import 'package:nextschool/screens/components/sidebarItem.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/screens/parent/parentProfile.dart';
import 'package:nextschool/screens/school/school_gen_info.dart';
// import 'package:nextschool/screens/profileScreen.dart';
import 'package:nextschool/screens/student/Profile.dart';
import 'package:nextschool/screens/study_guide/study_guide_home.dart';
import 'package:nextschool/screens/teacher/Profile/TeacherScreen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/permission_check.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';

import '../main.dart';
import 'parent/chat/ChatScreen.dart';

class CustomNavigationBar extends StatefulWidget {
  // const CustomNavigationBar({Key? key}) : super(key: key);
  final List<String> titles;
  final List<String> images;
  final String? rule;

  CustomNavigationBar({required this.titles, required this.images, this.rule});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  var t;
  var i;
  var _token;
  var rtlValue;
  String? _email;
  String? _id;
  String? _password;
  String? _rule;

  DateTime? currentBackPressTime;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  //notification count
  int? _notificationCount;

  // String _id;
  String? schoolId;
  String? adsBanner;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  PageController? _pageController;
  var InternetStatus = 'Unknown';
  var contentmessage = 'Unknown';
  String? a;
  String? b;
  final _firestore = FirebaseFirestore.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PermissionCheck permissionCheck = PermissionCheck();

  @override
  void initState() {
    // TODO: implement initState
    // _checkVersion();
    if (widget.rule == '6') {
      _pageController = PageController(initialPage: 3);
      _selectedIndex = 3;
    } else {
      _pageController = new PageController();
    }
    t = widget.titles;
    i = widget.images;

    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    _rule = _userDetailsController.roleId.toString();
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });

    //Check for all permission in app
    permissionCheck.checkPermissions(context);

    WidgetsBinding.instance.addObserver(this);
    // setstatus('Online');
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showUpdateDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ), //this right here
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ClipRRect(
                    //   borderRadius:
                    //       const BorderRadius.vertical(top: Radius.circular(20)),
                    //   child: Image.asset(
                    //     'assets/images/Update Image.png',
                    //     fit: BoxFit.fitWidth,
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Check for Updates',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'We have added new features and fixed few bugs to make your experience as smooth as possible',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Current version -> $b\nNew Version -> $a',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _launchURL(
                                    'https://play.google.com/store/apps/details?id=com.nextnow.sms');
                              },
                              child: const Text(
                                'Update App',
                                style: TextStyle(color: Colors.white),
                              ),
                              // color: const Color(0xFF222744),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        'No! Close the app.',
                        style: TextStyle(
                            color: Color(0xFF222744),
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split('.');
    List<String> newV = newVersion.split('.');
    bool a = true;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) >= int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return false;
  }

  NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      // setstatus('Online');
    } else {
      //offline
      // setstatus('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  void navigationTapped(int page) {
    _pageController!.animateToPage(page,
        duration: const Duration(microseconds: 300), curve: Curves.ease);
  }

  Future<String> getUserRole() async {
    var role = _userDetailsController.designation;
    return role;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawerScrimColor: Colors.black.withOpacity(0.2),
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SchoolGenInfoScreen()));
                },
                child: SizedBox(
                  height: size.height * 0.055,
                  child: FutureBuilder<dynamic>(
                      future: fetchSchool(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data['school_logo_url'],
                              width: 60.w);
                        }
                        return Container();
                      }),
                ),
              ),
              // const SizedBox(
              //   width: 37,
              // ),
            ],
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svg/bell.svg',
                    color: Colors.black,
                    height: 20.sp,
                  ),
                  Obx(
                    () => _notificationController.dataFetched
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              alignment: Alignment.center,
                              width: 12.sp,
                              height: 12.sp,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                _notificationController.unreadNotificationCount
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp),
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
            const SizedBox(
              width: 5,
            )
          ],
        ),

        drawer: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(
                20,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white60,
                      Colors.white24,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Drawer(
                  elevation: 0,
                  width: MediaQuery.of(context).size.width * 0.6,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        20,
                      ),
                    ),
                    side: BorderSide(
                      color: Colors.white30,
                      width: 1,
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.21,
                        child: DrawerHeader(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!_userDetailsController.isLogged)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 36.sp,
                                      child: Center(
                                        child: SvgPicture.asset(
                                            'assets/svg/Male.svg'),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Guest',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        //login
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const LandingScreen()));
                                          },
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              else
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (_userDetailsController.roleId ==
                                            2) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => Profile(
                                                        id: _userDetailsController
                                                            .id,
                                                      )));
                                        } else if (_userDetailsController
                                                .roleId ==
                                            3) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParentProfileScreen(
                                                        image: InfixApi().root +
                                                            _userDetailsController
                                                                .photo,
                                                        id: _userDetailsController
                                                            .id,
                                                      )));
                                        } else if (_userDetailsController
                                                .roleId ==
                                            4) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TeacherScreen()));
                                        } else if (_userDetailsController
                                                    .roleId ==
                                                1 ||
                                            _userDetailsController.roleId ==
                                                5) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ManagementScreen()));
                                        }
                                      },
                                      child: Obx(
                                        () => CircleAvatar(
                                          radius: 30.sp,
                                          // child: CachedNetworkImage(
                                          //   imageUrl: InfixApi().root +
                                          //       _userDetailsController.photo,
                                          //   imageBuilder:
                                          //       (context, imageProvider) =>
                                          //           Container(
                                          //     decoration: BoxDecoration(
                                          //       image: DecorationImage(
                                          //         image: imageProvider,
                                          //         fit: BoxFit.cover,
                                          //       ),
                                          //       borderRadius:
                                          //           const BorderRadius.all(
                                          //               Radius.circular(70)),
                                          //     ),
                                          //   ),
                                          //   placeholder: (context, url) =>
                                          //       Container(
                                          //     decoration: const BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius: BorderRadius.all(
                                          //           Radius.circular(15)),
                                          //       image: DecorationImage(
                                          //         image: AssetImage(
                                          //             'assets/images/principal.png'),
                                          //         fit: BoxFit.cover,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   errorWidget:
                                          //       (context, url, error) =>
                                          //           const DecoratedBox(
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius: BorderRadius.all(
                                          //           Radius.circular(15)),
                                          //       image: DecorationImage(
                                          //         image: AssetImage(
                                          //             'assets/images/principal.png'),
                                          //         fit: BoxFit.cover,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            imageUrl: InfixApi().root +
                                                _userDetailsController.photo,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(35)),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(35)),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/principal.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(35)),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/principal.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () => Text(
                                              (_userDetailsController.fullName
                                                      .toString())
                                                  .toLowerCase()
                                                  .titleCase,
                                              style: TextStyle(
                                                  fontFamily: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w700)
                                                      .fontFamily,
                                                  fontSize: 12.sp,
                                                  color: Colors.black87),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          FutureBuilder(
                                            future: getUserRole(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  (snapshot.data ==
                                                              'management' ||
                                                          snapshot.data ==
                                                              'Management')
                                                      ? 'Principal'
                                                      : snapshot
                                                          .data!.titleCase,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)
                                                              .fontFamily,
                                                      fontSize: 8.sp,
                                                      color:
                                                          HexColor('#8a96a0')),
                                                );
                                              } else {
                                                return const Text(
                                                  '',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              var schoolUrl = InfixApi().root;
                              final uri = Uri.parse(schoolUrl);
                              launch('https://${uri.host}');
                            },
                            child: const SidebarItem(
                              title: 'Visit School Website',
                              icon: CupertinoIcons.globe,
                            ),
                          ),
                          InkWell(
                              onTap: shareLink,
                              child: const SidebarItem(
                                icon: CupertinoIcons.paperplane,
                                title: 'Share School App',
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ChangePassword()));
                            },
                            child: const SidebarItem(
                              icon: CupertinoIcons.exclamationmark_shield,
                              title: 'Change Passcode',
                            ),
                          ),
                          InkWell(
                            onTap: () => Wiredash.of(context)!.show(),
                            child: const SidebarItem(
                              icon: CupertinoIcons.chat_bubble,
                              title: 'Suggest Feedback',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SettingScreen()));
                            },
                            child: const SidebarItem(
                              icon: CupertinoIcons.gear,
                              title: 'Settings',
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            _launchURL(
                                'https://play.google.com/store/apps/details?id=com.nextnow.sms');
                          }
                          if (Platform.isIOS) {
                            _launchURL(
                                'https://apps.apple.com/in/app/nextschool-school-management/id1585965090');
                          }
                        },
                        child: const SidebarItem(
                          icon: CupertinoIcons.arrow_up_square,
                          title: 'Check for Updates',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 12),
                        child: Text(
                          'App Version : ' + Utils.packageInfo.version,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        body: UpgradeAlert(
          child: new PageView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              new Home(t, i, this.widget.rule),
              Calendar(
                preventAppBar: true,
                rule: widget.rule,
              ),
              const ChatScreen(),
              const StudyGuideHomeScreen(),
            ],
            onPageChanged: _onItemTapped,
            controller: _pageController,
          ),
        ), //Center(

        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 0.0), // shadow direction: bottom right
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 45,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? HexColor('#4e88ff')
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 45,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? HexColor('#ffaa4e')
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 45,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 2
                                ? HexColor('#ff70bb')
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 45,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 3
                                ? HexColor('#3843d0')
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(31, 205, 205, 205),
                ),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/home.svg',
                        color: HexColor('#4e88ff'),
                        height: 18,
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SvgPicture.asset(
                        'assets/svg/idea.svg',
                        color: HexColor('#ffaa4e'),
                        height: 18,
                      ),
                    ),
                    label: 'Events',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SvgPicture.asset(
                        'assets/svg/chat.svg',
                        color: HexColor('#ff70bb'),
                        height: 18,
                      ),
                    ),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SvgPicture.asset(
                        'assets/svg/Grade 12th.svg',
                        color: HexColor('#3843d0'),
                        height: 18,
                      ),
                    ),
                    label: 'Grade 12',
                  ),
                ],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black,
                onTap: navigationTapped,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                enableFeedback: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchSchool() async {
    var docRef;
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    // var _url = AppConfig.domainName;
    var _url = userDetailsController.schoolUrl;
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

  shareLink() async {
    String link = 'http://onelink.to/p5ebtr';

    // if (Platform.isAndroid) {
    //   link = "";
    // }

    await FlutterShare.share(
        title: 'NextNow', text: '', linkUrl: link, chooserTitle: 'NextNow');
  }

  logoutUser() async {
    Utils.clearAllValue();
    var response = await http.post(Uri.parse(InfixApi.logout()),
        headers: Utils.setHeader(_token.toString()));
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
    Route route = MaterialPageRoute(
        builder: (context) => const MyApp(
              zoom: null,
              rule: null,
              isLogged: true,
              homeWidget: null,
            ));
    Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));

    // if (response.statusCode == 200) {
    // } else {
    //   Utils.showToast('Unable to logout');
    // }
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
}
