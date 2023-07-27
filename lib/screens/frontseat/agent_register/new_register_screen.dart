import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/widget/textwidget.dart';
import '../../../utils/widget/txtbox.dart';
import '../agent_onboarding/verify_email_screen.dart';
import '../services/api_list.dart';
import '../services/kyc_api.dart';

class NewRegisterScreen extends StatefulWidget {
  const NewRegisterScreen({Key? key}) : super(key: key);

  @override
  State<NewRegisterScreen> createState() => _NewRegisterScreenState();
}

class _NewRegisterScreenState extends State<NewRegisterScreen> {
  UserDetailsController controller = Get.put(UserDetailsController());
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  int? otp;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String verifyId = '';
  String? deviceToken;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  void initState() {
    messaging.getToken().then((value) {
      deviceToken = value;
      Utils.saveStringValue('deviceToken', deviceToken!);
      log(deviceToken.toString());
    });
    super.initState();
  }

  bool isObscure1 = true;
  bool isObscure2 = true;
  bool? success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // use TxtField for textfields anywhere inside app
                          TxtField(
                            hint: 'Name',
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              } else if (!(value.contains('@'))) {
                                return 'Please enter valid Email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Phone Number',
                            controller: phoneController,
                            formatter: [
                              LengthLimitingTextInputFormatter(10),
                              //digits only
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            type: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone Number is required';
                              } else if (value.length != 10 ||
                                  value[0] != '0') {
                                return 'Phone number should be 10 digits starting with 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Password',
                            controller: passwordController,
                            pass: isObscure1,
                            icon: IconButton(
                                icon: Icon(
                                  isObscure1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure1 = !isObscure1;
                                  });
                                }),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              } else if (value.length < 8) {
                                return 'password must be at least 8 characters';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Confirm Password',
                            controller: confirmPasswordController,
                            pass: isObscure2,
                            icon: IconButton(
                                icon: Icon(
                                  isObscure2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure2 = !isObscure2;
                                  });
                                }),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Confirm password is required';
                              } else if (value.length < 8) {
                                return 'password must be at least 8 characters';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                              } else if (value != passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'By signing up, you agree to our Terms ,',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'https://schoolmanagement.co.za/terms'));
                        },
                        child: const Text(
                          'Data Policy ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.blue),
                        ),
                      ),
                      const Text(
                        'and',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'https://schoolmanagement.co.za/privacy'));
                        },
                        child: const Text(
                          ' Cookies Policy.',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RoundedLoadingButton(
                        width: 80.w,
                        borderRadius: 5,
                        color: Colors.red,
                        controller: _btnController,
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              passwordController.text ==
                                  confirmPasswordController.text &&
                              passwordController.text.isNotEmpty) {
                            success = await register();
                            if (success == true) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white,
                                      insetPadding: const EdgeInsets.all(15),
                                      title: TextWidget(
                                        txt:
                                            'We have sent an OTP to ${phoneController.text} , please check and verify',
                                        size: 17,
                                      ),
                                      content: OtpTextField(
                                          focusedBorderColor: Colors.red,
                                          showFieldAsBox: true,
                                          onSubmit: (value) async {
                                            var body = {
                                              'verification_code': value,
                                            };
                                            await KycApi.mobileVerified(
                                                body, context);
                                          },
                                          borderWidth: 4.0,
                                          numberOfFields: 6,
                                          borderColor: Colors.red),
                                      actions: [
                                        TextButton(
                                            child:
                                                const TextWidget(txt: 'Skip'),
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VerifyEmailScreen(),
                                                  ));
                                            })
                                      ],
                                    );
                                  });
                            }
                          } else {
                            _btnController.reset();
                          }
                        },
                        child: const Text('Register',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Row(
                      children: [
                        const Flexible(child: Divider()),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Flexible(child: Divider()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> register() async {
    int id;
    int roleId;
    String role;
    String fullName;
    String email;
    String mobile;
    String dob;
    String photo;
    int age;
    int genderId;
    String gender;
    String designation;
    int zoom;
    String is_administrator;
    String user_type;
    String token;
    bool isLogged;
    String schoolUrl;
    var message;
    var data = {
      'full_name': nameController.text,
      'phone_number': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'active_status': '2'
    };
    try {
      final response = await http.post(
        Uri.parse(FrontSeatApi.registerUser),
        body: data,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body);
        log(response.body.toString());
        var data = jsonDecode(response.body);
        var userData = data['data']['user'];
        // getting the required data from the response
        id = userData['id'];
        roleId = userData['role_id'];
        role = userData['role'];
        fullName = userData['fullname'];
        email = userData['email'] ?? '';
        mobile = userData['mobile'] ?? '';
        genderId = userData['genderId'] ?? 1;
        zoom = userData['zoom'];
        is_administrator = userData['is_administrator'];
        token = userData['accessToken'];
        schoolUrl = FrontSeatApi.base;

        //saving data in local
        Utils.saveIntValue('id', id);
        Utils.saveIntValue('roleId', roleId);
        Utils.saveStringValue('rule', role);
        Utils.saveStringValue('fullname', fullName);
        Utils.saveStringValue('email', email);
        Utils.saveStringValue('mobile', mobile);
        Utils.saveIntValue('genderId', genderId);
        Utils.saveIntValue('zoom', zoom);
        Utils.saveStringValue('isAdministrator', is_administrator);
        Utils.saveStringValue('token', token);
        Utils.saveBooleanValue('isLogged', true);
        Utils.saveStringValue('schoolUrl', schoolUrl);

        //intialize the user controller with the required data
        controller.id = id;
        controller.roleId = roleId;
        controller.role = role;
        controller.fullName = fullName;
        controller.email = email;
        controller.mobile = mobile;
        controller.genderId = genderId;
        controller.zoom = zoom;
        controller.is_administrator = is_administrator;
        controller.token = token;
        controller.isLogged = true;
        controller.schoolUrl = schoolUrl;
        await KycApi.getOtp();
        _btnController.reset();
        return true;
        // Utils.showToast('Agent has been created successfully');
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => const BottomBar()),
        //     (Route<dynamic> route) => route is BottomBar);
      } else {
        _btnController.reset();
        Utils.showErrorToast('The email has already been taken.');
        // Navigator.of(context, rootNavigator: true).pop('dialog');
        throw Exception('Failed to load');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
