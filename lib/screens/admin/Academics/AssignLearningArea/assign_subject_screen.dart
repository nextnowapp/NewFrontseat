import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/subject_list_model.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Classes.dart';
import '../../../../utils/model/Section.dart';
import '../../../../utils/model/Staff.dart';
import '../../../../utils/widget/ShimmerListWidget.dart';
import '../../../../utils/widget/customLoader.dart';

class AssignSubjectScreen extends StatefulWidget {
  const AssignSubjectScreen({Key? key}) : super(key: key);

  @override
  _AssignSubjectScreenState createState() => _AssignSubjectScreenState();
}

class _AssignSubjectScreenState extends State<AssignSubjectScreen> {
  int? classId;
  int? sectionId;
  int? teacherId;
  int? subjectId;
  String? _id;
  String? _token;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedSubject;
  String? _selectedTeacher;
  Future<ClassList?>? classes;
  Future<SectionListModel?>? sections;
  Future<StaffList?>? staff;
  Future<SubjectListModel?>? subject;
  bool isResponse = false;
  bool isSectionSearch = false;
  Response? response;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    staff = getAllStaff(int.parse(_id!));
    subject = getAllSubject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Assign Learning Area',
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: getContent(context),
      ),
    );
  }

  Widget getContent(BuildContext context) => Column(
        children: [
          Expanded(
            child: FutureBuilder<ClassList?>(
              future: classes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      getClassNewDropdown(snapshot.data!.classes),
                      isSectionSearch
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4),
                              child: ShimmerList(
                                itemCount: 1,
                                height: 56,
                              ),
                            )
                          : FutureBuilder<SectionListModel?>(
                              future: sections,
                              builder: (context, secSnap) {
                                if (secSnap.hasData) {
                                  return getSectionNewDropdown(
                                      secSnap.data!.sections);
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4),
                                    child: ShimmerList(
                                      itemCount: 1,
                                      height: 56,
                                      width: Utils.getWidth(context),
                                    ),
                                  ));
                                }
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<StaffList?>(
                        future: staff,
                        builder: (context, secSnap) {
                          if (secSnap.hasData) {
                            return getStaffDropdown(secSnap.data!.staffs);
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
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<SubjectListModel?>(
                        future: subject,
                        builder: (context, secSnap) {
                          if (secSnap.hasData) {
                            return getSubjectDropdown(secSnap.data!.data);
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
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                decoration: Utils.BtnDecoration,
                                child: Text(
                                  'Assign Learning Area',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(14)),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (/*mark.isNotEmpty &&*/
                                  _selectedClass != null &&
                                      _selectedSection != null &&
                                      _selectedTeacher != null) {
                                setState(() {
                                  isResponse = true;
                                });
                                assignSubject();
                              } else {
                                // Utils.showSnackBar(
                                //     context, 'Check all the field');
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
                      )
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
        ],
      );

  Future<void> assignSubject() async {
    final body = {
      'class_id': classId,
      'section_id': sectionId,
      'subject': subjectId,
      'teacher': [teacherId]
    };
    final response = await http.post(Uri.parse(InfixApi.assignClassTeacher()),
        body: jsonEncode(body), headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      // Utils.showSnackBar(context, 'Teacher assigned successful',
      //     color: Colors.green);
      Utils.showToast('Teacher assigned successful');
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load');
    }
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

  Future<SubjectListModel?>? getAllSubject() async {
    final response = await http.get(Uri.parse(InfixApi.getAllSubject()),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SubjectListModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
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
              label: const Text('Select Grade*'),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
              isSectionSearch = true;
              sections = getAllSection(int.parse(_id!), classId);
              sections!.then((sectionValue) {
                setState(() {
                  isSectionSearch = false;
                });
                _selectedSection = sectionValue!.sections[0].name;
                sectionId = sectionValue.sections[0].id;
              });
              debugPrint('User select $classId');
            });
          },
          validator: (dynamic value) {
            if (value == null) {
              return 'Please select a grade';
            }
            return null;
          },
          selectedItem: _selectedClass),
    );
  }

  Widget getSectionNewDropdown(List<Section> sectionlist) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          // mode: Mode.MENU,
          // showSelectedItems: true,
          items: sectionlist.map((e) => e.name!).toList(),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (sectionlist.length * 60) < 200
                  ? (sectionlist.length * 60)
                  : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              label: const Text('Select Class*'),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedSection = newValue;
              sectionId = getCode(sectionlist, newValue);
              // sections = getAllSection(int.parse(_id), classId);
              debugPrint('User select $sectionId');
            });
          },
          validator: (dynamic value) {
            if (value == null) {
              return 'Please select a section';
            }
            return null;
          },
          selectedItem: _selectedSection),
    );
  }

  Widget getStaffDropdown(List<Staff> sectionlist) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          items: sectionlist.map((e) => e.fullName).toList(),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (sectionlist.length * 60) < 200
                  ? (sectionlist.length * 60)
                  : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              label: const Text('Select Teacher*'),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedTeacher = newValue;
              teacherId = getCode(sectionlist, newValue);
              // sections = getAllSection(int.parse(_id), classId);
              debugPrint('User select $teacherId');
            });
          },
          validator: (dynamic value) {
            if (value == null) {
              return 'Please select a teacher';
            }
            return null;
          },
          selectedItem: _selectedTeacher),
    );
  }

  Widget getSubjectDropdown(List<Subject>? sectionlist) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          // mode: Mode.MENU,
          // showSelectedItems: true,
          items: sectionlist!.map((e) => e.subjectName!).toList(),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (sectionlist.length * 60) < 200
                  ? (sectionlist.length * 60)
                  : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              label: const Text('Select Class*'),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedSubject = newValue;
              subjectId = getSubjectCode(sectionlist, newValue);
              debugPrint('User select $subjectId');
            });
          },
          selectedItem: _selectedSubject),
    );
  }

  int? getCode<T>(T? t, String? title) {
    int? code;
    // for (var cls in t as Iterable<T?>) {
    //   if (cls!.name == title) {
    //     code = cls.id;
    //     break;
    //   }
    // }
    return code;
  }

  int? getSubjectCode<T>(T t, String? title) {
    int? code;
    // for (var cls in t as Iterable<>) {
    //   if (cls.subjectName == title) {
    //     code = cls.id;
    //     break;
    //   }
    // }
    return code;
  }
}
