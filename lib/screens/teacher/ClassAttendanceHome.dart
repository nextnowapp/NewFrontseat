// Dart imports:

// Flutter imports:
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:sizer/sizer.dart';

import 'attendance/AttendanceStudentList.dart';

class StudentAttendanceHome extends StatefulWidget {
  @override
  _StudentAttendanceHomeState createState() => _StudentAttendanceHomeState();
}

class _StudentAttendanceHomeState extends State<StudentAttendanceHome> {
  int? classId;
  int? sectionId;
  String? _selectedClass;
  late DateTime date;
  String? day, year, month;
  String? url;
  String? _selectedDate;
  DateTime? _dateTime;
  String? maxDateTime;
  String minDateTime = '2019-01-01';
  String? _format;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  TextEditingController nameController = TextEditingController();
  GradeListController _gradeListController = Get.put(GradeListController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  var _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    date = DateTime.now();
    maxDateTime = DateTime.now().toLocal().toString();
    setState(() {
      year = '${date.year}';
      month = getAbsoluteDate(date.month);
      day = getAbsoluteDate(date.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Take Attendance',
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: ListView(
            children: <Widget>[
              Obx(() => getClassNewDropdown(_gradeListController.gradeList)),
              SizedBox(
                height: 1.5.h,
              ),
              InkWell(
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
                              : 'Attendance Date: ' + _selectedDate!,
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
                      ),
                      // Icon(
                      //   Icons.calendar_today,
                      //   color: Theme.of(context)
                      //       .textTheme
                      //       .titleMedium!
                      //       .color,
                      //   size: 20.0,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 50),
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
            onTap: () {
              var passedDate =
                  _selectedDate == null ? '$day/$month/$year' : _selectedDate;
              String name = nameController.text;
              if (name.isNotEmpty) {
                url = InfixApi.attendanceChcekName(passedDate, name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentListAttendance(
                      classCode: classId,
                      url: url,
                      date: passedDate,
                      token: _userDetailsController.token,
                    ),
                  ),
                );
              } else {
                url = InfixApi.attendanceCheck(passedDate, classId);
              }

              // _formKey.currentState!.save();

              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentListAttendance(
                      classCode: classId,
                      url: url,
                      date: passedDate,
                      token: _userDetailsController.token,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class*',
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
          validator: (value) {
            if (value == null) {
              return 'Please select a class';
            }
            return null;
          },
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
            ),
          ),
          onChanged: (dynamic newValue) async {
            setState(() {
              var errorMsg = '';
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedClass,
        ),
      ],
    );
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
                  // foregroundColor: const Color(0xFF4E88FF), // button text color
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
}
