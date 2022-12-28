import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/designation_list_controller.dart';
import 'package:nextschool/controller/staff_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/model/designation_model.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/model/ProfileModel.dart';

class EditManagementProfileScreen extends StatefulWidget {
  ProfileModel? staff;

  EditManagementProfileScreen({this.staff});

  @override
  State<EditManagementProfileScreen> createState() =>
      _EditManagementProfileScreenState();
}

class _EditManagementProfileScreenState
    extends State<EditManagementProfileScreen> {
  var _formKey = GlobalKey<FormState>();

  DateTime? date;
  var userRole;
  String? genderId;
  bool isResponse = false;
  int? roleId;
  String? _token;
  String? _id;
  int? designationId;
  String? gender;
  String? role;

  String errorMsg = '';

  Future<TeacherSubjectList>? subjects;
  late TeacherSubjectList subjectList;

  String? _selectedSubjects;
  List<String> _selectedsubs = [];
  String? _selectedDesignation;

  int? classId;
  String? _selectedClass;
  Future<ClassList?>? classes;
  DateTime minDate = DateTime(DateTime.now().year - 150);
  DateTime? _dateOfBirth;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  TextEditingController nameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController staffnidController = TextEditingController();
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());
  DesignationListController designationListController =
      Get.put(DesignationListController());
  StaffListController staffListController = Get.put(StaffListController());
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  @override
  void initState() {
    designationListController.fetchDesignationList();
    setState(() {
      _id = userDetailsController.id.toString();
      _token = userDetailsController.token.toString();
    });
    var user = widget.staff!.data!.userDetails!;
    var userdetails = widget.staff!.data!.userDetails!;
    nameController.text = userdetails.firstName;
    middleNameController.text = user.middleName ?? '';
    _selectedDesignation = user.designation;
    designationId = user.designationId;
    lastNameController.text = user.lastName;
    emailController.text = user.email ?? '';
    phoneController.text = user.mobile ?? '';
    dateOfBirthController.text = user.dateOfBirth;
    // if (user.subjectNames != null) {
    //   _selectedsubs = user.subjectNames ?? [];
    // }
    if (user.genderId == 1) {
      gender = 'Male';
    } else
      gender = 'Female';
    genderId = user.genderId.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        appBarColor: HexColor('#f9ddf2'),
        title: 'Update Profile',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12.sp),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TxtField(
                        hint: 'First Name*',
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Flexible(
                      flex: 2,
                      child: TxtField(
                        hint: 'Middle Name (Optional)',
                        controller: middleNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                  hint: 'Last Name*',
                  controller: lastNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(flex: 2, child: getGenderDropdown()),
                    SizedBox(
                      width: 2.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                DateSelectorTextField(
                    controller: dateOfBirthController,
                    locale: _locale,
                    title: 'Date of Birth',
                    validatorMessage: 'dob is required',
                    onDateSelected: (date) {
                      dateOfBirthController.text = date;
                    }),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                  hint: 'Mobile No*',
                  controller: phoneController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (value[0] != '0') {
                      return 'Phone number should start with 0';
                    }
                    return null;
                  },
                  length: 10,
                  type: TextInputType.number,
                  formatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.deny(RegExp(r'[^0-9-]')),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                    hint: 'E-mail (Optional)',
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 1.5.h,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        height: 60.sp,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: HexColor('#4e88ff'),
                    ),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: HexColor('#4e88ff'),
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: HexColor('#4e88ff'),
                      ),
                      color: HexColor('#4e88ff')),
                  child: TextButton(
                    style: TextButton.styleFrom(),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isResponse = true;
                        });
                        Utils.showProcessingToast();
                        updateProfile();
                      }
                    },
                  ),
                ),
              ],
            ),
            isResponse == true
                ? const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }

  void updateProfile() async {
    UserDetailsController userController = Get.put(UserDetailsController());
    FormData parameter = FormData.fromMap({
      'staff_id': widget.staff!.data!.userDetails!.userId,
      'first_name': nameController.text,
      'middle_name': middleNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'mobile': phoneController.text,
      'date_of_birth': dateOfBirthController.text,
      'gender_id': int.parse(genderId!),
    });
    log(parameter.fields.toString());

    //write above code using dio
    final response = await Dio()
        .post(InfixApi.updateStaffProfile(),
            data: parameter,
            options: Options(
              headers: Utils.setHeader(_token.toString()),
            ))
        .catchError((e) {
      var message = e.toString();
      print(message);
    });
    print(response.data);
    if (response.statusCode == 200) {
      await staffListController.fetchData(userController.id);
      setState(() {
        isResponse = false;
      });
      Utils.saveStringValue('fullname',
          '${nameController.text} ${middleNameController.text} ${lastNameController.text}');
      Utils.saveStringValue('email', emailController.text);
      Utils.saveStringValue('mobile', phoneController.text);
      Utils.saveStringValue('dob', dateOfBirthController.text);

      //intialize the user controller with the required data
      userDetailsController.fullName =
          '${nameController.text} ${middleNameController.text} ${lastNameController.text}';
      userDetailsController.email = emailController.text;
      userDetailsController.mobile = phoneController.text;
      userDetailsController.dob = dateOfBirthController.text;
      Navigator.pop(context);
      Navigator.pop(context);
      Utils.showToast('Staff Updated Successfully!');
    } else if (response.statusCode == 404) {
      Utils.showToast('Staff Already Created!!!');
      setState(() {
        isResponse = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  int? getSubjectId<T>(T t, String? subject) {
    int? code;
    for (var s in t as Iterable) {
      if (s.subjectName == subject) {
        code = s.subjectId;
      }
    }
    print('CODE: $code');
    return code;
  }

  Widget noSubjectAvailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 48,
        decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Text('No Subject assigned to teacher!',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
      ),
    );
  }

  Widget getGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender*',
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
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Please select a gender';
            }
            return null;
          },
          // showSelectedItems: true,
          items: ['Male', 'Female'],

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  item == 'Female'
                      ? Container()
                      : Divider(
                          color: HexColor('#8e9aa6'),
                          thickness: 0.5,
                        )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (2 * 42.sp) < 170.sp ? (2 * 42.sp) : 170.sp,
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
          onChanged: (dynamic newValue) {
            setState(() {
              gender = newValue;
              genderId =
                  _genders.singleWhere((e) => e['gender'] == newValue)['id'];
              print(_genders.singleWhere((e) => e['gender'] == newValue)['id']);
              debugPrint('User select $genderId');
            });
          },
          selectedItem: gender,
        ),
      ],
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

  Future<File?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var _file = File(result.files.single.path!);
      return _file;
    } else {
      Utils.showToast('Cancelled');
    }
    return null;
  }

  Widget getDesignationDropDown(List<DesignationData> designations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Designation*',
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
              return 'Please select a designation';
            }
            return null;
          },
          items: designations.map((e) => e.title!).toList(),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (designations.length * 60) < 200
                  ? (designations.length * 60)
                  : 200,
            ),
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
          ),
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },
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
          onChanged: (dynamic newValue) async {
            setState(() {
              errorMsg = '';
              _selectedDesignation = newValue;
              designationId =
                  designations.singleWhere((e) => e.title == newValue).id;
              print(designationId);
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedDesignation,
        ),
      ],
    );
  }
}
