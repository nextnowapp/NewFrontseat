// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/ClassTimeSetup/class_time_list.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/widget/dropdownwidget.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ClassTimeSearch extends StatefulWidget {
  ClassTimeSearch({Key? key}) : super(key: key);

  @override
  _ClassTimeSearchState createState() => _ClassTimeSearchState();
}

class _ClassTimeSearchState extends State<ClassTimeSearch> {
  String? _id;
  String? _selectedClass;
  int? classId;
  String? _selectedDay;
  int? dayId;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _selectedSection;
  Future<ClassList?>? classes;
  Future<SectionListModel>? sections;

  var formKey = GlobalKey<FormState>();

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  String? url;
  String? status;
  String? _token;
  bool isSectionSearch = false;
  GradeListController _gradeListController = Get.put(GradeListController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    super.initState();
  }

  var daysJson = [
    {
      'id': 3,
      'name': 'Monday',
    },
    {
      'id': 4,
      'name': 'Tuesday',
    },
    {
      'id': 5,
      'name': 'Wednesday',
    },
    {
      'id': 6,
      'name': 'Thursday',
    },
    {
      'id': 7,
      'name': 'Friday',
    },
    {
      'id': 1,
      'name': 'Saturday',
    },
    {
      'id': 2,
      'name': 'Sunday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(title: 'Search Class Time'),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: new GestureDetector(
              onTap: () {
                // call this method here to hide soft keyboard
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: <Widget>[
                        Obx(
                          () => DropDownWidget(
                              title: 'Select Class',
                              validatorText: 'Select a class',
                              items: _gradeListController.gradeList
                                  .map((e) => e.name!)
                                  .toList(),
                              selectedItem: _selectedClass ?? '',
                              onChanged: (newValue) {
                                setState(() {
                                  var errorMsg = '';
                                  _selectedClass = newValue;
                                  classId = getCode(
                                      _gradeListController.gradeList, newValue);
                                });
                              }),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        DropDownWidget(
                            title: 'Select Day',
                            validatorText: 'Select a Day',
                            items: daysJson
                                .map((e) => e['name'] as String)
                                .toList(),
                            selectedItem: _selectedDay ?? '',
                            onChanged: (newValue) {
                              setState(() {
                                var errorMsg = '';
                                _selectedDay = newValue;
                                dayId = getCodeJson(daysJson, newValue);
                              });
                              print(dayId);
                            }),
                        SizedBox(
                          height: 4.h,
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: HexColor('#5374ff'),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ).fontFamily,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (formKey.currentState!.validate() &&
                                classId != null &&
                                dayId != null) {
                              formKey.currentState!.save();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassTimeList(
                                      classId: classId!, dayId: dayId!),
                                ),
                              );
                            } else {
                              Utils.showErrorToast('Please fill all fields');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
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

  int? getCodeJson<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if (cls['name'] == title) {
        code = cls['id'] as int;
        break;
      }
    }
    return code;
  }

  Future<ClassList?>? getAllClass(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById()),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return ClassList.fromJson(jsonData['data']['classes']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
