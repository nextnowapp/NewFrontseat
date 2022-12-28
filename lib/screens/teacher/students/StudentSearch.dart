// Dart imports:

// Flutter imports:
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
// Package imports:
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

import 'StudentListScreen.dart';

// ignore: must_be_immutable
class StudentSearch extends StatefulWidget {
  String? status;
  StudentSearch({this.status});

  @override
  _StudentSearchState createState() => _StudentSearchState(status: status);
}

class _StudentSearchState extends State<StudentSearch> {
  int? classId;
  String? _selectedClass;
  DateTime? date;
  String? day, year, month;
  String _selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime? _dateTime;
  String? maxDateTime;
  String minDateTime = '2019-01-01';
  String? _format;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  TextEditingController nameController = TextEditingController();
  GradeListController _gradeListController = Get.put(GradeListController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  String? url;
  String? status;
  String? _token;
  bool isSectionSearch = false;

  var _formKey = GlobalKey<FormState>();

  _StudentSearchState({this.status});

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: status == 'attendance'
          ? CustomAppBarWidget(title: 'View Attendance')
          : CustomAppBarWidget(title: 'Learner Search'),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: new GestureDetector(
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.all(12.sp),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Obx(() =>
                      getClassNewDropdown(_gradeListController.gradeList)),
                  SizedBox(
                    height: 2.h,
                  ),
                  Visibility(
                    visible: status == 'attendance' ? true : false,
                    child: InkWell(
                      onTap: () {
                        _selectAssignDate(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor('#d5dce0'),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _selectedDate == null
                                    ? 'Attendance Date: $day/$month/$year'
                                    : 'Attendance Date: ' + _selectedDate,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                  ).fontFamily,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/calendar-2852107 (1).svg',
                              color: HexColor('#8395ae'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: HexColor('#8395ae')),
                        child: Text(
                          'OR',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TxtField(
                    hint: 'Search by Name',
                    type: TextInputType.text,
                    controller: nameController,
                  ),

                  // temperory it is hide this portion of the code////
                  Utils.sizedBoxHeight(100),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Material(
                      color: const Color(0xFF222744),
                      borderRadius: BorderRadius.circular(35),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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
                        ),
                        onTap: () {
                          String name = nameController.text;
                          if (name.isNotEmpty && status != 'attendance') {
                            url = InfixApi.getStudentByName(
                              name,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentListScreen(
                                          classCode: classId,
                                          url: url,
                                          status: status,
                                          token: _token,
                                        )));
                          } else if (name.isEmpty && status != 'attendance') {
                            url = InfixApi.getStudentByClass(
                              classId!,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentListScreen(
                                          classCode: classId,
                                          url: url,
                                          status: status,
                                          token: _token,
                                        )));
                          } else {
                            if ((status == 'attendance' || status == null) &&
                                name.isNotEmpty) {
                              print('yes');
                              url = InfixApi.getStudentByNameattendance(name,
                                  date: _selectedDate);
                            } else if ((status == 'attendance' ||
                                    status == 'remark' ||
                                    status == null) &&
                                classId != null) {
                              url = InfixApi.getStudentByClassAndSection(
                                  classId,
                                  date: _selectedDate);
                            } else {
                              return Utils.showToast(
                                  'Please select either Class OR enter name of student.');
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentListScreen(
                                  classCode: classId,
                                  url: url,
                                  status: status,
                                  token: _token,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    //sort the grade from snapshot in order of _list

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search by Class',
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
        DropdownSearch<String>(
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                ),
              );
            },
            items: classes.map((e) => e.name!).toList(),
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isSelected) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.sp, vertical: 10.sp),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                    ),
                    Divider(
                      color: HexColor('#8e9aa6'),
                      thickness: 0.5,
                    )
                  ],
                );
              },
              showSelectedItems: true,
              constraints: BoxConstraints(
                maxHeight:
                    (classes.length * 60) < 200 ? (classes.length * 60) : 200,
              ),
            ),
            clearButtonProps: const ClearButtonProps(
              isVisible: true,
              icon: Icon(Icons.clear),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(
                  fontSize: 8.sp,
                  color: HexColor('#de5151'),
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#d5dce0'),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#5374ff'),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#de5151'),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#de5151'),
                  ),
                ),
                labelStyle: Theme.of(context).textTheme.headline5,
              ),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                _selectedClass = newValue;
                classId = getCode(classes, newValue);
                debugPrint('User select $classId');
              });
            },
            validator: (dynamic value) {
              if (value == null) {
                return 'Please select a grade';
              }
              return null;
            },
            selectedItem: _selectedClass),
      ],
    );
  }

  int? getCode<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<void> _selectAssignDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF222744), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Color(0xFF4E88FF), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4E88FF), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _dateTime != null ? _dateTime! : DateTime.now(),
      firstDate: DateTime.parse(minDateTime),
      lastDate: DateTime.now(),
      confirmText: 'Confirm Date',
      cancelText: 'Back',
      helpText: 'Select Attendance Date',
    );
    if (pickedDate != null && pickedDate != _dateTime) {
      setState(() {
        _dateTime = pickedDate;
        _selectedDate =
            '${getAbsoluteDate(_dateTime!.day)}/${getAbsoluteDate(_dateTime!.month)}/${_dateTime!.year}';
      });
    }
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }
}
