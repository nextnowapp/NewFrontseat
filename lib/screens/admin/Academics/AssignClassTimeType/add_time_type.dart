import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Classes.dart';
import '../../../../utils/widget/ShimmerListWidget.dart';

class AddClassTimeType extends StatefulWidget {
  const AddClassTimeType({Key? key}) : super(key: key);

  @override
  _AddClassTimeTypeState createState() => _AddClassTimeTypeState();
}

class _AddClassTimeTypeState extends State<AddClassTimeType> {
  String? _id;
  int? classId;
  String? _token;
  String? _selectedTimeType;
  bool isResponse = false;
  String? _selectedClass;
  Future<ClassList?>? classes;
  TextEditingController controller = TextEditingController();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  var timeType = ['Type 1', 'Type 2', 'Type 3', 'Type 4'];

  @override
  void initState() {
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    classes = getAllClass(int.parse(_id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Time Table Type',
      ),
      body: Container(
        child: Column(
          children: [
            getTimeTypeNewDropdown(),
            FutureBuilder<ClassList?>(
              future: classes,
              builder: (context, secSnap) {
                if (secSnap.hasData) {
                  return getClassNewDropdown(secSnap.data!.classes);
                } else {
                  return Center(
                      child: ShimmerList(
                    itemCount: 1,
                    height: 56,
                    width: Utils.getWidth(context),
                  ));
                }
              },
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
                          'Save Class Time Type',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () async {}),
                isResponse == true
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )
                    : const Text(''),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
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
              labelStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
              debugPrint('User select $classId');
            });
          },
          selectedItem: _selectedClass),
    );
  }

  Widget getTimeTypeNewDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>(
          // mode: Mode.MENU,
          // showSelectedItems: true,
          // items: timeType,
          // label: "Select Time type",
          // showAsSuffixIcons: true,
          // dropdownSearchDecoration: InputDecoration(
          //   border: OutlineInputBorder(),
          //   labelStyle: Theme.of(context).textTheme.headline5,
          // ),
          // popupItemDisabled: (String s) => s.startsWith('I'),
          onChanged: (newValue) {
            setState(() {
              _selectedTimeType = newValue;
              debugPrint('User select $_selectedTimeType');
            });
          },
          selectedItem: _selectedTimeType),
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
}
