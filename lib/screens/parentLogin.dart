import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextschool/screens/forget_password_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/server/Login.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class ParentLoginScreen extends StatefulWidget {
  final String? schoolId;
  final String roleId;
  final String? schoolUrl;
  final String? schoolLogo;

  ParentLoginScreen(
      {Key? key,
      required this.schoolId,
      required this.roleId,
      required this.schoolUrl,
      required this.schoolLogo})
      : super(key: key);

  @override
  _ParentLoginScreenState createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  //form controller
  final _formKey = GlobalKey<FormState>();

  //controllers for form fields
  TextEditingController _parentDOBController = TextEditingController();
  TextEditingController _childDOBController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  //variables
  bool hidden = true;
  bool validated = false;
  var isResponse = false;

  String? _childDateTime;
  String? _parentDateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  //back leading
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.schoolLogo!,
                        width: 60.w,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'Welcome to\n a digitally transforming school!!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.sp),
                      child: Column(children: [
                        DateSelectorTextField(
                          controller: _childDOBController,
                          locale: _locale,
                          title: 'Learner\'s DOB',
                          hintText: 'Learner\'s DOB (DD/MM/YYYY)',
                          validatorMessage: 'Invalid Date of Birth',
                          onDateSelected: (value) {
                            setState(() {
                              _childDateTime = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        DateSelectorTextField(
                          locale: _locale,
                          controller: _parentDOBController,
                          title: 'Parent\'s DOB',
                          hintText: 'Parent\'s DOB (DD/MM/YYYY)',
                          validatorMessage: 'Invalid Date of Birth',
                          onDateSelected: (value) {
                            setState(() {
                              _parentDateTime = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        TxtField(
                          controller: _passwordController,
                          hint: 'Passcode',
                          insideHint: 'Enter Passcode',
                          length: 6,
                          type: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter passcode';
                            } else if (value.length < 6) {
                              return 'Passcode must be 6 digits';
                            }
                            return null;
                          },
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(
                                      schoolLogo: widget.schoolLogo!,
                                      roleId: widget.roleId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Passcode?',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 10.sp,
                                  decoration: TextDecoration.underline,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ).fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        RoundedLoadingButton(
                          borderRadius: 30,
                          color: const Color(0xFF3ab28d),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ).fontFamily,
                            ),
                          ),
                          controller: _btnController,
                          onPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            if (_formKey.currentState!.validate()) {
                              print('Login Button Pressed');
                              var password = _passwordController.text;
                              var data = {
                                'ldob': _childDOBController.text,
                                'pdob': _parentDOBController.text,
                                'role': 'parent',
                                'password': password,
                              };

                              try {
                                setState(() {
                                  isResponse = true;
                                });

                                setState(() {
                                  InfixApi.baseUrl = this.widget.schoolUrl!;
                                });
                                await Login2(data)
                                    .getData2(context)
                                    .then((result) async {
                                  Utils.showLoginToast(result!);
                                  setState(() {
                                    isResponse = false;
                                  });
                                });
                              } catch (e) {
                                setState(() {
                                  isResponse = false;
                                  Timer(const Duration(seconds: 2), () {
                                    _btnController.stop();
                                  });
                                });
                                Utils.showErrorToast(e.toString());
                              }
                            }
                          },
                          resetAfterDuration: true,
                          resetDuration: const Duration(seconds: 3),
                          successColor: const Color(0xFF222744),
                        )
                      ]),
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
}
