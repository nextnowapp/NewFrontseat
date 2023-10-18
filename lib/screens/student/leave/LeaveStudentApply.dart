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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/LeaveType.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class LeaveStudentApply extends StatefulWidget {
  String? id;

  LeaveStudentApply(this.id);

  @override
  _LeaveStudentApplyState createState() => _LeaveStudentApplyState();
}

class _LeaveStudentApplyState extends State<LeaveStudentApply> {
  var _id;
  String formatter = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String? applyDate;
  String? fromDate;
  String? toDate;
  String? leaveType;
  int? leaveId;
  TextEditingController reasonController = TextEditingController();
  DateTime? date;
  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  String _format = 'dd/MM/yyyy';
  DateTime? _dateTime;
  DateTime? _dateTimeLast;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File? _file;
  bool isResponse = false;
  late Response response;
  Dio dio = new Dio();
  Future<LeaveList?>? leaves;
  bool leaveAvailable = true;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    _dateTime = DateTime.parse(initDateTime);
    leaves = getAllLeaveType(_id);
    leaves!.then((value) {
      setState(() {
        if (value!.types.length > 0) {
          leaveAvailable = true;
          leaveId = value.types.length != 0 ? value.types[0].id : 0;
          leaveType = value.types.length != 0 ? value.types[0].type : '';
        } else {
          leaveAvailable = false;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    applyDate = formatter;

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'Apply Leave'),
        backgroundColor: Colors.white,
        body: Container(
          child: getContent(context),
        ),
      ),
    );
  }

  Widget getContent(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(12),
        ),
        Expanded(
          child: FutureBuilder<LeaveList?>(
            future: leaves,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    leaveAvailable
                        ? getLeavesDropdown(snapshot.data!.types)
                        : Container(),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(12),
                            vertical: ScreenUtil().setHeight(12)),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  applyDate == null
                                      ? 'Apply Date'
                                      : 'Leave Application Date :   $applyDate',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black12,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _selectLeaveStartDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(12),
                              vertical: ScreenUtil().setHeight(12)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  fromDate == null
                                      ? 'Leave Start Date'
                                      : 'Leave Start Date : $fromDate',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black12,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _selectLeaveEndDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(12),
                              vertical: ScreenUtil().setHeight(12)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  toDate == null
                                      ? 'Leave Return Date'
                                      : 'Leave Return Date : $toDate',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black12,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        pickDocument();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(12),
                              vertical: ScreenUtil().setHeight(12)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    _file == null
                                        ? 'Attach supporting document'
                                        : _file!.path.split('/').last,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Text(
                                'Browse',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.headlineSmall,
                        controller: reasonController,
                        decoration: InputDecoration(
                            hintText: 'Reason',
                            labelText: 'Reason',
                            labelStyle:
                                Theme.of(context).textTheme.headlineSmall,
                            errorStyle: const TextStyle(
                                color: Colors.pinkAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                  ],
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
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: Utils.BtnDecoration,
              child: Text(
                'Apply for Leave',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
          onTap: () {
            String reason = reasonController.text;

            if (reason.isNotEmpty) {
              setState(() {
                isResponse = true;
              });
              uploadLeave();
            } else {
              // Utils.showSnackBar(context, 'Check all the field');
              Utils.showToast('Check all the field');
            }
          },
        ),
        isResponse == true
            ? const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
              )
            : const Text(''),
      ],
    );
  }

  Widget getLeaveTypeDropdown(List<LeaveType> leaves) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButton(
          elevation: 0,
          dropdownColor: Colors.grey,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
            size: 30.0,
          ),
          isExpanded: true,
          underline: Container(
            height: 0,
          ),
          items: leaves.map((item) {
            return DropdownMenuItem<String>(
              value: item.type,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Text(
                  item.type!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            );
          }).toList(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: ScreenUtil().setSp(14)),
          onChanged: (dynamic value) {
            setState(() {
              leaveType = value;
              leaveId = getLeaveId(leaves, value);
              debugPrint('User select $leaveId');
            });
          },
          value: leaveType,
        ),
      ),
    );
  }

  Widget getLeavesDropdown(List<LeaveType> leaves) {
    if (leaves.length == 0) {
      return Utils.noDataTextWidget();
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownSearch<String>(
            // mode: Mode.MENU,
            // showSelectedItems: true,
            items: leaves.map((e) => e.type!).toList(),
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              constraints: BoxConstraints(
                maxHeight:
                    (leaves.length * 60) < 200 ? (leaves.length * 60) : 200,
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: const Text('Select Leave Type*'),
                border: const OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                leaveType = newValue;
                leaveId = getLeaveId(leaves, newValue);
                debugPrint('User select $leaveId');
              });
            },
            validator: (dynamic value) {
              if (value == null) {
                return 'Please select leave type';
              }
              return null;
            },
            selectedItem: leaveType),
      );
    }
  }

  int? getLeaveId<T>(T t, String? type) {
    int? code;
    // for (var s in t as Iterable<_>) {
    //   if (s.type == type) {
    //     code = s.id;
    //   }
    // }
    return code;
  }

  Future<LeaveList?>? getAllLeaveType(id) async {
    final response = await http.get(Uri.parse(InfixApi.allLeaveType()),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('Leave Data $jsonData');
      return LeaveList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  void uploadLeave() async {
    FormData formData = FormData.fromMap({
      'apply_date': '$applyDate',
      'leave_type': '$leaveId',
      'leave_from': '$fromDate',
      'leave_to': toDate,
      'login_id': _id,
      'reason': reasonController.text,
      'attach_file':
          _file != null ? await MultipartFile.fromFile(_file!.path) : '',
    });
    print(InfixApi.userApplyLeaveStore);
    response = await dio.post(
      InfixApi.userApplyLeaveStore,
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          // progress = (received / total * 100).toDouble();
          print((received / total * 100).toStringAsFixed(0) + '%');
          int progress = (((received / total) * 100).toInt());
          if (progress == 100) {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioException(e).toString();
      print(errorMessage);

      Utils.showToast(errorMessage);
      Navigator.of(context).pop();
    });

    if (response.statusCode == 200) {
      Utils.showToast(
          'Leave Request has been created successfully. Please wait for approval');
      Navigator.pop(context);
    } else {
      Utils.showToast(response.statusCode.toString());
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

  Future<void> _selectLeaveStartDate(BuildContext context) async {
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      confirmText: 'Confirm Date',
      cancelText: 'Back',
      helpText: 'Select Leave Starting Date',
    );
    if (pickedDate != _dateTime) {
      setState(() {
        _dateTime = pickedDate;
        _dateTimeLast = null;
        toDate = null;
        fromDate =
            '${getAbsoluteDate(_dateTime!.day)}-${getAbsoluteDate(_dateTime!.month)}-${getAbsoluteDate(_dateTime!.year)}';
      });
    }
  }

  Future<void> _selectLeaveEndDate(BuildContext context) async {
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
      firstDate: _dateTime != null ? _dateTime! : DateTime.now(),
      lastDate: DateTime(2100),
      confirmText: 'Confirm Date',
      cancelText: 'Back',
      helpText: 'Select Last Date of Leave',
    );
    if (pickedDate != _dateTimeLast) {
      setState(() {
        _dateTimeLast = pickedDate;
        toDate =
            '${getAbsoluteDate(_dateTimeLast!.day)}-${getAbsoluteDate(_dateTimeLast!.month)}-${getAbsoluteDate(_dateTimeLast!.year)}';
      });
    }
  }
}
