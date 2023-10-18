import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/exception/DioException.dart';
import '../Class/SectionModel.dart';
import 'grade_model.dart';

class AddGrade extends StatefulWidget {
  final bool? isEdit;
  final Class? model;

  AddGrade({this.isEdit, this.model});

  @override
  _AddGradeState createState() => _AddGradeState();
}

class _AddGradeState extends State<AddGrade> {
  String? _id;
  int? _gradeId;
  String? _token;
  bool isResponse = false;
  List<String> _selectedSection = [];
  List? _selectedSectionId = [];
  Future<SectionModel?>? model;
  TextEditingController controller = TextEditingController();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  var _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit!) {
      _gradeId = widget.model!.id;
      controller.text = widget.model!.className!;
      _selectedSectionId = widget.model!.assignedSectionId;
    }

    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: widget.isEdit! ? 'Update Class' : 'Add Class',
      ),
      body: Container(
        height: size.height,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TxtField(
                    hint: 'Class Name',
                    controller: controller,
                    validator: (value) {
                      if (value == '') {
                        return 'Enter class name';
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedLoadingButton(
                  width: 100.w,
                  borderRadius: 10,
                  color: HexColor('#5374ff'),
                  controller: _btnController,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit == true) {
                        updateGrade();
                      } else {
                        assignGrade();
                      }
                    } else {
                      _btnController.reset();
                    }
                  },
                  child: Text(widget.isEdit! ? 'Update Class' : 'Add Class',
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? getCode<T>(T t, String title) {
    int? code;
    // for (var cls in t as Iterable<_>) {
    //   if (cls.name == title) {
    //     code = cls.id;
    //     break;
    //   }
    // }
    return code;
  }

  List getIdList<T>(T t, List list) {
    print(list);
    List codes = [];
    // for (var cls in t as Iterable<_>) {
    //   for (int i = 0; i < list.length; i++) {
    //     if (cls.sectionName == list[i]) {
    //       codes.add(cls.id);
    //     }
    //   }
    // }
    print(codes);
    return codes;
  }

  assignGrade() async {
    var parameter = {'name': controller.text.toUpperCase()};
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _token.toString()},
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.classStore(),
      data: parameter,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioException(e).toString();
      _btnController.reset();
      Utils.showToast('Class already assigned..!');
    });
    if (response.statusCode == 200) {
      _btnController.success();
      Utils.showToast('Class Added Successfully..!');
      GradeListController _gradeListController = Get.put(GradeListController());
      _gradeListController.fetchGradeList();
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      _btnController.reset();
      Utils.showToast('Failed to add class');
    } else {
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }

  Future<void> updateGrade() async {
    final body = {
      'id': _gradeId,
      'name': controller.text,
      'section': _selectedSectionId
    };
    final response = await http.post(Uri.parse(InfixApi.updateGrade()),
        body: jsonEncode(body), headers: Utils.setHeader(_token.toString()));
    print(body.entries);
    if (response.statusCode == 200) {
      // Utils.showSnackBar(context, 'Grade Updated Successfully..!',
      //     color: Colors.green);
      _btnController.success();
      Utils.showToast('Grade Updated Successfully..!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      _btnController.reset();
      // Utils.showSnackBar(context, 'Grade already assigned!!!',
      //     color: Colors.red);
      Utils.showToast('Grade already assigned!!!');
    } else {
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }
}
