import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/apis/Apis.dart';
import '../utils/widget/txtbox.dart';

class NewRegisterScreen extends StatefulWidget {
  const NewRegisterScreen({Key? key}) : super(key: key);

  @override
  State<NewRegisterScreen> createState() => _NewRegisterScreenState();
}

class _NewRegisterScreenState extends State<NewRegisterScreen> {
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
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  final RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  void initState() {
    // messaging.getToken().then((value) {
    //   deviceToken = value;
    //   Utils.saveStringValue("deviceToken", deviceToken!);
    //   log(deviceToken.toString());
    // });
    super.initState();
  }

  bool isObscure1 = true;
  bool isObscure2 = true;

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
                                return 'Please enter an Name';
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
                              } else if (value.length != 10) {
                                return 'Phone number should be 10 digits';
                              } else if (value[0] != '0') {
                                return 'Phone Number must start with 0';
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
                                return 'password is required';
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
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              passwordController.text ==
                                  confirmPasswordController.text &&
                              passwordController.text.isNotEmpty) {
                            register();
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

  register() async {
    var data = {
      'full_name': nameController.text,
      'phone_number': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };
    final response = await http.post(
      Uri.parse(FrontSeatApi.registerUser),
      body: data,
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());
      log('loggedin');
      _btnController.reset();
    } else {
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }
}
