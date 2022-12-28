// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/TeacherMyRoutine.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';

import '../Utils.dart';
import 'RoutineRowWidget.dart';

// ignore: must_be_immutable
class TeacherRoutineRow extends StatefulWidget {
  String? title;

  TeacherRoutineRow({this.title});

  @override
  _ClassRoutineState createState() => _ClassRoutineState(title);
}

class _ClassRoutineState extends State<TeacherRoutineRow> {
  String? title;
  Future<TeacherMyRoutineList>? routine;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  _ClassRoutineState(this.title);

  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _token = _userDetailsController.token;

    routine = fetchRoutine(_userDetailsController.id, title);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
      child: FutureBuilder<TeacherMyRoutineList>(
        future: routine,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.schedules.length > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(title!,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: ScreenUtil().setSp(15))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text('Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Subject',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Room',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: snapshot.data!.schedules.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RoutineRowDesign(
                          AppFunction.getAmPm(
                                  snapshot.data!.schedules[0].startTime!) +
                              '\nto\n' +
                              AppFunction.getAmPm(
                                  snapshot.data!.schedules[0].endTime!),
                          snapshot.data!.schedules[index].subject,
                          room: snapshot.data!.schedules[index].room);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 0.5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF415094),
                      ),
                    ),
                  )
                ],
              );

              //Text(AppFunction.getAmPm(snapshot.data.schedules[0].startTime)+' - '+AppFunction.getAmPm(snapshot.data.schedules[0].endTime));
            } else {
              // return Container();
              return Card(
                  child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(child: Text('No Data Found For ' + title!)),
              ));
            }
          } else {
            return ShimmerList(
              height: 100,
              itemCount: 1,
            );
          }
        },
      ),
    );
  }

  Future<TeacherMyRoutineList> fetchRoutine(int id, String? title) async {
    // print(InfixApi.getTeacherMyRoutine(id));
    final response = await http.get(Uri.parse(InfixApi.getTeacherMyRoutine(id)),
        headers: Utils.setHeader(_token.toString()));
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return TeacherMyRoutineList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
