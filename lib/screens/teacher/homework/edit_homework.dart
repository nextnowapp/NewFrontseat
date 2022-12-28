// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/subject_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/submit_button.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/widget/addn_deleteButton.dart';

class EditHomeWork extends StatefulWidget {
  Homework? homework;

  // DateTime? assignedDate;
  // DateTime? dueDate;
  EditHomeWork({
    Key? key,
    this.homework,
    // this.assignedDate,this.dueDate
  }) : super(key: key);

  @override
  State<EditHomeWork> createState() => _EditHomeWorkState();
}

class _EditHomeWorkState extends State<EditHomeWork> {
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
  Future<ClassList>? classes;
  Future<TeacherSubjectList>? subjects;
  late TeacherSubjectList subjectList;
  String initDateTime = '17-05-2019';
  RegExp exp = RegExp('\/((?:.(?!\/))+\$)');
  DateTimePickerLocale _locale = DateTimePickerLocale.de;
  File? _file;
  bool isResponse = false;
  late Response response;
  Dio dio = new Dio();
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _errorMessage;
  String? _successMessage;

  var _formKey = GlobalKey<FormState>();

  late SimulatedSubmitController _simulatedSubmitController;

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    _selectedSubject = widget.homework?.subjectName!;
    subjectId = widget.homework?.subjectId;
    subjects = getAllSubject(int.parse(_id!));
    subjects!.then((subVal) {
      setState(() {
        subjectList = subVal;
        if (subjectList.subjects.length != 0) {
          print(subjectList.subjects.length);
        }
      });
    });
    classId = widget.homework!.classId;
    _selectedClass = widget.homework?.className!;
    assignDateController.text = widget.homework!.homeworkDate!;
    //     .format(DateTime.parse(widget.homework!.homeworkDate!));
    dueDateController.text = widget.homework!.submissionDate!;
    //     .format(DateTime.parse(widget.homework!.submissionDate!));
    descriptionController.text = widget.homework!.description!;
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
          title: 'Edit Homework',
        ),
        backgroundColor: Colors.white,
        body: Container(child: getContent(context)),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
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
                  child: Text('Update',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              ),
            ],
          ),
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
          Obx(() => getSubjectNewDropdown(_subjectListController.subjectList)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Flexible(
                    flex: 1,
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
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateSelectorTextField(
                        controller: dueDateController,
                        // initialDate: widget.dueDate,
                        dateFormat: 'dd/MM/yyyy',
                        onDateSelected: (date) {
                          dueDateController.text = date;
                        },
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 30)),
                        locale: _locale,
                        title: 'Due Date*',
                        validatorMessage: 'Please select due date',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                const SizedBox(
                  height: 8,
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
                                color: HexColor('#8e9aa6'),
                                fontSize: 10.sp,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ).fontFamily,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TxtField(
              hint: 'Description',
              controller: descriptionController,
              lines: 5,
              action: TextInputAction.newline,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Class',
            style: TextStyle(
              color: HexColor('#8e9aa6'),
              fontSize: 12.sp,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          DropdownSearch<String>(
            // mode: Mode.MENU,
            // showSelectedItems: true,
            items: classes.map((e) => e.name!).toList(),
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              constraints: BoxConstraints(
                maxHeight:
                    (classes.length * 60) < 200 ? (classes.length * 60) : 200,
              ),
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
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
                debugPrint('User select $classId');
              });
            },
            validator: (dynamic value) {
              if (value == null) {
                return 'Please select a class';
              }
              return null;
            },
            //for show the contents
            selectedItem: _selectedClass,
          ),
          // SizedBox(
          //   height: 27,
          // )
        ],
      ),
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
        child: const Center(
            child: Text('No Subject assigned to teacher!',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
      ),
    );
  }

  Widget getSubjectNewDropdown(List<TeacherSubject?>? subjectList) {
    //find index of _selectedSubject in subjectList
    int index = 0;
    if (_selectedSubject != null) {
      for (int i = 0; i < subjectList!.length; i++) {
        if (subjectList[i]!.subjectName == _selectedSubject) {
          index = i;
          break;
        }
      }
    }

    if (subjectList!.length == 0) {
      return noSubjectAvailable();
    } else
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Subject',
              style: TextStyle(
                color: HexColor('#8e9aa6'),
                fontSize: 12.sp,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SearchField<TeacherSubject>(
              autoCorrect: true,
              suggestions: subjectList
                  .map((e) => SearchFieldListItem(e!.subjectName!, item: e))
                  .toList(),
              //add initial value
              initialValue: SearchFieldListItem(
                  subjectList[index]!.subjectName!,
                  item: subjectList[index]),

              suggestionState: Suggestion.expand,
              hint: widget.homework!.subjectName == null
                  ? 'Type Subject Name'
                  : _selectedSubject,
              hasOverlay: false,
              searchStyle: TextStyle(fontSize: 16, color: HexColor('#8395ae')),
              validator: (x) {
                if (x == null ||
                    x.isEmpty ||
                    !subjectList.map((e) => e!.subjectName!).contains(x)) {
                  return 'Please select a subject';
                }
                return null;
              },
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
              ),
              onSuggestionTap: (x) {
                setState(() {
                  _selectedSubject = x.item!.subjectName!;
                  subjectId = getSubjectId(subjectList, x.item!.subjectName);
                  debugPrint('User select $subjectId');
                });
              },
              maxSuggestionsInViewPort: 6,
              itemHeight: 50,
            ),
          ],
        ),
      );
  }

  Future<void> onPressed() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _simulatedSubmitController.submitStatus = SubmitStatus.disabled;
      });
      uploadHomework();
    }
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

  Future<SectionListModel> getAllSection(int id, int? classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SectionListModel.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<TeacherSubjectList> getAllSubject(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getTeacherSubject(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TeacherSubjectList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int? getSubjectId<T>(T t, String? subject) {
    int? code;
    for (var s in t as Iterable) {
      if (s.subjectName == subject) {
        code = s.subjectId;
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

  void uploadHomework() async {
    FormData formData = FormData.fromMap({
      'id': widget.homework!.id,
      'class': '$classId',
      'subject': '$subjectId',
      'assign_date': assignDateController.text,
      'submission_date': dueDateController.text,
      'description': descriptionController.text,
      'user_id': _id,
      'homework_file':
          _file != null ? await MultipartFile.fromFile(_file!.path) : '',
    });

    try {
      response = await dio.post(
        InfixApi.updateHomework,
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
      print(response.statusCode);
      if (response.statusCode == 200) {
        _btnController.success();
        Utils.showToast(
          'Homework updated Successful',
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      print(e);
      final errorMessage = e.response!.data['message'];
      Utils.showToast(e.toString());
      _btnController.reset();
      setState(() {
        _errorMessage = errorMessage;
        _simulatedSubmitController.submitStatus = SubmitStatus.error;
      });
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
}
