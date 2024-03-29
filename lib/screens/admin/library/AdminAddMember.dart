// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/LibraryCategoryMember.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/model/Staff.dart';
import 'package:nextschool/utils/model/Student.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final idController = TextEditingController();
  String? selectedCategory;
  Future<LibraryMemberList>? categoryList;
  Future<ClassList>? classes;
  Future<SectionListModel>? sections;
  Future<StudentList>? students;
  Future<StaffList>? staffs;
  int? selectedCategoryId;
  bool isStudentCategory = false;
  String? selectedClass;
  int? selectedClassId;
  String? selectedSection;
  int? selectedSectionId;
  String? selectedStudent;
  int? selectedStudentId;
  String? selectedStaff;
  int? selectedStaffId;
  String? _id;
  String? _token;

  bool available = true;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    categoryList = getAllCategory();

    categoryList!.then((value) {
      setState(() {
        selectedCategory = value.members[0].name;
        selectedCategoryId = value.members[0].id;
        print('Selected cat id : $selectedCategoryId');
        staffs = getAllStaff(selectedCategoryId);
        staffs!.then((staffVal) {
          setState(() {
            selectedStaff = staffVal.staffs[0].fullName;
            selectedStaffId = staffVal.staffs[0].userId;
            print('Staff Name: $selectedStaff Staff ID: $selectedStaffId');
          });
        });
      });
    });
    classes = getAllClass(int.parse(_id!));
    classes!.then((value) {
      selectedClass = value.classes[0].name;
      selectedClassId = value.classes[0].id;
      students = getAllStudent();
      students!.then((value) {
        selectedStudent = value.students[0].name;
        selectedStudentId = value.students[0].id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Add Member',
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: idController,
                style: Theme.of(context).textTheme.titleLarge,
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Enter ID Here',
                  border: InputBorder.none,
                ),
              ),
            ),
            FutureBuilder<LibraryMemberList>(
              future: categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return getCategoryDropdown(snapshot.data!.members);
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<ClassList>(
              future: classes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getClassDropdown(snapshot.data!.classes)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<SectionListModel>(
              future: sections,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getSectionDropdown(snapshot.data!.sections)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<StaffList>(
              future: staffs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return !isStudentCategory
                      ? getStaffDropDown(snapshot.data!.staffs)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<StudentList>(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return isStudentCategory
                      ? getStudentDropdown(snapshot.data!.students)
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0, top: 100.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  if (selectedCategoryId == 2) {
                    if (idController.text.isNotEmpty) {
                      addMemberData(
                              '$selectedCategoryId',
                              idController.text,
                              '$selectedClassId',
                              '$selectedSectionId',
                              '$selectedStudentId',
                              '0',
                              _id)
                          .then((val) {
                        if (val) {
                          idController.text = '';
                        }
                      });
                    } else {
                      Utils.showToast('Enter unique id');
                    }
                  } else {
                    if (idController.text.isNotEmpty) {
                      addMemberData(
                              '$selectedCategoryId',
                              idController.text,
                              '$selectedClassId',
                              '$selectedSectionId',
                              '0',
                              '$selectedStaffId',
                              _id)
                          .then((val) {
                        if (val) {
                          idController.text = '';
                        }
                      });
                    } else {
                      Utils.showToast('Enter unique id');
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryDropdown(List<LibraryMember> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: categories.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.0),
        onChanged: (dynamic value) {
          setState(() {
            selectedCategory = value;
            selectedCategoryId = getCode(categories, value);
            print('SELECTED CAT: $selectedCategoryId');
            switch (selectedCategoryId) {
              case 2:
                setState(() {
                  isStudentCategory = true;
                });
                break;
              default:
                setState(() {
                  isStudentCategory = false;
                  staffs = getAllStaff(selectedCategoryId);
                  staffs!.then((staffVal) {
                    setState(() {
                      if (staffVal.staffs.length == 0) {
                        Utils.showToast('No staffs found');
                      }
                      selectedStaff = staffVal.staffs[0].fullName;
                      selectedStaffId = staffVal.staffs[0].userId;
                      print(
                          'Staff Name: $selectedStaff Staff ID: $selectedStaffId');
                    });
                  });
                });
                break;
            }
            debugPrint('User select $selectedCategoryId');
          });
        },
        value: selectedCategory,
      ),
    );
  }

  Widget getClassDropdown(List<Classes> classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.0),
        onChanged: (dynamic value) {
          setState(() {
            selectedClass = value;
            selectedClassId = getCode(classes, value);
            debugPrint('User select $selectedClassId');
            students = getAllStudent();
            students!.then((value) {
              if (value.students.length == 0) {
                Utils.showToast('No student found');
              }
              selectedStudent = value.students[0].name;
              selectedStudentId = value.students[0].id;
            });
          });
        },
        value: selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sections) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sections.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.0),
        onChanged: (dynamic value) {
          setState(() {
            selectedSection = value;
            selectedSectionId = getCode(sections, value);
            students = getAllStudent();
            debugPrint('User select $selectedSectionId');
            students = getAllStudent();
            students!.then((value) {
              if (value.students.length == 0) {
                Utils.showToast('No student found');
              }
              selectedStudent = value.students[0].name;
              selectedStudentId = value.students[0].id;
            });
          });
        },
        value: selectedSection,
      ),
    );
  }

  Widget getStaffDropDown(List<Staff> staff) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: staff.map((item) {
          return DropdownMenuItem<String>(
            value: item.fullName,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.fullName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.0),
        onChanged: (dynamic value) {
          print(value);
          setState(() {
            selectedStaff = value;
            selectedStaffId = getCode2(staff, value);
            print(selectedStaffId);
            // staffs = getAllStaff(selectedStaffId);
            //
            // staffs = getAllStaff(selectedCategoryId);
            // staffs.then((staffVal) {
            //   if (staffVal.staffs.length == 0) {
            //     Utils.showToast('No staff found');
            //   }
            //   selectedStaff = value;
            //   selectedStaffId = getCode(staff, value);
            //   print('Staff Name: $selectedStaff Staff ID: $selectedStaffId');
            // });
            print('Staff Name: $selectedStaff Staff ID: $selectedStaffId');
            debugPrint('User select $selectedStaffId');
          });
        },
        value: selectedStaff,
      ),
    );
  }

  Widget getStudentDropdown(List<Student> student) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: student.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13.0),
        onChanged: (dynamic value) {
          setState(() {
            selectedStudent = value;
            selectedStudentId = getCode(student, value);
            students = getAllStudent();
            debugPrint('User select $selectedStudentId');
          });
        },
        value: selectedStudent,
      ),
    );
  }

  Future<LibraryMemberList> getAllCategory() async {
    final response = await http.get(
        Uri.parse(InfixApi.getLibraryMemberCategory),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
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

  int? getCode2<T>(T t, String? title) {
    int? code;
    // for (var cls in t as Iterable<_>) {
    //   if (cls.name == title) {
    //     code = cls.userId;
    //     break;
    //   }
    // }
    return code;
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

  Future<StudentList> getAllStudent() async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentByClassAndSection(selectedClassId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(int? staffId) async {
    final response = await http.get(Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<bool> addMemberData(
      String categoryId,
      String uID,
      String classId,
      String sectionId,
      String studentId,
      String stuffId,
      String? createdBy) async {
    Response response;
    Dio dio = Dio();

    print(InfixApi.addLibraryMember(
        categoryId, uID, classId, sectionId, studentId, stuffId, createdBy));
    response = await dio
        .post(
      InfixApi.addLibraryMember(
          categoryId, uID, classId, sectionId, studentId, stuffId, createdBy),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Member Added');
      return true;
    } else {
      return false;
    }
  }
}
