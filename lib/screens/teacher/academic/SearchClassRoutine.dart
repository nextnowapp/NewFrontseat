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
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

import 'RoutineListScreen.dart';

class SearchRoutineScreen extends StatefulWidget {
  @override
  _SearchRoutineScreenState createState() => _SearchRoutineScreenState();
}

class _SearchRoutineScreenState extends State<SearchRoutineScreen> {
  String? _id;
  int? classId;
  int? sectionId;
  String? _selectedClass;
  String? _selectedSection;
  Future<ClassList>? classes;
  Future<SectionListModel>? sections;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    classes!.then((value) {
      try {
        _selectedClass = value.classes[0].name;
        classId = value.classes[0].id;
        _selectedClass = value.classes[0].name;
        classId = value.classes[0].id;
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Search TimeTable'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<ClassList>(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.classes.length == null) {
                  return Utils.noDataTextWidget();
                } else
                  return ListView(
                    children: <Widget>[
                      getClassDropdown(snapshot.data!.classes),
                      FutureBuilder<SectionListModel>(
                        future: sections,
                        builder: (context, secSnap) {
                          if (secSnap.hasData) {
                            if (snapshot.data!.classes == null) {
                              return Utils.noDataTextWidget();
                            } else
                              return getSectionDropdown(secSnap.data!.sections);
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
      ),
      bottomNavigationBar: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: Utils.BtnDecoration,
            child: Text(
              'Search',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.white, fontSize: ScreenUtil().setSp(16)),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentRoutine(
                        classId,
                        sectionId,
                      )));
        },
      ),
    );
  }

  Widget getClassDropdown(List<Classes> classes) {
    if (classes.length == 0) {
      return Utils.noDataTextWidget();
    } else
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButton(
          elevation: 0,
          isExpanded: true,
          items: classes.map((item) {
            return DropdownMenuItem<String>(
              value: item.name,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  item.name!,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                ),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          onChanged: (dynamic value) {
            setState(() {
              _selectedClass = value;

              classId = getCode(classes, value);

              debugPrint('User select $classId');
            });
          },
          value: _selectedClass,
        ),
      );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    if (sectionlist.length == 0) {
      return Utils.noDataTextWidget();
    } else
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButton(
          elevation: 0,
          isExpanded: true,
          items: sectionlist.map((item) {
            return DropdownMenuItem<String>(
              value: item.name,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(item.name!,
                    style:
                        TextStyle(color: Colors.grey.shade800, fontSize: 15)),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
          onChanged: (dynamic value) {
            setState(() {
              _selectedSection = value;

              sectionId = getCode(sectionlist, value);

              debugPrint('User section $sectionId');
            });
          },
          value: _selectedSection,
        ),
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

  Future<ClassList> getAllClass(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById()),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
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
}
