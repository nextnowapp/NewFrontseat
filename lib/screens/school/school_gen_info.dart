import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/ClassTimeSetup/class_time_list.dart';
import 'package:nextschool/screens/school/edit_school_gen_info.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/school_gen_info_model.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/edit_button.dart';
import 'package:nextschool/utils/widget/school_detail_card.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolGenInfoScreen extends StatefulWidget {
  SchoolGenInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SchoolGenInfoScreen> createState() => _SchoolGenInfoScreenState();
}

class _SchoolGenInfoScreenState extends State<SchoolGenInfoScreen> {
  SchoolGenInfo? schoolGenInfo;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'School General Information',
        appBarColor: HexColor('#fff5bd'),
      ),
      backgroundColor: HexColor('#EAEAEA'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 12.sp, left: 12.sp, right: 12.sp),
          child: FutureBuilder<dynamic>(
            future: fetchSchool(),
            builder: (context, snapshot) {
              if (ConnectionState.done == snapshot.connectionState) {
                return RefreshIndicator(
                  onRefresh: refresh,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 25.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                                image: NetworkImage(
                                  schoolGenInfo!.featuredImage!,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 60.h,
                          child: ListView(
                            children: [
                              SchoolDetailCard(
                                image:
                                    'assets/images/our_school/School Name.svg',
                                title: 'School Name',
                                value: schoolGenInfo!.schoolName.toString(),
                              ),
                              SchoolDetailCard(
                                image:
                                    'assets/images/our_school/School Hours.svg',
                                title: 'School Office Hours',
                                value: (schoolGenInfo!.schoolOfficeStatTime !=
                                            null
                                        ? time24To12(schoolGenInfo!
                                            .schoolOfficeStatTime
                                            .toString())
                                        : '') +
                                    ' to ' +
                                    (schoolGenInfo!.schoolOfficeEndTime != null
                                        ? time24To12(schoolGenInfo!
                                            .schoolOfficeEndTime!
                                            .toString())
                                        : ''),
                              ),
                              SchoolDetailCard(
                                image: 'assets/images/our_school/Emis.svg',
                                title: 'School EMIS',
                                value: schoolGenInfo!.schoolEmis.toString(),
                              ),
                              SchoolDetailCard(
                                image: 'assets/images/our_school/Address.svg',
                                title: 'School Address',
                                value: schoolGenInfo!.schoolAddress.toString(),
                              ),
                              SchoolDetailCard(
                                image: 'assets/images/our_school/Phone no..svg',
                                title: 'School Phone No.',
                                value: schoolGenInfo!.phone.toString(),
                                ontap: () async {
                                  launchUrl(Uri.parse(
                                      'tel:${schoolGenInfo!.phone.toString()}'));
                                },
                              ),
                              SchoolDetailCard(
                                image: 'assets/images/our_school/E-mail.svg',
                                title: 'School E-mail',
                                value: schoolGenInfo!.email.toString(),
                                ontap: () async {
                                  launchUrl(Uri.parse(
                                      'mailto:${schoolGenInfo!.email.toString()}'));
                                },
                              ),
                              SchoolDetailCard(
                                image: 'assets/images/our_school/District.svg',
                                title: 'District Information',
                                value: schoolGenInfo!.districtName.toString(),
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
        ),
      ),
      floatingActionButton: _userDetailsController.roleId != 5
          ? Container()
          : Row(
              children: [
                const Spacer(),
                EditButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            EditSchoolGeneralInformationScreen(
                          schoolGenInfo: schoolGenInfo!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future fetchSchool() async {
    String token =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3ZWJfc2Nob29sX2xpbmtfa2V5IjoiMmYzZTE3YzI5MTcxYjVhZTE5YjYxMTcwYTQzMDg5NiJ9.lp4i__kEfzzu6Mtv6zjA3lqiLPPvwRe6KhUyZm-1btA';

    var response = await http.get(
        Uri.parse(
            InfixApi.getSchoolGeneralInfo(_userDetailsController.schoolId)),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      //decode response
      var decoded = jsonDecode(response.body);
      print(decoded);
      schoolGenInfo = SchoolGenInfo.fromJson(decoded['data']);
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
            InfixApi.getSchoolGeneralInfo(_userDetailsController.schoolId)),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      //decode response
      var decoded = jsonDecode(response.body);
      setState(() {
        schoolGenInfo = SchoolGenInfo.fromJson(decoded['data']);
      });
    } else {
      var decoded = jsonDecode(response.body);
      var message = decoded['message'];
      Utils.showErrorToast(message);
      throw Exception('Failed to load');
    }
  }
}
