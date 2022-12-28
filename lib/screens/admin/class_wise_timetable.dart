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
import 'package:nextschool/screens/admin/class_wise_timetable_screen.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/dropdownwidget.dart';

// ignore: must_be_immutable
class ClassWiseTimeTable extends StatefulWidget {
  ClassWiseTimeTable({Key? key}) : super(key: key);

  @override
  _ClassWiseTimeTableState createState() => _ClassWiseTimeTableState();
}

class _ClassWiseTimeTableState extends State<ClassWiseTimeTable> {
  String? _id;
  int? sectionId;
  String? _selectedClass;
  int? classId;
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

  _ClassWiseTimeTableState();

  @override
  void initState() {
    // TODO: implement initState
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(title: 'Class Time Table'),
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
                          height: 12.sp,
                        ),
                        Utils.sizedBoxHeight(12),
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
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClassWiseTimeTableScreen(
                                            classId: classId,
                                            id: _id,
                                            className: _selectedClass!,
                                          )));
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
