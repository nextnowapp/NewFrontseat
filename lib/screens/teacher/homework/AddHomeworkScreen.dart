// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/subject_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/submit_button.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/widget/addn_deleteButton.dart';

class AddHomeworkScrren extends StatefulWidget {
  @override
  _AddHomeworkScrrenState createState() => _AddHomeworkScrrenState();
}

class _AddHomeworkScrrenState extends State<AddHomeworkScrren> {
  String? _id;
  int? classId;
  int? subjectId;
  String? _selectedClass;
  String? _selectedSubject;
  TextEditingController markController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController assignDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  GradeListController _gradeListController = Get.put(GradeListController());
  SubjectListController _subjectListController =
      Get.put(SubjectListController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late TeacherSubjectList subjectList;
  String initDateTime = '2019-05-17';
  RegExp exp = RegExp('\/((?:.(?!\/))+\$)');
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File? _file;
  bool isResponse = false;
  late Response response;
  Dio dio = new Dio();
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _errorMessage;

  var _formKey = GlobalKey<FormState>();

  late SimulatedSubmitController _simulatedSubmitController;

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    assignDateController.text = parseDate(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Add Homework',
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(12.sp),
          child: getContent(context),
        ),
      ),
    );
  }

  Widget getContent(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Obx(() => getClassNewDropdown(_gradeListController.gradeList)),
          SizedBox(
            height: 1.5.h,
          ),
          Obx(() => getSubjectNewDropdown(_subjectListController.subjectList)),
          SizedBox(
            height: 1.5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      TxtField(
                        hint: 'Assign Date*',
                        controller: assignDateController,
                        readonly: true,
                        icon: SvgPicture.asset(
                          'assets/images/calendar-2852107 (1).svg',
                          width: 3,
                          height: 3,
                          fit: BoxFit.scaleDown,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  )),
              SizedBox(
                width: 2.w,
              ),
              Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateSelectorTextField(
                        controller: dueDateController,
                        minDate: DateTime.now(),
                        onDateSelected: (date) {
                          dueDateController.text = date;
                        },
                        locale: _locale,
                        title: 'Due Date*',
                        validatorMessage: 'Please select due date',
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Document (Optional)',
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
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor('#d5dce0'),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    pickDocument();
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _file == null
                                ? 'Select File (Image Or PDF files only!)'
                                : exp.firstMatch(_file!.path)!.group(1)!,
                            style: TextStyle(
                              color: _file == null
                                  ? HexColor('#8e9aa6')
                                  : Colors.blueAccent,
                              fontSize: 10.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: _file == null
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ).fontFamily,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Visibility(
                          visible: _file != null,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _file = null;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ))),
                      Container(
                        height: 58,
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xFF222744),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Center(
                          child: Text(
                            'Browse',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ).fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          TxtField(
            hint: 'Description*',
            lines: 8,
            action: TextInputAction.newline,
            controller: descriptionController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AddnDeleteButton(
                  borderColor: '#4e88ff',
                  textColor: '#4e88ff',
                  title: 'Cancel',
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 40.w,
                child: RoundedLoadingButton(
                  width: 40.w,
                  height: 50,
                  controller: _btnController,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadHomework();
                    } else {
                      _btnController.reset();
                    }
                  },
                  child: Text('Add',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Class*',
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
          // mode: Mode.MENU,
          // showSelectedItems: true,
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
          autoValidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
              log('classId $classId');
            });
          },
          validator: (dynamic value) {
            if (value == null) {
              return 'Please select a class';
            }
            return null;
          },
          //for show the contents
          // selectedItem: _selectedClass),
        ),
        // SizedBox(
        //   height: 27,
        // )
      ],
    );
  }

  Widget noSubjectAvailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 48,
        decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Text('No Subject assigned to teacher!',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
      ),
    );
  }

  Widget getSubjectNewDropdown(List<TeacherSubject?>? subjectList) {
    if (subjectList!.length == 0) {
      return noSubjectAvailable();
    } else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type Subject Name*',
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
          SearchField<TeacherSubject>(
            autoCorrect: true,
            suggestions: subjectList
                .map((e) => SearchFieldListItem(e!.subjectName!, item: e))
                .toList(),
            suggestionState: Suggestion.expand,
            textInputAction: TextInputAction.search,
            //hasOverlay: false,
            searchStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            validator: (x) {
              if (x == null ||
                  x.isEmpty ||
                  !subjectList.map((e) => e!.subjectName!).contains(x)) {
                return 'Please select a subject';
              }
              return null;
            },
            inputType: TextInputType.text,
            searchInputDecoration: InputDecoration(
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
                suffixIcon: const Icon(Icons.search)),
            onSuggestionTap: (x) {
              setState(() {
                _selectedSubject = x.item!.subjectName!;
                subjectId = x.item!.subjectId!;
                // subjectId = getSubjectId(subjectList, x.item!.subjectName);
                debugPrint('User select $subjectId');
              });
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            maxSuggestionsInViewPort: 6,
            itemHeight: 50,
          ),
        ],
      );
  }

  void uploadHomework() async {
    FormData formData = FormData.fromMap({
      'class': '$classId',
      'subject': '$subjectId',
      'assign_date': parseDate(DateTime.now()),
      'submission_date': dueDateController.text,
      'description': descriptionController.text,
      'teacher_id': _id,
      'homework_file':
          _file != null ? await MultipartFile.fromFile(_file!.path) : '',
    });
    try {
      response = await dio.post(
        InfixApi.uploadHomework,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': _token.toString(),
          },
        ),
        onSendProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
      );
      if (response.statusCode == 200) {
        _btnController.success();
        sentNotificationToSection(classId, 0);
        Utils.showToast('Homework added Successfully!');
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      var errorMessage = e.response!.data['message'];
      Utils.showErrorToast(errorMessage);
      _btnController.reset();
    }
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

  Future<ClassList> getAllClass(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById()),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      return ClassList.fromJson(jsonData['data']['classes']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int? getSubjectId<T>(T t, String? subject) {
    int? code;
    for (var s in t as Iterable) {
      if (s.subjectName == subject) {
        code = s.subjectcode;
      }
    }
    print('CODE: $code');
    return code;
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  void sentNotificationToSection(int? classCode, int? sectionCode) async {
    final response = await http.get(Uri.parse(
        InfixApi.sentNotificationToSection(
            'Homework',
            'Dear Student, A new Homework is available in your account.',
            '$classCode')));
    if (response.statusCode == 200) {}
  }

  Widget getDate(
      String text, TextEditingController controller, String validateMsg) {
    return DateSelectorTextField(
      controller: controller,
      dateFormat: 'dd/MM/yyyy',
      minDate: DateTime.now(),
      maxDate: DateTime.now(),
      onDateSelected: (date) {
        controller.text = date;
      },
      locale: _locale,
      title: text,
      validatorMessage: validateMsg,
    );
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }
}
