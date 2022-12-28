// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ScheduleList.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';

import '../Utils.dart';
import 'RoutineRowWidget.dart';

// ignore: must_be_immutable
class RoutineRow extends StatefulWidget {
  String? title;
  int? classCode;
  int? sectionCode;
  String? id;

  RoutineRow({this.title, this.classCode, this.sectionCode, this.id});

  @override
  _ClassRoutineState createState() =>
      _ClassRoutineState(title, classCode, sectionCode);
}

class _ClassRoutineState extends State<RoutineRow> {
  String? title;
  int? classCode;
  int? sectionCode;
  Future<ScheduleList>? routine;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  _ClassRoutineState(this.title, this.classCode, this.sectionCode);

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Utils.getStringValue('id').then((value) {
      setState(() {
        if (classCode == null && sectionCode == null) {
          routine = fetchRoutine(
              int.parse(widget.id != null ? widget.id! : value!), title);
        } else {
          routine = fetchRoutineByClsSec(int.parse(value!), title);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScheduleList>(
      future: routine,
      builder: (context, snapshot) {
        print('data: ' + snapshot.data.toString());
        if (snapshot.hasData) {
          if (snapshot.data!.schedules.length > 0) {
            return Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(title!,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black.withOpacity(0.5))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Time',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text(
                              'Subject',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          /*Expanded(
                            flex: 3,
                            child: Text(
                              'Room',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.schedules.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RoutineRowDesign(
                            AppFunction.getAmPm(snapshot
                                    .data!.schedules[index].startTime!) +
                                ' - ' +
                                AppFunction.getAmPm(
                                    snapshot.data!.schedules[index].endTime!),
                            snapshot.data!.schedules[index].subject,
                            room: snapshot.data!.schedules[index].room);
                      },
                    ),
                  ],
                ),
              ),
            );

            //Text(AppFunction.getAmPm(snapshot.data.schedules[0].startTime)+' - '+AppFunction.getAmPm(snapshot.data.schedules[0].endTime));

          } else {
            /* return Card(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text("No Data Found For " + title)),
            ));*/
            return Container();
          }
        } else {
          return ShimmerList(
            height: 100,
            itemCount: 7,
          );
        }
      },
    );
  }

  Future<ScheduleList> fetchRoutine(int id, String? title) async {
    final response = await http.get(Uri.parse(InfixApi.getRoutineUrl(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      // print(jsonData);
      return ScheduleList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ScheduleList> fetchRoutineByClsSec(int id, String? title) async {
    final response = await http.get(
        Uri.parse(
            InfixApi.getRoutineByClassAndSection(id, classCode, sectionCode)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // If server returns an OK response, parse the JSON.
      return ScheduleList.fromJson(jsonData['data'][title]);
    } else {
      // If that response was not OK, throw an error.

      throw Exception('Failed to load post');
    }
  }
}
