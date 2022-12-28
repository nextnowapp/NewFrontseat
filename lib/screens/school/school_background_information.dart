import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/school/edit_school_background_information.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/school_bg_info.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/edit_button.dart';
import 'package:sizer/sizer.dart';

class SchoolBackgroundInformationScreen extends StatefulWidget {
  const SchoolBackgroundInformationScreen({Key? key}) : super(key: key);

  @override
  State<SchoolBackgroundInformationScreen> createState() =>
      _SchoolBackgroundInformationScreenState();
}

class _SchoolBackgroundInformationScreenState
    extends State<SchoolBackgroundInformationScreen> {
  SchoolBgInfo? schoolBgInfo;

  AttendanceStatController attendanceStatController =
      Get.put(AttendanceStatController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarColor: HexColor('#fff5bd'),
        title: 'School Background Information',
      ),
      backgroundColor: HexColor('#EAEAEA'),
      body: FutureBuilder<dynamic>(
        future: fetchSchool(),
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: Container(
                child: ListView(
                  padding: EdgeInsets.all(12.sp),
                  children: [
                    //school card with logo and school name
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          //school logo
                          CachedNetworkImage(
                            height: 80,
                            width: 80,
                            imageUrl: schoolBgInfo!.favicon!,
                            placeholder: (context, url) {
                              return Container(
                                height: 80,
                                width: 80,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Image.network(
                              'https://play-lh.googleusercontent.com/NdfoU7rlUk8FlCCxl8ws4gBRdA8sHKhivkFwZv4QikEWV22nuQwSIpyttmt3JmKjBg8=w480-h960-rw',
                              height: 80,
                              width: 80,
                            ),
                          ),
                          //vertical divider
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            color: Colors.grey,
                            width: 1,
                            height: 50,
                          ),
                          //school name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'School Name',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                schoolBgInfo!.schoolName!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //founded card with image and date
                    Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //school logo
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SvgPicture.asset(
                              'assets/images/our_school/Founded on.svg',
                              height: 60,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                //vertical divider
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  color: Colors.grey,
                                  width: 1,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                //school name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Founded',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.blue,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      schoolBgInfo!.founded!,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Our Slogan
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //school logo
                          SvgPicture.asset(
                            'assets/images/our_school/Slogan.svg',
                            height: 60,
                          ),
                          Row(
                            children: [
                              //vertical divider
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                color: Colors.grey,
                                width: 1,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //school name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Our Slogan',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ).fontFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 60.w,
                                    child: Text(
                                      schoolBgInfo!.ourSlogan!,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //mission
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              //school logo
                              SvgPicture.asset(
                                'assets/images/our_school/Our Vision.svg',
                                height: 60,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              //school name
                              Text(
                                'Our Vision',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              schoolBgInfo!.ourVision!,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                ).fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //values
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //school logo
                          SvgPicture.asset(
                            'assets/images/our_school/Group 254.svg',
                            height: 60,
                          ),
                          Row(
                            children: [
                              //vertical divider
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                color: Colors.grey,
                                width: 1,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //school name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Our Values',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ).fontFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 60.w,
                                    child: Text(
                                      schoolBgInfo!.ourValues!,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Our Mission
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              //school logo
                              SvgPicture.asset(
                                'assets/images/our_school/Our Mission.svg',
                                width: 65,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              //school name
                              Text(
                                'Our Mission',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              schoolBgInfo!.ourMission!,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                ).fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //counts of learners and staffs 432

                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //Svg Image
                                SvgPicture.asset(
                                    'assets/images/our_school/Students.svg'),
                                Column(
                                  children: [
                                    Text(
                                      'No. of Learners',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.blue,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                    Text(
                                      attendanceStatController.totalLearners
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //vertical divider
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            color: Colors.grey[400],
                            width: 1,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //Svg Image
                                SvgPicture.asset(
                                    'assets/images/our_school/Teachers.svg'),
                                Column(
                                  children: [
                                    Text(
                                      'No. of Educators',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.blue,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                    Text(
                                      attendanceStatController.totalTeachers
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //history
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //school logo
                          SvgPicture.asset(
                            'assets/images/our_school/Our History.svg',
                            height: 60,
                          ),
                          Row(
                            children: [
                              //vertical divider
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                color: Colors.grey,
                                width: 1,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //school name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Our History',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ).fontFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 60.w,
                                    child: Text(
                                      schoolBgInfo!.ourHistory!,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),
      floatingActionButton: _userDetailsController.roleId != 5
          ? Container()
          : Container(
              width: 80,
              child: EditButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditSchoolBackgroundInformationScreen(
                        schoolBgInfo: schoolBgInfo!,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future fetchSchool() async {
    String token =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3ZWJfc2Nob29sX2xpbmtfa2V5IjoiMmYzZTE3YzI5MTcxYjVhZTE5YjYxMTcwYTQzMDg5NiJ9.lp4i__kEfzzu6Mtv6zjA3lqiLPPvwRe6KhUyZm-1btA';

    var response = await http.get(
        Uri.parse(
            InfixApi.getSchoolBackgroundInfo(_userDetailsController.schoolId)),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      //decode response
      var decoded = jsonDecode(response.body);
      print(decoded);
      schoolBgInfo = SchoolBgInfo.fromJson(decoded['data']);
    } else {
      var decoded = jsonDecode(response.body);
      var message = decoded['message'];
      Utils.showErrorToast(message);

      throw Exception('Failed to load');
    }
  }

  //refresh function
  Future<void> refresh() async {
    String token =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3ZWJfc2Nob29sX2xpbmtfa2V5IjoiMmYzZTE3YzI5MTcxYjVhZTE5YjYxMTcwYTQzMDg5NiJ9.lp4i__kEfzzu6Mtv6zjA3lqiLPPvwRe6KhUyZm-1btA';

    var response = await http.get(
        Uri.parse(
            InfixApi.getSchoolBackgroundInfo(_userDetailsController.schoolId)),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      //decode response
      var decoded = jsonDecode(response.body);
      setState(() {
        schoolBgInfo = SchoolBgInfo.fromJson(decoded['data']);
      });
    } else {
      var decoded = jsonDecode(response.body);
      var message = decoded['message'];
      Utils.showErrorToast(message);
      throw Exception('Failed to load');
    }
  }
}
