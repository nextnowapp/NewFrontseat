import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/subject_list_model.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Classes.dart';
import '../../../../utils/model/Section.dart';
import '../../../../utils/widget/ShimmerListWidget.dart';
import '../../../../utils/widget/customLoader.dart';

class OptionalLearningArea extends StatefulWidget {
  final bool? isEdit;
  final Subject? model;

  OptionalLearningArea({this.isEdit, this.model});

  @override
  _OptionalLearningAreaState createState() => _OptionalLearningAreaState();
}

class _OptionalLearningAreaState extends State<OptionalLearningArea> {
  String? _id;
  String? _token;
  int? classId;
  int? sectionId;
  int? teacherId;
  int? subjectId;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedSubject;
  Future<ClassList?>? classes;
  Future<SectionListModel?>? sections;
  Future<SubjectListModel?>? subject;
  bool isResponse = false;
  bool isSectionSearch = false;
  int? _learningAreaId;
  String? _selectedSubjectType;
  TextEditingController controller = TextEditingController();
  TextEditingController codeController = TextEditingController();
  var subjectType = ['Theory', 'Practical'];
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEdit!) {
      print('Flag: isEdit');
      setState(() {
        _learningAreaId = widget.model!.id;
        _selectedSubjectType = widget.model!.subjectType;
        controller.text = widget.model!.subjectName!;
      });
    }
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    subject = getAllSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.isEdit! ? 'Update Learning Area' : 'Add Learning Area',
      ),
      body: getContent(context),
    );
  }

  Widget getContent(BuildContext context) {
    return FutureBuilder<ClassList?>(
      future: classes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              getClassNewDropdown(snapshot.data!.classes),
              isSectionSearch
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4),
                      child: ShimmerList(
                        itemCount: 1,
                        height: 56,
                      ),
                    )
                  : FutureBuilder<SectionListModel?>(
                      future: sections,
                      builder: (context, secSnap) {
                        if (secSnap.hasData) {
                          return getSectionNewDropdown(secSnap.data!.sections);
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
                            'Save Learning Area',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (controller.text.isNotEmpty &&
                            _selectedSubjectType!.isNotEmpty &&
                            codeController.text.isNotEmpty) {
                          if (widget.isEdit!) {
                            updateLearningAreas();
                            setState(() {
                              isResponse = true;
                            });
                          } else {
                            assignLearningAreas();
                            setState(() {
                              isResponse = true;
                            });
                          }
                        } else {
                          // Utils.showSnackBar(context, 'Please check all fields.',
                          //     color: Colors.red);
                          Utils.showToast('Please check all fields.');
                        }
                      }),
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
    );
  }

  Future<void> assignLearningAreas() async {
    final body = {
      'subject_type': _selectedSubjectType!.substring(0, 1),
      'subject_name': controller.text,
      'subject_code': codeController.text
    };
    final response = await http.post(Uri.parse(InfixApi.subjectStore()),
        body: jsonEncode(body), headers: Utils.setHeader(_token.toString()));
    print(body.entries);
    if (response.statusCode == 200) {
      // Utils.showSnackBar(context, 'Learning Area Added Successfully..!',
      //     color: Colors.green);
      Utils.showToast('Learning Area Added Successfully..!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      // Utils.showSnackBar(context, 'Learning Area already assigned!!!',
      //     color: Colors.red);
      Utils.showToast('Learning Area already assigned!!!');
      setState(() {
        isResponse = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> updateLearningAreas() async {
    final body = {
      'subject_type': _selectedSubjectType!.substring(0, 1),
      'subject_name': controller.text,
      'subject_code': codeController.text,
      'id': _learningAreaId
    };
    final response = await http.post(Uri.parse(InfixApi.updateSubject()),
        body: jsonEncode(body), headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      // Utils.showSnackBar(context, 'Learning Area updated successfully..!',
      //     color: Colors.green);
      Utils.showToast('Learning Area updated successfully..!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      // Utils.showSnackBar(context, 'Learning Area already assigned!!!',
      //     color: Colors.red);
      Utils.showToast('Learning Area already assigned!!!');
      setState(() {
        isResponse = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget getSubjectTypeNewDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          // mode: Mode.MENU,
          // showSelectedItems: true,
          // items: subjectType,
          // label: "Select Subject type",
          // showAsSuffixIcons: true,
          // dropdownSearchDecoration: InputDecoration(
          //   border: OutlineInputBorder(),
          //   labelStyle: Theme.of(context).textTheme.headline5,
          // ),
          // popupItemDisabled: (String s) => s.startsWith('I'),
          onChanged: (newValue) {
            setState(() {
              _selectedSubjectType = newValue;
              debugPrint('User select $_selectedSubjectType');
            });
          },
          selectedItem: _selectedSubjectType),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          // mode: Mode.MENU,
          // showSelectedItems: true,
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
              labelStyle: Theme.of(context).textTheme.headline5,
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
              labelStyle: Theme.of(context).textTheme.headline5,
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
          selectedItem: _selectedSection),
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
              labelStyle: Theme.of(context).textTheme.headline5,
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

  int? getSubjectCode<T>(T t, String? title) {
    int? code;
    // for (var cls in t as Iterable<_>) {
    //   if (cls.subjectName == title) {
    //     code = cls.id;
    //     break;
    //   }
    // }
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
}
