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
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/widget/date_selector_textfield.dart';

class AddContentScreeen extends StatefulWidget {
  @override
  _AddContentScreeenState createState() => _AddContentScreeenState();
}

class _AddContentScreeenState extends State<AddContentScreeen> {
  String? _id;
  int? subjectId;
  int? classId;
  String? _selectedClass;
  String? _selectedContentType;
  String? _selectedaAssignDate;
  double? _sent;
  double? _total;
  RegExp exp = RegExp('\/((?:.(?!\/))+\$)');
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController assignDateController = TextEditingController();
  Future<ClassList?>? classes;
  Future<TeacherSubjectList?>? subjects;
  TeacherSubjectList? subjectList;
  DateTime? date;
  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  DateTime _dateTime = DateTime.now();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File? _file;
  bool isResponse = false;
  bool isVisible = false;
  late Response response;
  FormData? formData;
  Dio dio = new Dio();
  var contentType = [
    'Assignment',
    'Study material',
    // 'Curriculum',
    'Other download'
  ];
  String radioStr = 'admin';
  int allClasses = 0;
  final key = GlobalKey<State<Tooltip>>();
  DateTimePickerLocale locale = DateTimePickerLocale.en_us;
  String? _token;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  var _formKey = GlobalKey<FormState>();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    setState(() {
      classes = getAllClass(int.parse(_id!));
      classes!.then((value) {
        _selectedClass = value!.classes[0].name;
        classId = value.classes[0].id;
        _selectedContentType = 'Assignment';
      });
    });
  }

  bool? rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Add Content',
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(12.sp),
          child: getContent(context),
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedLoadingButton(
                width: 100.w,
                borderRadius: 10,
                color: HexColor('#5374ff'),
                controller: _btnController,
                onPressed: () {
                  if (_file == null) {
                    _btnController.reset();
                    return Utils.showErrorToast('Please select attachment!');
                  } else {
                    if (_formKey.currentState!.validate()) {
                      uploadContent();
                    } else {
                      _btnController.reset();
                    }
                  }
                },
                child: const Text('Add Content',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<ClassList?>(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      getContentTypeNewDropdown(),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      TxtField(
                        hint: 'Title',
                        controller: titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        capitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              flex: 1,
                              child: Divider(
                                thickness: 1,
                              )),
                          Utils.sizedBoxWidth(8),
                          Text(
                            'Available For',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: HexColor('#8e9aa6'),
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          Utils.sizedBoxWidth(8),
                          const Expanded(
                              flex: 8,
                              child: Divider(
                                thickness: 1,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        //add two cards here for All admin and Student
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: radioStr == 'admin'
                                        ? const Color(0xFF222744)
                                        : Colors.grey,
                                  ),
                                  color: radioStr == 'admin'
                                      ? const Color(0xFF222744)
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'All Staff',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: radioStr != 'student'
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  radioStr = 'admin';
                                  allClasses = 0;
                                  isVisible = false;
                                  if (rememberMe == true) {
                                    rememberMe = false;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: radioStr == 'student'
                                        ? const Color(0xFF222744)
                                        : Colors.grey,
                                  ),
                                  color: radioStr == 'student'
                                      ? const Color(0xFF222744)
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Learner',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: radioStr == 'student'
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  radioStr = 'student';
                                  isVisible = true;
                                });
                                // showAlertDialog(context);
                                // buildModalBottomSheet(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Visibility(
                        visible: isVisible,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 2000),
                          opacity: isVisible ? 1 : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor('#d5dce0'),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CheckboxListTile(
                                  title: Text(
                                    'For all learner',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily,
                                    ),
                                  ),
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value;
                                      if (rememberMe!) {
                                        allClasses = 1;
                                      } else {
                                        allClasses = 0;
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                Visibility(
                                  visible: !rememberMe!,
                                  child: Column(
                                    children: [
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: getClassNewDropdown(
                                                  snapshot.data!.classes)),
                                          Utils.sizedBoxWidth(8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            // color: Color(0x604E88FF),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          children: [
                            Utils.sizedBoxWidth(8),
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF222744),
                              size: 18,
                            ),
                            Utils.sizedBoxWidth(8),
                            Text(
                              ((radioStr == 'admin')
                                  ? 'The Content is selected for All Staff'
                                  : ((allClasses == 1)
                                      ? 'The Content is selected for All Learner'
                                      : 'The Content is selected for Grade $_selectedClass!')),
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: HexColor('#5374ff'),
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ).fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      DateSelectorTextField(
                        controller: assignDateController,
                        locale: locale,
                        title: 'Assign Date',
                        validatorMessage: 'Please select assign date',
                        onDateSelected: (date) {
                          setState(() {
                            assignDateController.text = date;
                            _selectedaAssignDate = date;
                          });
                        },
                      ),
                      SizedBox(
                        height: 1.5.h,
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
                                        : exp
                                            .firstMatch(_file!.path)!
                                            .group(1)!,
                                    style: TextStyle(
                                      color: _file != null
                                          ? Colors.blueAccent
                                          : HexColor('#8e9aa6'),
                                      fontSize: 10.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
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
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
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
                      SizedBox(
                        height: 1.5.h,
                      ),
                      TxtField(
                        hint: 'Desciption',
                        controller: descriptionController,
                        lines: 5,
                        action: TextInputAction.newline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Description';
                          }
                          return null;
                        },
                      ),
                      // TxtField(
                      //   hint: 'Description',
                      //   controller: descriptionController,
                      //   lines: 5,
                      //   action: TextInputAction.newline,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter Desciption';
                      //     }
                      //     return null;
                      //   },
                      // ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CustomLoader(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget getContentTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: const Color(0xFF222744),
            width: 1.0,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: DropdownButton(
          elevation: 10,
          underline: Container(),
          isExpanded: true,
          hint: Text(
            'Select Content Type',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          borderRadius: BorderRadius.circular(5.0),
          items: contentType.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            );
          }).toList(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 15.0),
          onChanged: (dynamic value) {
            setState(() {
              _selectedContentType = value;
              debugPrint('User select $_selectedContentType');
            });
          },
          value: _selectedContentType,
        ),
      ),
    );
  }

  Widget getContentTypeNewDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Type*',
          style: TextStyle(
            color: HexColor('#8e9aa6'),
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        const SizedBox(
          height: 5,
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
            items: contentType,
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
                maxHeight: (contentType.length * 60) < 200
                    ? (contentType.length * 60)
                    : 200,
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
            onChanged: (newValue) {
              setState(() {
                _selectedContentType = newValue;
                debugPrint('User select $_selectedContentType');
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select content type';
              }
              return null;
            },
            selectedItem: 'Assignment'),
      ],
    );
  }

  Future<void> uploadContent() async {
    if (radioStr == 'admin') {
      formData = FormData.fromMap(<String, dynamic>{
        // "all_classes": '$allClasses',
        // "class": '$classId',
        // "section": '$sectionId',
        'upload_date': assignDateController.text.replaceAll('-', '/'),
        'available_for': radioStr,
        'description': descriptionController.text,
        'created_by': '$_id',
        'content_title': titleController.text,
        'content_type': _selectedContentType!.toLowerCase().substring(0, 2),
        'attach_file':
            await MultipartFile.fromFile(_file!.path, filename: _file!.path),
      });
    } else {
      if (allClasses == 1) {
        formData = FormData.fromMap(<String, dynamic>{
          'all_classes': '$allClasses',
          // 'class': '$classId',
          'upload_date': assignDateController.text.replaceAll('-', '/'),
          'available_for': radioStr,
          'description': descriptionController.text,
          'created_by': '$_id',
          'content_title': titleController.text,
          'content_type': _selectedContentType!.toLowerCase().substring(0, 2),
          'attach_file':
              await MultipartFile.fromFile(_file!.path, filename: _file!.path),
        });
      } else {
        formData = FormData.fromMap(<String, dynamic>{
          // 'all_classes': '$allClasses',
          'class': '$classId',
          // "section": '$sectionId',
          'upload_date': assignDateController.text.replaceAll('-', '/'),
          'available_for': radioStr,
          'description': descriptionController.text,
          'created_by': '$_id',
          'content_title': titleController.text,
          'content_type': _selectedContentType!.toLowerCase().substring(0, 2),
          'attach_file':
              await MultipartFile.fromFile(_file!.path, filename: _file!.path),
        });
      }
    }

    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _token.toString()},
      contentType: 'multipart/form-data',
    ));

    response = await dio.post(
      InfixApi.uploadContent,
      data: formData,
      onSendProgress: (received, total) {
        setState(() {
          _sent = received.toDouble();
          _total = total.toDouble();
        });
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
        if (received == total) {}
      },
    ).catchError((e) {
      _btnController.reset();
      final errorMessage = e.response!.data['message'];
      Utils.showErrorToast(errorMessage);
      print(e);
    });
    if (response.statusCode == 200) {
      _btnController.success();
      Utils.showToast('Content Added Successfully');
      print(formData);

      if (radioStr == 'admin') {
        sentNotificationTo(1);
      } else {
        if (allClasses == 1) {
          sentNotificationTo(2);
        } else {
          sentNotificationToSection(classId, 0);
        }
      }
      Navigator.pop(context);
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
            'Content', 'New content request has come', '$classCode')));
    if (response.statusCode == 200) {}
  }

  void sentNotificationTo(int role) async {
    final response = await http.get(Uri.parse(InfixApi.sentNotificationForAll(
        role, 'Content', 'New content request has come')));
    if (response.statusCode == 200) {}
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
      ),
    );
  }
}
