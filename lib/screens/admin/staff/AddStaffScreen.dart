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
import 'package:intl/intl.dart';
import 'package:nextschool/controller/designation_list_controller.dart';
import 'package:nextschool/controller/staff_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/model/designation_model.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/widget/addn_deleteButton.dart';

class AddStaffScreen extends StatefulWidget {
  bool isEdit;
  int? index;

  AddStaffScreen({this.isEdit = false, this.index});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  var _formKey = GlobalKey<FormState>();

  DateTime? date;
  String _format = 'dd/MM/yyyy';
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
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
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
    if (widget.isEdit == true) {
      nameController.text = staffListController.staffs[widget.index!].firstName;
      middleNameController.text =
          staffListController.staffs[widget.index!].middleName ?? '';
      lastNameController.text =
          staffListController.staffs[widget.index!].lastName;
      emailController.text =
          staffListController.staffs[widget.index!].email ?? '';
      phoneController.text =
          staffListController.staffs[widget.index!].phone ?? '';
      dateOfBirthController.text =
          staffListController.staffs[widget.index!].dob;
      staffnidController.text =
          staffListController.staffs[widget.index!].nid ?? '';
      if (staffListController.staffs[widget.index!].designation != null) {
        _selectedDesignation =
            staffListController.staffs[widget.index!].designation;
      }

      if (staffListController.staffs[widget.index!].subjectNames != null) {
        _selectedsubs = staffListController.staffs[widget.index!].subjectNames!;
      }

      if (staffListController.staffs[widget.index!].className != '') {
        _selectedClass = staffListController.staffs[widget.index!].className;
        classId = staffListController.staffs[widget.index!].classId;
      }
      if (staffListController.staffs[widget.index!].subjectNames != []) {
        _selectedsubs = staffListController.staffs[widget.index!].subjectNames!;
      }
      staffListController.staffs[widget.index!].designation;
      if (staffListController.staffs[widget.index!].genderId == 1) {
        gender = 'Male';
      } else
        gender = 'Female';
      if (staffListController.staffs[widget.index!].roleId == 4) {
        role = 'Teacher';
      } else if (staffListController.staffs[widget.index!].roleId == 5)
        role = 'Management';
      else
        role = 'IT Admin';
      genderId = staffListController.staffs[widget.index!].genderId.toString();
      designationId = staffListController.staffs[widget.index!].designationId;
      emailController.text =
          staffListController.staffs[widget.index!].email ?? '';
      var dl = (staffListController.staffs[widget.index!].dob).split('/');
      _dateOfBirth =
          DateTime(int.parse(dl[2]), int.parse(dl[1]), int.parse(dl[0]));
      dateOfBirthController.text =
          DateFormat(_format).format(_dateOfBirth!).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        appBarColor: HexColor('#f9ddf2'),
        title: widget.isEdit ? 'Update Staff' : 'Add Staff',
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
                    Flexible(
                      flex: 2,
                      child: Obx(() => getDesignationDropDown(
                          designationListController.designationList)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                  readonly: true,
                  hint: 'Date of Birth*',
                  controller: dateOfBirthController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter date of birth';
                    }
                    return null;
                  },
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      pickerTheme: const DateTimePickerTheme(
                        itemTextStyle: TextStyle(fontWeight: FontWeight.w600),
                        confirm:
                            Text('Done', style: TextStyle(color: Colors.red)),
                        cancel: Text('cancel',
                            style: TextStyle(color: Colors.cyan)),
                        itemHeight: 40,
                      ),
                      pickerMode: DateTimePickerMode.date,
                      minDateTime: minDate,
                      initialDateTime: DateTime.now(),
                      dateFormat: _format,
                      locale: _locale,
                      onClose: () => print('----- onClose -----'),
                      onCancel: () => print('onCancel'),
                      onChange: (dateTime, List<int> index) {
                        setState(() {
                          _dateOfBirth = dateTime;
                          dateOfBirthController.text =
                              DateFormat('dd/MM/yyyy').format(dateTime);
                        });
                      },
                      onConfirm: (dateTime, List<int> index) {
                        setState(() {
                          setState(() {
                            _dateOfBirth = dateTime;
                            dateOfBirthController.text =
                                DateFormat('dd/MM/yyyy').format(dateTime);
                          });
                        });
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                  hint: 'Mobile No*',
                  controller: phoneController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.isNotEmpty && value.length != 10) {
                      return 'Please enter phone number';
                    } else if (value.isNotEmpty && value[0] != '0') {
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
                      if (value!.isNotEmpty && !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 1.5.h,
                ),
                TxtField(
                  hint: 'RSA ID',
                  controller: staffnidController,
                  length: 13,
                  type: TextInputType.number,
                  formatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  // value: widget.lastName,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length < 13) {
                      return 'Please enter valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: AddnDeleteButton(
                borderColor: '#4e88ff',
                textColor: '#4e88ff',
                title: 'Cancel',
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              color: Colors.blueAccent,
              width: 40.w,
              child: RoundedLoadingButton(
                width: 40.w,
                height: 50,
                controller: _btnController,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addStaff();
                  } else {
                    _btnController.reset();
                  }
                },
                child: Text(widget.isEdit ? 'Update Staff' : 'Add Staff',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addStaff() async {
    if (widget.isEdit == true) {
      UserDetailsController userController = Get.put(UserDetailsController());
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      FormData parameter = FormData.fromMap({
        'staff_id': staffListController.staffs[widget.index!].userId,
        'designation_id': designationId,
        'first_name': nameController.text,
        'middle_name': middleNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'mobile': phoneController.text,
        'date_of_birth': dateFormat.format(_dateOfBirth!),
        'gender_id': int.parse(genderId!),
        'staff_nid': staffnidController.text,
      });

      //write above code using dio
      final response = await Dio()
          .post(InfixApi.updateStaff(),
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
        _btnController.success();
        Utils.showToast('Staff Updated Successfully!');
        Navigator.pop(context);
        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        Utils.showToast('Staff Already Created!!!');
        _btnController.reset();
      } else {
        _btnController.reset();
        throw Exception('Failed to load');
      }
    } else {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      print(nameController.text.isNotEmpty);
      {
        FormData parameter = FormData.fromMap({
          'designation_id': designationId,
          'first_name': nameController.text,
          'middle_name': middleNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'mobile': phoneController.text,
          'date_of_birth': dateFormat.format(_dateOfBirth!),
          'gender_id': int.parse(genderId!),
          'staff_nid': staffnidController.text,
        });

        //convert above code for dio
        final response = await Dio().post(InfixApi.addStaff(),
            data: parameter,
            options: Options(
              headers: Utils.setHeader(_token.toString()),
            ));

        if (response.statusCode == 200) {
          _btnController.success();
          final values = response.data;
          // Utils.showSnackBar(context, 'Staff Added Successfully!',
          //     color: Colors.green);
          if (response.data['success'] == true)
            Utils.showToast(response.data['message'].toString());
          else
            Utils.showToast('Staff Added Successfully!');
          Navigator.pop(context);
        } else {
          _btnController.reset();
          // Utils.showSnackBar(context, 'Staff Already Created!!!',
          throw Exception('Failed to load');
        }
      }
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
