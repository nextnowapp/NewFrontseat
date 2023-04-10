import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/services/api_list.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController oldpasswordcontroller = TextEditingController();

  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;
  bool passwordLength = false;
  bool passwordStrength = false;
  bool passwordCase = false;
  final RegExp stringUpperCase = RegExp(r'[A-Z]');
  final RegExp stringlowerCase = RegExp(r'[a-z]');
  final RegExp stringnumeric = RegExp(r'[0-9]');
  final RegExp stringspecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#ffffff'),
      appBar: CustomAppBarWidget(
        title: 'Reset Your Password',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'Set your own password',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TxtField(
                    hint: 'Old Password',
                    insideHint: 'Type Old Password',
                    pass: oldObscure,
                    controller: oldpasswordcontroller,
                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            oldObscure = !oldObscure;
                          });
                        },
                        icon: oldObscure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Old password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TxtField(
                    hint: 'Set New Password',
                    pass: newObscure,
                    insideHint: 'Alphanumeric',
                    controller: newpasswordcontroller,

                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            newObscure = !newObscure;
                          });
                        },
                        icon: newObscure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                    onChanged: (value) {
                      if (value.length < 8) {
                        passwordLength = false;
                      }
                      if (value.length >= 8) {
                        passwordLength = true;
                      }

                      if (!stringnumeric.hasMatch(value) ||
                          !stringspecial.hasMatch(value)) {
                        passwordStrength = false;
                      }
                      if (stringnumeric.hasMatch(value) ||
                          stringspecial.hasMatch(value)) {
                        passwordStrength = true;
                      }
                      if (!stringUpperCase.hasMatch(value) &&
                          !stringlowerCase.hasMatch(value)) {
                        passwordCase = false;
                      }
                      if (stringUpperCase.hasMatch(value) &&
                          stringlowerCase.hasMatch(value)) {
                        passwordCase = true;
                      }
                      setState(() {});
                    },
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'New password is required';
                    //   } else if (value.length < 8) {
                    //     return 'password must be at least 8 characters';
                    //   } else if (!stringUpperCase.hasMatch(value)) {
                    //     return 'At least one uppercase character is required';
                    //   } else if (!stringlowerCase.hasMatch(value)) {
                    //     return 'At least one uppercase character is required';
                    //   } else if (!passwordStrength) {
                    //     return 'At least one special character or number is required';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 20.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey.shade200),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            txt: 'Your password needs to:',
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              passwordCase
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.greenAccent,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              const TextWidget(
                                txt: 'Include both lowercase and uppercase',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              passwordStrength
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.greenAccent,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              const TextWidget(
                                txt: 'Include at least one number or symbol',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              passwordLength
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.greenAccent,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              const TextWidget(
                                txt: 'be at least 8 characters long',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TxtField(
                    hint: 'Confirm New Password',
                    pass: newObscure,
                    insideHint: 'Type New Password',
                    controller: confirmpasswordcontroller,

                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            newObscure = !newObscure;
                          });
                        },
                        icon: newObscure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter confirm password';
                    //   } else if (value != newPasswordController.text) {
                    //     return 'password does not match';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedLoadingButton(
                      width: 100.w,
                      borderRadius: 10,
                      color: Colors.red,
                      controller: _btnController,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          resetPassword();
                        } else {
                          _btnController.reset();
                        }
                      },
                      child: const Text('Set Password',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetPassword() async {
    var token = await Utils.getStringValue('token');
    var data = {
      'old_password': oldpasswordcontroller.text,
      'password': newpasswordcontroller.text,
      'password_confirmation': confirmpasswordcontroller.text
    };
    final response = await http.post(
      Uri.parse(FrontSeatApi.resetPass),
      headers: Utils.setHeader(token!),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      log(response.body);
      Utils.showToast('Password has been changed successfully');
      Navigator.pop(context);
      _btnController.reset();
    } else {
      _btnController.reset();
      log(response.body.toString());
      Utils.showErrorToast('Credentials does not match');
      throw Exception('Failed to load');
    }
  }
}
