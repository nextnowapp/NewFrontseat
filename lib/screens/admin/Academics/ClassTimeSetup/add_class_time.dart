import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/config/messages.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/widget/dropdownwidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/grade_list_controller.dart';
import '../../../../controller/subject_list_controller.dart';
import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Classes.dart';
import '../../../../utils/model/Staff.dart';
import '../../../../utils/model/TeacherSubject.dart';
import '../../../../utils/widget/ShimmerListWidget.dart';
import 'ClassTimeModel.dart';
import 'TimeTypeModel.dart';

class AddClassTime extends StatefulWidget {
  final bool? isEdit;
  final ClassTimeData? model;

  AddClassTime({this.isEdit, this.model});

  @override
  _AddClassTimeState createState() => _AddClassTimeState();
}

class _AddClassTimeState extends State<AddClassTime> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final periods = [
    'Break',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  String? _id;
  int? _classTimeId;
  String? _token;
  bool isResponse = false;
  bool? rememberMe = false;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  String? _selectedStartTime;
  String? _selectedEndTime;
  String? _selectedTimeType;

  String? _selectedDay;
  String? _selectedTeacher;
  String? _selectedClass;
  String? _selectedPeriod;
  int? typeId;
  int? teacherId;
  int? classId;
  int? subjectId;
  TextEditingController controller = TextEditingController();
  Future<TimeTypeModel>? model;
  Future<StaffList?>? staff;
  Future<ClassList?>? classes;
  int? sectionId;
  String? _selectedSubject;

  bool isSectionSearch = false;
  late TeacherSubjectList subjectList;
  GradeListController _gradeListController = Get.put(GradeListController());
  SubjectListController _subjectListController =
      Get.put(SubjectListController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  //form key
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectListController.fetchSubjectList();
    _selectedStartTime = '08:00';
    _selectedEndTime = '08:50';
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
    if (widget.isEdit!) {
      print('Flag: isEdit');
      if (widget.model != null) {
        setState(() {
          _selectedPeriod = widget.model!.classPeriodId! == 0
              ? 'Break'
              : widget.model!.classPeriodId.toString();
          if (widget.model!.classPeriodId == 0) {
            rememberMe = true;
          }
          _selectedStartTime = widget.model!.startTime;
          _selectedEndTime = widget.model!.endTime;
          _selectedSubject = widget.model!.subjectName;
          subjectId = widget.model!.subjectId;
          _selectedTeacher = widget.model!.teacherName;
          teacherId = widget.model!.teacherId;
          _selectedClass = widget.model!.className;
          classId = widget.model!.classId;
          _classTimeId = widget.model!.routineId;
          _selectedDay = widget.model!.dayName;
        });
      }
    }
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();

    model = getAllTimeType();
    staff = getAllStaff(int.parse(_id!));
    classes = getAllClass(int.parse(_id!));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: widget.isEdit!
            ? AppMessages.instance!.updateClassTime
            : 'Add Class Time',
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: ListView(scrollDirection: Axis.vertical, children: [
            Column(
              children: [
                DropDownWidget(
                    title: 'Day*',
                    validatorText: 'Select a day',
                    items: days,
                    selectedItem: _selectedDay ?? '',
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDay = newValue;
                      });
                    }),
                SizedBox(
                  height: 12.sp,
                ),
                DropDownWidget(
                  title: 'Period*',
                  validatorText: 'Select a period',
                  items: periods,
                  selectedItem: _selectedPeriod ?? '',
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPeriod = newValue;
                      if (newValue == 'Break') {
                        rememberMe = true;
                      } else {
                        rememberMe = false;
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 12.sp,
                ),
                FutureBuilder<ClassList?>(
                  future: classes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropDownWidget(
                          title: 'Class*',
                          validatorText: 'Select a class',
                          items: snapshot.data!.classes
                              .map((e) => e.name!)
                              .toList(),
                          selectedItem: _selectedClass ?? '',
                          onChanged: (newValue) {
                            setState(() {
                              _selectedClass = newValue;
                              classId = getCode(
                                  _gradeListController.gradeList, newValue);
                              isSectionSearch = true;
                              debugPrint('User select $classId');
                            });
                          });
                    } else {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: ShimmerList(
                          itemCount: 1,
                          height: 56,
                          width: Utils.getWidth(context),
                        ),
                      ));
                    }
                  },
                ),
                Visibility(
                    visible: !rememberMe!,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.sp,
                        ),
                        FutureBuilder<StaffList?>(
                          future: staff,
                          builder: (context, secSnap) {
                            if (secSnap.hasData) {
                              return DropDownWidget(
                                  title: 'Teacher*',
                                  validatorText: 'Select a teacher',
                                  items: secSnap.data!.staffs
                                      .map((e) => e.fullName)
                                      .toList(),
                                  selectedItem: _selectedTeacher ?? '',
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedTeacher = newValue;
                                      print(_selectedTeacher);
                                      teacherId = getCode(
                                          secSnap.data!.staffs, newValue);
                                    });
                                  });
                              print(_selectedTeacher);
                            } else {
                              return Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, right: 4),
                                child: ShimmerList(
                                  itemCount: 1,
                                  height: 56,
                                  width: Utils.getWidth(context),
                                ),
                              ));
                            }
                          },
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        Obx(() => getSubjectNewDropdown(
                            _subjectListController.subjectList)),
                      ],
                    )),
                SizedBox(
                  height: 12.sp,
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
              ],
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedLoadingButton(
              width: 100.w,
              borderRadius: 10,
              color: HexColor('#5374ff'),
              controller: _btnController,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveClassTime();
                } else {
                  _btnController.reset();
                }
              },
              child: Text(
                  widget.isEdit! ? 'Update Class Time' : 'Save Class Time',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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

  Future<StaffList?>? getAllStaff(int staffId) async {
    final response = await http.get(Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(_token!));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  Future<TeacherSubjectList> getAllSubject(int id) async {
    final response = await http.get(Uri.parse(InfixApi.subjectList),
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

  Widget getSubjectNewDropdown(List<TeacherSubject?>? subjectList) {
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject*',
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
            validator: (value) {
              if (value == null) {
                return 'Select a subject';
              }
              return null;
            },
            autoCorrect: true,
            suggestions: subjectList
                .map((e) => SearchFieldListItem(e!.subjectName!, item: e))
                .toList(),
            suggestionState: Suggestion.expand,
            hasOverlay: false,
            searchStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
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
                suffixIcon: const Icon(Icons.search)),
            // initialValue: SearchFieldListItem(subjectList[index]!.subjectName!,
            //     item: subjectList[index]),
            onSuggestionTap: (x) {
              setState(() {
                _selectedSubject = x.item!.subjectName!;
                subjectId = getSubjectId(subjectList, x.item!.subjectName);
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
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
      ),
    );
  }

  Future<void> saveClassTime() async {
    if (widget.isEdit!) {
      if (_selectedPeriod != null &&
          _selectedClass != null &&
          _selectedDay != null &&
          _selectedStartTime != null &&
          _selectedEndTime != null) {
        final parameter = {
          'start_time': _selectedStartTime,
          'id': _classTimeId,
          'period': (() {
            if (rememberMe!) {
              return 'Break';
            } else {
              return _selectedPeriod;
            }
          }()),
          'end_time': _selectedEndTime,
          'class': classId,
          'subjects': subjectId,
          'week': _selectedDay,
          'teachers': teacherId,
          'is_break': (() {
            if (rememberMe!) {
              return 1;
            }
          }()),
        };
        Dio dio = Dio(BaseOptions(
          headers: {'Authorization': _token.toString()},
          contentType: 'application/json',
        ));
        var response = await dio.post(
          InfixApi.classTimeUpdate(),
          data: parameter,
          onSendProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + '%');
            }
          },
        ).catchError((e) {
          _btnController.reset();
          print(e);
          final errorMessage = e.response.data['message'];
          Utils.showToast(errorMessage);
        });
        if (response.statusCode == 200) {
          _btnController.success();
          Utils.showToast('Class Time Saved Successfully!');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (response.statusCode == 404) {
          _btnController.reset();
          Utils.showToast('Failed to Load.!!!');
        } else {
          _btnController.reset();
          throw Exception('Failed to load');
        }
      } else {
        _btnController.reset();
      }
    } else {
      if (_selectedPeriod != null &&
          _selectedClass != null &&
          _selectedDay != null &&
          _selectedStartTime != null &&
          _selectedEndTime != null) {
        final parameter = {
          'start_time': _selectedStartTime,
          'period': (() {
            if (rememberMe!) {
              return 'Break';
            } else {
              return _selectedPeriod;
            }
          }()),
          'end_time': _selectedEndTime,
          'class': classId,
          'subjects': subjectId,
          'week': _selectedDay,
          'teachers': teacherId,
          'is_break': (() {
            if (rememberMe!) {
              return 1;
            }
          }()),
        };

        Dio dio = Dio(BaseOptions(
          headers: {'Authorization': _token.toString()},
          contentType: 'application/json',
        ));
        var response = await dio.post(
          InfixApi.saveClassTime(),
          data: parameter,
          onSendProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + '%');
            }
          },
        ).catchError((e) {
          print(e);
          final errorMessage = e.response.data['message'];
          Utils.showErrorToast(errorMessage.toString());

          setState(() {
            isResponse = false;
          });
        });
        print(parameter.values);
        if (response.statusCode == 200) {
          var message = response.data['message'];
          Utils.showToast(message);
          Navigator.pop(context);
        }
      } else {
        _btnController.reset();
      }
    }
  }

  int? getCode<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if ((cls.name == title)) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<TimeTypeModel> getAllTimeType() async {
    final response = await http.get(Uri.parse(InfixApi.getClassTimeType()),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TimeTypeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
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
}

String time24To12(String? time24) {
  if (time24 == null) {
    return '';
  }
  List<String> timeSplit = time24.split(':');
  String hour = timeSplit[0];
  String min = timeSplit[1];
  String ampm = '';
  int hourInt = int.parse(hour);
  // if (ampm == '0') {
  //   ampm = 'AM';
  // } else {
  //   ampm = 'PM';
  // }
  if (hourInt == 0) {
    hourInt = 12;
    ampm = 'AM';
  } else if (hourInt >= 12) {
    if (hourInt > 12) {
      hourInt = hourInt - 12;
    }
    ampm = 'PM';
  } else {
    ampm = 'AM';
  }
  String hourStr = hourInt.toString();
  if (hourStr.length == 1) {
    hourStr = '0' + hourStr;
  }
  return hourStr + ':' + min + ' ' + ampm;
}

//functon to convert 12 hour to 24 hour (hh:mm a)
String time12To24(String? time12) {
  if (time12 == null) {
    return '';
  }
  List<String> timeSplit = time12.split(':');
  String hour = timeSplit[0];
  String min = timeSplit[1].substring(0, 2);
  String ampm = timeSplit[1].substring(3, 5);
  int hourInt = int.parse(hour);
  if (ampm == 'PM') {
    if (hourInt != 12) {
      hourInt = hourInt + 12;
    }
  } else {
    if (hourInt == 12) {
      hourInt = 0;
    }
  }
  String hourStr = hourInt.toString();
  if (hourStr.length == 1) {
    hourStr = '0' + hourStr;
  }
  return hourStr + ':' + min;
}
