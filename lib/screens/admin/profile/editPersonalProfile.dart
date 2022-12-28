import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditPersonalProfile extends StatefulWidget {
  String id;
  String firstName;
  String? middleName;
  String lastName;
  int genderId;
  String gender;
  int classId;
  String className;
  String dob;
  String? email;
  String? phone;
  String parent1dob;
  String? nid;

  EditPersonalProfile({
    Key? key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.genderId,
    required this.gender,
    required this.classId,
    required this.className,
    required this.dob,
    required this.parent1dob,
    this.middleName,
    this.email,
    this.phone,
    this.nid,
  }) : super(key: key);

  @override
  State<EditPersonalProfile> createState() => _EditPersonalProfileState();
}

class _EditPersonalProfileState extends State<EditPersonalProfile> {
  var firstNameController;
  var middleNameController;
  var lastNameController;
  var dobController;
  var emailController;
  var phoneController;
  var nidController;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  GradeListController gradeListController = Get.put(GradeListController());

  String errorMsg = '';

  String? genderId;
  String? gender;
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  int? classId;
  String? _selectedClass;
  Future<ClassList?>? classes;

  @override
  void initState() {
    firstNameController = TextEditingController(text: widget.firstName);
    middleNameController = TextEditingController(text: widget.middleName);
    lastNameController = TextEditingController(text: widget.lastName);
    var dob = widget.dob.split('-');
    var ldob = dob[2] + '/' + dob[1] + '/' + dob[0];
    dobController = TextEditingController(text: ldob);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    nidController = TextEditingController(text: widget.nid);
    gender = widget.gender;

    genderId = widget.genderId.toString();
    _selectedClass = widget.className;
    classId = widget.classId;
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        showNotification: false,
        title: 'Edit Personal Profile',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.sp,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: TxtField(
                            hint: 'First Name*',
                            controller: firstNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'First name is required';
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
                      hint: 'Surname / Last Name',
                      controller: lastNameController,
                      // value: widget.lastName,
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
                          child: Obx(() => getClassNewDropdown(
                              gradeListController.gradeList)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    DateSelectorTextField(
                      controller: dobController,
                      // initialDate: widget.homework!.homeworkDate,
                      minDate: DateTime(1980),
                      maxDate: DateTime.now(),
                      dateFormat: 'dd/MM/yyyy',
                      onDateSelected: (date) {
                        log(date);
                        dobController.text = date;
                      },
                      locale: _locale,
                      title: 'Date of Birth*',
                      validatorMessage: 'Please select  date of birth',
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    TxtField(
                      hint: 'E-mail',
                      controller: emailController,
                      // value: widget.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        //add email validation
                        else if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    TxtField(
                      hint: 'Mobile Number',
                      controller: phoneController,
                      // value: widget.phone,
                      length: 10,
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!value.startsWith('0')) {
                          return 'First digit must be 0';
                        }
                        return null;
                      },
                      formatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    TxtField(
                      hint: 'RSA ID',
                      controller: nidController,
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
                    SizedBox(
                      height: 1.5.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Material(
                color: HexColor('#222744'),
                borderRadius: BorderRadius.circular(20.0),
                child: InkWell(
                  splashFactory: InkRipple.splashFactory,
                  onTap: () async {
                    updateLearner();
                    Utils.showProcessingToast();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ).fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Material(
                color: HexColor('#5374ff'),
                borderRadius: BorderRadius.circular(20.0),
                child: InkWell(
                  splashFactory: InkRipple.splashFactory,
                  onTap: () async {
                    updateLearner();
                    Utils.showProcessingToast();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ).fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateLearner() async {
    var pdate = widget.parent1dob.split('-');
    var parent1dob = pdate[2] + '/' + pdate[1] + '/' + pdate[0];
    FormData parameter = FormData.fromMap({
      'id': widget.id,
      'first_name': firstNameController.text,
      'middle_name': middleNameController.text,
      'last_name': lastNameController.text,
      'date_of_birth': dobController.text,
      'phone_number': phoneController.text,
      'email_address': emailController.text,
      'gender': genderId,
      'class': classId,
      'nid': nidController.text,
      'page': 'personal'
    });
    Dio dio = Dio(
      BaseOptions(
        headers: Utils.setHeader(_token.toString()),
        contentType: 'application/json',
      ),
    );

    var response = await dio.post(
      InfixApi.updateLearner(),
      data: parameter,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError(
      (e) {
        print(e);
        final errorMessage = e.response!.data['message'];
        Utils.showToast(errorMessage);
        Navigator.pop(context);
      },
    );

    if (response.statusCode == 200) {
      Utils.showToast('Learner updated Successfully!');

      Navigator.pop(context);
    } else if (response.statusCode == 500) {
      var errorMessage = response.data['message'];
      Utils.showToast(errorMessage);
    } else if (response.statusCode == 404) {
      Utils.showErrorToast('Failed to update learner');
      setState(() {});
    } else {
      throw Exception('Failed to load');
    }
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

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class*',
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
              return 'Please select a class';
            }
            return null;
          },
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
          items: classes.map((e) => e.name!).toList(),
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
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight:
                  (classes.length * 60) < 200 ? (classes.length * 60) : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
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
              focusedErrorBorder: OutlineInputBorder(
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
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedClass,
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
}
