import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/subject_list_model.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';

class AddLearningArea extends StatefulWidget {
  final bool? isEdit;
  final Subject? model;

  AddLearningArea({this.isEdit, this.model});

  @override
  _AddLearningAreaState createState() => _AddLearningAreaState();
}

class _AddLearningAreaState extends State<AddLearningArea> {
  String? _id;
  String? _token;
  bool isResponse = false;
  int? _learningAreaId;
  String? _selectedSubjectType;
  TextEditingController controller = TextEditingController();
  TextEditingController codeController = TextEditingController();
  var subjectType = ['Theory', 'Practical'];
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: widget.isEdit! ? 'Update Learning Area' : 'Add Learning Areas',
      ),
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(12.sp),
              width: 100.w,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'Learning Area Name',
                    type: TextInputType.text,
                    controller: controller,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  getSubjectTypeNewDropdown(),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'Learning Area Code',
                    type: TextInputType.number,
                    controller: codeController,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                    width: 100.w,
                    borderRadius: 10,
                    color: HexColor('#5374ff'),
                    controller: _btnController,
                    onPressed: () {
                      if (controller.text.isNotEmpty &&
                          _selectedSubjectType!.isNotEmpty &&
                          codeController.text.isNotEmpty) {
                        if (widget.isEdit!) {
                          updateLearningAreas();
                         
                        } else {
                          assignLearningAreas();
                         
                        }
                      } else {
                        _btnController.reset();
                        // Utils.showSnackBar(context, 'Please check all fields.',
                        //     color: Colors.red);
                        Utils.showToast('Please check all fields.');
                      }
                    },
                    child: Text('Save Learning Area',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
      _btnController.success();
      Utils.showToast('Learning Area Added Successfully..!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      _btnController.reset();
      Utils.showToast('Learning Area already assigned!!!');
    
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
      _btnController.success();
      Utils.showToast('Learning Area updated successfully..!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      _btnController.reset();
      Utils.showToast('Learning Area already assigned!!!');
    } else {
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }

  Widget getSubjectTypeNewDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Select Type*',
        style: TextStyle(
          color: HexColor('#8e9aa6'),
          fontSize: 10.sp,
          fontFamily: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        ),
      ),
      SizedBox(
        height: 0.5.h,
      ),
      DropdownSearch<String>(
          validator: (value) {
            if (value == null) {
              return 'Please select the type';
            }
            return null;
          },
          // mode: Mode.MENU,
          // showSelectedItems: true,
          items: subjectType,
          // label: "Select Subject type",
          // showAsSuffixIcons: true,
          // dropdownSearchDecoration: InputDecoration(
          //   border: OutlineInputBorder(),
          //   labelStyle: Theme.of(context).textTheme.headline5,
          // ),
          // popupItemDisabled: (String s) => s.startsWith('I'),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (subjectType.length * 60) < 200
                  ? (subjectType.length * 60)
                  : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            dropdownSearchDecoration: InputDecoration(
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#d5dce0'),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#5374ff'),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedSubjectType = newValue;
              debugPrint('User select $_selectedSubjectType');
            });
          },
          selectedItem: _selectedSubjectType),
    ]);
  }
}
