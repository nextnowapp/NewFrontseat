// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';

class MySubjectScreen extends StatefulWidget {
  @override
  _MySubjectScreenState createState() => _MySubjectScreenState();
}

class _MySubjectScreenState extends State<MySubjectScreen> {
  Future<TeacherSubjectList?>? subjects;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _token;
  String? _id;
  List colors = [
    HexColor('#e8faf7'),
    HexColor('#ffe6f9'),
    HexColor('#ecf8ff'),
    HexColor('#fdebe0')
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    subjects = getAllSubject(int.parse(_id!));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Subjects',
      ),
      backgroundColor: Colors.white,
      body: Container(
        // margin: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<TeacherSubjectList?>(
                  future: subjects,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          ShimmerList(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            itemCount: 3,
                          ),
                          ShimmerList(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            itemCount: 3,
                          ),
                          ShimmerList(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            itemCount: 3,
                          ),
                          ShimmerList(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            itemCount: 3,
                          ),
                        ],
                      );
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data?.subjects.isEmpty ?? true) {
                          return const Center(
                            child: Text('No Subjects Assigned'),
                          );
                        } else {
                          return GridView.builder(
                              itemCount: snapshot.data!.subjects.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 4, right: 4),
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade100,
                                            offset: const Offset(
                                              15.0,
                                              15.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: colors[
                                                      index % colors.length],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .subjects[index]
                                                          .subjectName!,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width *
                                              //       0.2,
                                              // ),
                                              // Text(
                                              //     snapshot.data!.subjects[index]
                                              //         .subjectCode!,
                                              //     style: Theme.of(context)
                                              //         .textTheme
                                              //         .headlineSmall),
                                              // Expanded(
                                              //   child: Text(subject.subjectType == 'T' ? 'Theory' : 'Lab',
                                              //       style: Theme.of(context).textTheme.headlineSmall),
                                              // ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              'Educator:',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: HexColor('#b3becd')),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          )
                                          // Text(snapshot
                                          //     .data!.subjects[index].subjectType
                                          //     .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                // return TeacherSubjectRowLayout(
                                //     snapshot.data!.subjects[index]);
                              });
                        }
                        // return ListView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: snapshot.data!.subjects.length,
                        //   itemBuilder: (context, index) {
                        //     return TeacherSubjectRowLayout(
                        //         snapshot.data!.subjects[index]);
                        //   },
                        // );
                      } else
                        return const Center(child: Text('No data found'));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<TeacherSubjectList?>? getAllSubject(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getTeacherSubject(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TeacherSubjectList.fromJson(
        jsonData['data'],
      );
    } else {
      throw Exception('Failed to load');
    }
  }
}
