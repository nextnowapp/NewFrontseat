import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditParentProfile extends StatefulWidget {
  int id;
  String firstName;
  String? middleName;
  String lastName;
  String dob;
  String? occupation;
  String? mobile;
  String? email;
  String? nid;
  String? relation;

  EditParentProfile({
    Key? key,
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dob,
    this.occupation,
    this.mobile,
    this.email,
    this.nid,
    this.relation,
  }) : super(key: key);

  @override
  State<EditParentProfile> createState() => _EditParentProfileState();
}

class _EditParentProfileState extends State<EditParentProfile> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController occupationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController relationController;
  late TextEditingController parentnidController;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  String? _token;
  UserDetailsController controller = Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    middleNameController = TextEditingController(text: widget.middleName);
    lastNameController = TextEditingController(text: widget.lastName);
    dobController = TextEditingController(text: widget.dob);
    occupationController = TextEditingController(text: widget.occupation);
    phoneController = TextEditingController(text: widget.mobile);
    emailController = TextEditingController(text: widget.email);
    relationController = TextEditingController(text: widget.relation);
    parentnidController = TextEditingController(text: widget.nid);

    _token = controller.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        showNotification: false,
        title: 'Update Profile',
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
                            hint: 'Middle Name',
                            controller: middleNameController,
                            // value: widget.lastName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TxtField(
                      hint: 'Last Name',
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
                    DateSelectorTextField(
                      controller: dobController,
                      // initialDate: widget.homework!.homeworkDate,
                      minDate: DateTime(1900),
                      maxDate: DateTime.now(),
                      dateFormat: 'dd/MM/yyyy',
                      onDateSelected: (date) {
                        dobController.text = date;
                      },
                      locale: _locale,
                      title: 'Date of Birth',
                      validatorMessage: 'Please select  date of birth',
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    TxtField(
                      hint: 'Relation',
                      controller: relationController,
                      // value: widget.Occupation,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter relation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    TxtField(
                      hint: 'Phone Number',
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
                    SizedBox(
                      height: 1.5.h,
                    ),
                    TxtField(
                      hint: 'E-mail',
                      controller: emailController,
                      // value: widget.email,
                      validator: (value) {
                        //add email validation
                        if (value!.isNotEmpty &&
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
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
        child: Material(
          color: HexColor('#5374ff'),
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () async {
              updateParentProfile();
              Utils.showProcessingToast();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: Text(
                  'Submit',
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
    );
  }

  updateParentProfile() async {
    FormData parameter = FormData.fromMap({
      'user_id': widget.id,
      'parent_name': firstNameController.text,
      'parent_middle_name': middleNameController.text,
      'parent_last_name': lastNameController.text,
      'parent_email': emailController.text,
      'parent_phone': phoneController.text,
      'parent_dob': dobController.text,
      'parent_relation': relationController.text,
    });
    log(parameter.fields.toString());
    Dio dio = Dio(BaseOptions(
      headers: Utils.setHeader(_token.toString()),
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.updateParentProfile(),
      data: parameter,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = e.response.data['message'];
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Details updated Successfully!');
      Utils.saveStringValue('fullname',
          '${firstNameController.text} ${middleNameController.text} ${lastNameController.text}');
      Utils.saveStringValue('email', emailController.text);
      Utils.saveStringValue('mobile', phoneController.text);
      Utils.saveStringValue('dob', dobController.text);

      //intialize the user controller with the required data
      controller.fullName =
          '${firstNameController.text} ${middleNameController.text} ${lastNameController.text}';
      controller.email = emailController.text;
      controller.mobile = phoneController.text;
      controller.dob = dobController.text;
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      Utils.showErrorToast('Failed to update details');
    } else {
      throw Exception('Failed to load');
    }
  }
}
