import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/addn_deleteButton.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/grade_list_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/model/Student.dart';
import '../../../utils/widget/date_selector_textfield.dart';
import '../../../utils/widget/dropdownwidget.dart';

class AddRemarksScreen extends StatefulWidget {
  final bool isEdit;
  final dynamic data;
  const AddRemarksScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<AddRemarksScreen> createState() => _AddRemarksScreenState();
}

class _AddRemarksScreenState extends State<AddRemarksScreen> {
  GradeListController _gradeListController = Get.put(GradeListController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  var _formKey = GlobalKey<FormState>();
  String? _selectedClass;
  int? classId;

  bool merit = true;
  String? _token;

  StudentList? students;
  List<String>? selectedStudents;
  String? _selectedStudentId;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    if (widget.isEdit) {
      remarkController.text = widget.data['remarks'];
      dateController.text = widget.data['remark_date'];
      merit = widget.data['merits_type'] == '1' ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: widget.isEdit ? 'Edit Merit/Demerit' : 'Add Merit/Demerit',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Visibility(
                  visible: !(widget.isEdit),
                  child: DropDownWidget(
                      title: 'Select Class',
                      validatorText: 'Select a class',
                      items: _gradeListController.gradeList
                          .map((e) => e.name!)
                          .toList(),
                      selectedItem: _selectedClass ?? '',
                      onChanged: (newValue) async {
                        setState(() {
                          _selectedClass = newValue;
                          classId =
                              getCode(_gradeListController.gradeList, newValue);
                          debugPrint('User select $classId');
                        });
                        var url = InfixApi.getStudentByClassAndSection(classId);
                        final response = await http.get(Uri.parse(url),
                            headers: Utils.setHeader(_token.toString()));
                        print(response.body);
                        if (response.statusCode == 200) {
                          var jsonData = jsonDecode(response.body);
                          setState(() {
                            students = StudentList.fromJson(
                                jsonData['data']['students']);
                          });
                          setState(() {});
                        } else {
                          throw Exception('Failed to load');
                        }
                      }),
                ),
                Visibility(
                  visible: !(widget.isEdit) && students != null,
                  child: SizedBox(
                    height: 12.sp,
                  ),
                ),
                Visibility(
                  visible: !(widget.isEdit) && students != null,
                  child: getStudentListDropDown(
                      students == null ? [] : students!.students,
                      selectedStudents),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                DateSelectorTextField(
                  controller: dateController,
                  onDateSelected: (date) {
                    dateController.text = date;
                  },
                  locale: _locale,
                  title: 'Date',
                  validatorMessage: 'Please select a date',
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Merit/Demerit',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                merit = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: merit == true
                                    ? HexColor('#3ab28d')
                                    : HexColor('#f2f2f2'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                                //star icon
                                Icon(
                                  Icons.star_rounded,
                                  color: merit
                                      ? Colors.white
                                      : HexColor('#86919c'),
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                //text
                                Text(
                                  'Merit',
                                  style: TextStyle(
                                    color: merit
                                        ? Colors.white
                                        : HexColor('#86919c'),
                                    fontSize: 14.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                    ).fontFamily,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                merit = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: merit == false
                                    ? HexColor('#efa643')
                                    : HexColor('#f2f2f2'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                                //exclamation icon
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: !merit
                                      ? Colors.white
                                      : HexColor('#86919c'),
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                //text
                                Text(
                                  'Demerit',
                                  style: TextStyle(
                                    color: !merit
                                        ? Colors.white
                                        : HexColor('#86919c'),
                                    fontSize: 14.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                    ).fontFamily,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.sp,
                ),
                TxtField(
                  hint: 'Remarks*',
                  controller: remarkController,
                  lines: 5,
                  length: 120,
                  action: TextInputAction.newline,
                  validator: (value) {
                    if (value == '') {
                      return 'This field is required';
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: AddnDeleteButton(
                borderColor: '#3ab28d',
                textColor: '#3ab28d',
                title: 'Discard',
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),

          //Discard button
          Expanded(
            child: RoundedLoadingButton(
              color: HexColor('#3ab28d'),
              child: Text(widget.isEdit ? 'Save Changes' : 'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                    ).fontFamily,
                  )),
              controller: _btnController,
              onPressed: () {
                if (widget.isEdit) {
                  if (_formKey.currentState!.validate()) {
                    addRemark();
                    Timer(const Duration(seconds: 1), () {
                      _btnController.success();
                    });
                    Utils.showProcessingToast();
                  }
                } else {
                  if (_formKey.currentState!.validate() &&
                      classId != null &&
                      _selectedStudentId != null) {
                    addRemark();
                    Timer(const Duration(seconds: 1), () {
                      _btnController.success();
                    });
                    Utils.showProcessingToast();
                  }
                }
              },
              resetAfterDuration: true,
              resetDuration: const Duration(seconds: 2),
              successColor: HexColor('#6f9eff'),
            ),
          )
        ]),
      ),
    );
  }

  addRemark() async {
    final body = {
      'merits_type': merit == true ? '1' : '2',
      'merit_date': dateController.text,
      'staff_id': _userDetailsController.id,
      'student_id': _selectedStudentId,
      'class_id': classId,
      'remarks': remarkController.text
    };

    final updateBody = {
      'id': widget.isEdit ? widget.data['id'] : null,
      'merits_type': merit == true ? '1' : '2',
      'merit_date': dateController.text,
      'remarks': remarkController.text
    };
    print(body.values);
    final response = await http.post(
        Uri.parse(widget.isEdit ? InfixApi.updateMerit() : InfixApi.addMerit()),
        body: jsonEncode(widget.isEdit ? updateBody : body),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    var msg = jsonDecode(response.body)['message'];
    if (response.statusCode == 200) {
      Utils.showToast(msg);
      Navigator.pop(context);
    } else {
      Utils.showToast(msg);
      throw Exception('Failed to load');
    }
  }

  Widget getStudentListDropDown(
      List<Student>? students, List<String>? selectedSubject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learner Name',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>.multiSelection(
          dropdownButtonProps: const DropdownButtonProps(
            icon: Icon(
              Icons.arrow_drop_down,
            ),
            iconSize: 40,
          ),
          autoValidateMode: AutovalidateMode.onUserInteraction,
          items: students!.map((e) => e.name).toList(),
          enabled: true,

          filterFn: (item, filter) {
            return item.toLowerCase().contains(filter.toLowerCase());
          },
          popupProps: PopupPropsMultiSelection.menu(
            containerBuilder: (context, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 50.h,
                child: child,
                decoration: BoxDecoration(
                  color: HexColor('#dce1eb'),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              );
            },
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#d5dce0'),
                  ),
                ),
              ),
            ),
          ),
          dropdownBuilder: (context, selectedItem) {
            return Wrap(
              children: selectedItem
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: HexColor('#5374ff'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },

          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            dropdownSearchDecoration: InputDecoration(
              focusColor: HexColor('#5374ff'),
              isCollapsed: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 6.sp,
                vertical: 6.sp,
              ),
              constraints: BoxConstraints(
                maxHeight: 30.h,
                maxWidth: 100.w,
                minWidth: 90.w,
              ),
              fillColor: Colors.white,
              filled: true,
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
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
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
            ),
          ),
          // selectedItems: items,
          onChanged: (newValue) {
            log(newValue.toString());
            setState(() {
              //find the id of all selected items and store it in a string with comma separated
              _selectedStudentId = newValue
                  .map((e) =>
                      students.firstWhere((element) => element.name == e).sId)
                  .join(',');
            });
          },
          onSaved: (newValue) {
            setState(() {
              //find the id of all selected items and store it in a string with comma separated
              _selectedStudentId = newValue!
                  .map((e) =>
                      students.firstWhere((element) => element.name == e).sId)
                  .join(',');
            });
          },
        ),
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
}
