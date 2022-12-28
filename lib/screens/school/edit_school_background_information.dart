import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:nextschool/controller/attendance_stat_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/school_bg_info.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditSchoolBackgroundInformationScreen extends StatefulWidget {
  final SchoolBgInfo schoolBgInfo;
  const EditSchoolBackgroundInformationScreen(
      {Key? key, required this.schoolBgInfo})
      : super(key: key);

  @override
  State<EditSchoolBackgroundInformationScreen> createState() =>
      _EditSchoolBackgroundInformationScreenState();
}

class _EditSchoolBackgroundInformationScreenState
    extends State<EditSchoolBackgroundInformationScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolNameController;
  late TextEditingController _founded;
  late TextEditingController _ourSlogan;
  late TextEditingController _ourVision;
  late TextEditingController _ourValues;
  late TextEditingController _ourMission;
  late TextEditingController _ourHistory;
  late TextEditingController _learners;
  late TextEditingController _educators;

  //attendancestat controller injection
  AttendanceStatController attendanceStatController =
      Get.put(AttendanceStatController());

  //userdetailsController injection
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  // add focus node
  FocusNode _schoolNameFocusNode = FocusNode();
  FocusNode _foundedFocusNode = FocusNode();
  FocusNode _ourSloganFocusNode = FocusNode();
  FocusNode _ourVisionFocusNode = FocusNode();
  FocusNode _ourValuesFocusNode = FocusNode();
  FocusNode _ourMissionFocusNode = FocusNode();
  FocusNode _ourHistoryFocusNode = FocusNode();
  FocusNode _learnersFocusNode = FocusNode();
  FocusNode _educatorsFocusNode = FocusNode();

  //initstate
  @override
  void initState() {
    _schoolNameController =
        TextEditingController(text: widget.schoolBgInfo.schoolName);
    _founded = TextEditingController(text: widget.schoolBgInfo.founded);
    _ourSlogan = TextEditingController(text: widget.schoolBgInfo.ourSlogan);
    _ourVision = TextEditingController(text: widget.schoolBgInfo.ourVision);
    _ourValues = TextEditingController(text: widget.schoolBgInfo.ourValues);
    _ourMission = TextEditingController(text: widget.schoolBgInfo.ourMission);
    _ourHistory = TextEditingController(text: widget.schoolBgInfo.ourHistory);
    _learners = TextEditingController(
        text: attendanceStatController.totalLearners.toString());
    _educators = TextEditingController(
        text: attendanceStatController.totalTeachers.toString());

    super.initState();
  }

  //dispose
  @override
  void dispose() {
    _schoolNameController.dispose();
    _founded.dispose();
    _ourSlogan.dispose();
    _ourVision.dispose();
    _ourValues.dispose();
    _ourMission.dispose();
    _ourHistory.dispose();
    _learners.dispose();
    _educators.dispose();

    // dispose focus node
    _schoolNameFocusNode.dispose();
    _foundedFocusNode.dispose();
    _ourSloganFocusNode.dispose();
    _ourVisionFocusNode.dispose();
    _ourValuesFocusNode.dispose();
    _ourMissionFocusNode.dispose();
    _ourHistoryFocusNode.dispose();
    _learnersFocusNode.dispose();
    _educatorsFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Edit Background Information',
      ),
      body: Container(
        padding: EdgeInsets.all(12.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/School Name.svg',
                  ),
                ),
                focusNode: _schoolNameFocusNode,
                hint: 'School Name',
                controller: _schoolNameController,
                lines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Founded on.svg',
                  ),
                ),
                focusNode: _foundedFocusNode,
                hint: 'Founded',
                controller: _founded,
                lines: 1,
                type: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter when school was founded';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Our Slogan.svg',
                  ),
                ),
                focusNode: _ourSloganFocusNode,
                hint: 'Our Slogan',
                controller: _ourSlogan,
                lines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school slogan';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Our Vision.svg',
                  ),
                ),
                focusNode: _ourVisionFocusNode,
                hint: 'Our Vision',
                controller: _ourVision,
                lines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school vision';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Gr.svg',
                  ),
                ),
                focusNode: _ourValuesFocusNode,
                hint: 'Our Values',
                controller: _ourValues,
                lines: 2,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school values';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Our Mission.svg',
                  ),
                ),
                focusNode: _ourMissionFocusNode,
                hint: 'Our Mission',
                controller: _ourMission,
                lines: 5,
                validator: (value) {
                  if (value!.isEmpty && !value.contains('@')) {
                    return 'Please enter school mission';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TxtField(
                      focusNode: _learnersFocusNode,
                      hint: 'No. of Learners',
                      controller: _learners,
                      lines: 1,
                      readonly: true,
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter no of learners';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: TxtField(
                      focusNode: _educatorsFocusNode,
                      hint: 'No. of Educators',
                      readonly: true,
                      controller: _educators,
                      lines: 1,
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter no of educators';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/Our History.svg',
                  ),
                ),
                focusNode: _ourHistoryFocusNode,
                hint: 'Our History',
                controller: _ourHistory,
                lines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school district';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              //button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
        child: Material(
          color: const Color(0xFF222744),
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                ),
              ),
            ),
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                //do something after validation is done
                await updateSchoolBgInfo();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateSchoolBgInfo() async {
    //use dio to update school general info

    String token =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3ZWJfc2Nob29sX2xpbmtfa2V5IjoiMmYzZTE3YzI5MTcxYjVhZTE5YjYxMTcwYTQzMDg5NiJ9.lp4i__kEfzzu6Mtv6zjA3lqiLPPvwRe6KhUyZm-1btA';
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token.toString()},
      contentType: 'application/json',
    ));
    //params
    Map<String, dynamic> params = {
      'school_id': _userDetailsController.schoolId,
      'school_name': _schoolNameController.text,
      'founded': _founded.text,
      'our_slogan': _ourSlogan.text,
      'our_vision': _ourVision.text,
      'our_values': _ourValues.text,
      'our_mission': _ourMission.text,
      'our_history': _ourHistory.text,
    };
    FormData formData = FormData.fromMap(params);

    var response = await dio
        .post(InfixApi.updateSchoolBackgroundInfo(), data: params)
        .catchError((e) {
      var msg = e.response.data['message'].toString();
      Utils.showErrorToast(msg);
    });
    if (response.statusCode == 200) {
      var msg = response.data['message'].toString();

      Utils.showToast(msg);
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load');
    }
  }
}
