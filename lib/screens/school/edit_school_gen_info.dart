import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/ClassTimeSetup/add_class_time.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/school_gen_info_model.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditSchoolGeneralInformationScreen extends StatefulWidget {
  final SchoolGenInfo schoolGenInfo;
  const EditSchoolGeneralInformationScreen(
      {Key? key, required this.schoolGenInfo})
      : super(key: key);

  @override
  State<EditSchoolGeneralInformationScreen> createState() =>
      _EditSchoolGeneralInformationScreenState();
}

class _EditSchoolGeneralInformationScreenState
    extends State<EditSchoolGeneralInformationScreen> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  String? _selectedStartTime;
  String? _selectedEndTime;

  //userdetailsController injection
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  //form key
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolNameController;
  late TextEditingController _schoolAddress;
  late TextEditingController _schoolEMIs;
  late TextEditingController _schoolContactNumber;
  late TextEditingController _schoolEmail;
  late TextEditingController _schoolDistrict;

  // add focus node
  FocusNode _schoolNameFocusNode = FocusNode();
  FocusNode _schoolAddressFocusNode = FocusNode();
  FocusNode _schoolEMIsFocusNode = FocusNode();
  FocusNode _schoolContactNumberFocusNode = FocusNode();
  FocusNode _schoolEmailFocusNode = FocusNode();
  FocusNode _schoolDistrictFocusNode = FocusNode();

  //init state
  @override
  void initState() {
    super.initState();
    _selectedStartTime = '08:00';
    _selectedEndTime = '12:00';
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();

    //intialize all controllers
    _schoolNameController =
        TextEditingController(text: this.widget.schoolGenInfo.schoolName);
    _schoolAddress =
        TextEditingController(text: this.widget.schoolGenInfo.schoolAddress);
    _schoolEMIs =
        TextEditingController(text: this.widget.schoolGenInfo.schoolEmis);
    _schoolContactNumber =
        TextEditingController(text: this.widget.schoolGenInfo.phone);
    _schoolEmail = TextEditingController(text: this.widget.schoolGenInfo.email);
    _schoolDistrict =
        TextEditingController(text: this.widget.schoolGenInfo.districtName);
    _selectedStartTime = this.widget.schoolGenInfo.schoolOfficeStatTime;
    _selectedEndTime = this.widget.schoolGenInfo.schoolOfficeEndTime;
  }

  //dispose
  @override
  void dispose() {
    _schoolNameController.dispose();
    _schoolAddress.dispose();
    _schoolEMIs.dispose();
    _schoolContactNumber.dispose();
    _schoolEmail.dispose();
    _schoolDistrict.dispose();

    // dispose focus node
    _schoolNameFocusNode.dispose();
    _schoolAddressFocusNode.dispose();
    _schoolEMIsFocusNode.dispose();
    _schoolContactNumberFocusNode.dispose();
    _schoolEmailFocusNode.dispose();
    _schoolDistrictFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Edit General Information',
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
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Time*',
                          style: TextStyle(
                            color: HexColor('#8e9aa6'),
                            fontSize: 10.sp,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          height: 58,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor('#d5dce0'),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              _selectStartTime(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _selectedStartTime == null
                                          ? ''
                                          : time24To12(_selectedStartTime!),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    color: HexColor('#8294ae'),
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Time*',
                          style: TextStyle(
                            color: HexColor('#8e9aa6'),
                            fontSize: 10.sp,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          height: 58,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor('#d5dce0'),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              _selectEndTime(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _selectedEndTime == null
                                          ? ''
                                          : time24To12(_selectedEndTime),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    color: HexColor('#8294ae'),
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    'assets/images/EMIS.svg',
                  ),
                ),
                focusNode: _schoolEMIsFocusNode,
                hint: 'School EMIS',
                controller: _schoolEMIs,
                lines: 1,
                type: TextInputType.number,
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school EMIs';
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
                    'assets/images/School Address.svg',
                  ),
                ),
                focusNode: _schoolAddressFocusNode,
                hint: 'School Address',
                controller: _schoolAddress,
                lines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school address';
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
                    'assets/images/Phone no..svg',
                  ),
                ),
                focusNode: _schoolContactNumberFocusNode,
                hint: 'School Phone Number',
                controller: _schoolContactNumber,
                type: TextInputType.number,
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                length: 10,
                lines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter school contact number';
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
                    'assets/images/E-mail Address.svg',
                  ),
                ),
                focusNode: _schoolEmailFocusNode,
                hint: 'School E-mail',
                controller: _schoolEmail,
                lines: 1,
                validator: (value) {
                  if (value!.isEmpty && !value.contains('@')) {
                    return 'Please enter valid school email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              // TxtField(
              //   labelIcon: Container(
              //     height: 20,
              //     width: 20,
              //     child: SvgPicture.asset(
              //       'assets/images/District Info.svg',
              //     ),
              //   ),
              //   focusNode: _schoolDistrictFocusNode,
              //   hint: 'District Information',
              //   controller: _schoolDistrict,
              //   lines: 1,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter school district';
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(
              //   height: 1.h,
              // ),
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
                await updateSchoolGenInfo();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: startTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF222744), // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Color(0xFF4E88FF), // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    // foregroundColor: const Color(0xFF4E88FF), // button text color
                    ),
              ),
            ),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != startTime)
      setState(() {
        startTime = pickedS;
        _selectedStartTime = pickedS.format(context);
        _selectedStartTime = time12To24(_selectedStartTime!);
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF222744), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Color(0xFF4E88FF), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedS != null && pickedS != endTime)
      setState(() {
        endTime = pickedS;
        _selectedEndTime = pickedS.format(context);
        _selectedEndTime = time12To24(_selectedEndTime!);
      });
  }

  Future<void> updateSchoolGenInfo() async {
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
      'school_address': _schoolAddress.text,
      'phone': _schoolContactNumber.text,
      'email': _schoolEmail.text,
      'school_emis': _schoolEMIs.text,
      'district_name': _schoolDistrict.text,
      'school_office_stat_time': _selectedStartTime,
      'school_office_end_time': _selectedEndTime,
    };

    FormData formData = FormData.fromMap(params);

    var response = await dio
        .post(InfixApi.updateSchoolGeneralInfo(), data: params)
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
