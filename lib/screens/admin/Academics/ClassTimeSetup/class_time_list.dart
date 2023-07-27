import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/widget/customLoader.dart';
import '../../../../utils/widget/delete_bottomsheet.dart';
import 'ClassTimeModel.dart';
import 'add_class_time.dart';

class ClassTimeList extends StatefulWidget {
  final int? classId;
  final int? dayId;
  const ClassTimeList({Key? key, required this.classId, required this.dayId})
      : super(key: key);

  @override
  _ClassTimeListState createState() => _ClassTimeListState();
}

class _ClassTimeListState extends State<ClassTimeList> {
  String? _token;
  Future<ClassTimeModel?>? model;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;

    model = fetchTimeList(widget.classId!, widget.dayId!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Class Time List',
        ),
        body: FutureBuilder<ClassTimeModel?>(
          future: model,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data!.length == 0) {
                return Center(
                    child:
                        Utils.noDataImageWidgetWithText('No Time List Found'));
              } else {
                var data = snapshot.data!.data;
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Utils.sizedBoxHeight(16);
                  },
                  padding: const EdgeInsets.all(10),
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    var data1 = data[index];
                    return Container(
                      height: 180,
                      padding: const EdgeInsets.all(8),
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Day: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    snapshot.data!.data![index].dayName
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Class Period: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    (data1.classPeriodId! == 0)
                                        ? 'Break'
                                        : data1.classPeriodId!.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Class: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    snapshot.data!.data![index].className
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Visibility(
                            visible: data1.classPeriodId! == 0 ? false : true,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Teacher: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      snapshot.data!.data![index].teacherName ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Start Time: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          time24To12(data1.startTime),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Utils.sizedBoxWidth(8),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text(
                                            'End Time: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            time24To12(data1.endTime),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        editNoticePromptDialog(context, data1);
                                      });
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF3F3F3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 14,
                                        // color: Color(0xFFb0b2b8),
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                              Utils.sizedBoxWidth(30),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        deleteNoticePromptDialog(
                                            context, data1.routineId);
                                      });
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF3F3F3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: const Icon(
                                        Icons.delete,
                                        size: 14,
                                        // color: Color(0xFFb0b2b8),
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else
              return const Center(
                child: CustomLoader(),
              );
          },
        ));
  }

  Future<ClassTimeModel?>? fetchTimeList(int classid, int dayid) async {
    final response = await http.get(
        Uri.parse(
            InfixApi.saveClassTime() + '?class_id=$classid&day_id=$dayid'),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      try {
        return ClassTimeModel.fromJson(jsonData);
      } catch (e) {
        print(e);
        // return null;
      }
    } else {
      throw Exception('failed to load');
    }
    return null;
    // return fetchTimeList();
  }

  editNoticePromptDialog(BuildContext context, ClassTimeData list) async {
    Widget cancelButton = TextButton(
      child: Text(
        'No',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontSize: ScreenUtil().setSp(14), color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF4E88FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Center(
        child: Text(
          'Edit',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: ScreenUtil().setSp(14),
                height: 0.6,
                color: Colors.white,
              ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddClassTime(isEdit: true, model: list)));
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xFF222744),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Are you sure, you want to edit the Class Time?',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: yesButton,
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: cancelButton,
              ),
            ],
          )
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deleteNoticePromptDialog(BuildContext context, int? id) async {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            final response = await http.get(
                Uri.parse(InfixApi.deleteClassTime(id.toString())),
                headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
              var jsonData = jsonDecode(response.body);
              Navigator.of(context).pop();
              // Utils.showSnackBar(context, 'Class Time Deleted Successfully',
              //     color: Colors.green);
              Utils.showToast('Class Time Deleted Successfully');
            } else {
              throw Exception('Failed to load');
            }
            Navigator.pop(context);
          },
          title: 'Delete Class Time',
        );
      },
    );
  }
}

//function to take the time in 24 hour format and convert it to 12 hour format
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

//function to take the time in 12 hour format and convert it to 24 hour format

