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

class EditParent1Profile extends StatefulWidget {
  String id;
  String firstName;
  String? middleName;
  String lastName;
  String dob;
  String? occupation;
  String? mobile;
  String? email;
  String? nid;
  String learnerdob;

  EditParent1Profile({
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
    required this.learnerdob,
  }) : super(key: key);

  @override
  State<EditParent1Profile> createState() => _EditParent1ProfileState();
}

class _EditParent1ProfileState extends State<EditParent1Profile> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController occupationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController parent1nidController;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    middleNameController = TextEditingController(text: widget.middleName);
    lastNameController = TextEditingController(text: widget.lastName);
    var dob = widget.dob.split('-');
    var ldob = dob[2] + '/' + dob[1] + '/' + dob[0];
    dobController = TextEditingController(text: ldob);
    occupationController = TextEditingController(text: widget.occupation);
    phoneController = TextEditingController(text: widget.mobile);
    emailController = TextEditingController(text: widget.email);
    parent1nidController = TextEditingController(text: widget.nid);

    _token = _userDetailsController.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        showNotification: false,
        title: 'Edit Parent 1 Profile',
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter middle name';
                              }
                              return null;
                            },
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
                      hint: 'Occupation',
                      controller: occupationController,
                      // value: widget.Occupation,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Occupation';
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
                      height: 1.5.h,
                    ),
                    TxtField(
                      hint: 'RSA ID',
                      controller: parent1nidController,
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
              updateLearner();
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

  updateLearner() async {
    var ldate = widget.learnerdob.split('-');
    var learnerdob = ldate[2] + '/' + ldate[1] + '/' + ldate[0];
    FormData parameter = FormData.fromMap({
      'id': widget.id,
      'parent_1_name': firstNameController.text,
      'parent1_middle_name': middleNameController.text,
      'parent1_last_name': lastNameController.text,
      'parent_1_email': emailController.text,
      'parent1_phone': phoneController.text,
      'parent_1_occupation': occupationController.text,
      'parent_1_nid': parent1nidController.text,
      'parent1_dob': dobController.text,
      'page': 'parent1',
    });
    print(parameter.fields);
    Dio dio = Dio(BaseOptions(
      headers: Utils.setHeader(_token.toString()),
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.updateLearner(),
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
      Utils.showToast('Learner updated Successfully!');
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      Utils.showErrorToast('Failed to update learner');
    } else {
      throw Exception('Failed to load');
    }
  }
}
