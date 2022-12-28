import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/forget_password_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/server/Login.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class StaffLoginScreen extends StatefulWidget {
  final String? schoolId;
  final String? schoolUrl;
  final String? schoolLogo;

  StaffLoginScreen(
      {Key? key,
      required this.schoolId,
      required this.schoolUrl,
      required this.schoolLogo})
      : super(key: key);

  @override
  _StaffLoginScreenState createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  //form controller
  final _formKey = GlobalKey<FormState>();

  //controllers for form fields
  final _nidController = TextEditingController();
  final _staffDobController = TextEditingController();
  final _passwordController = TextEditingController();
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  //variables
  bool hidden = true;
  bool validated = false;
  var isResponse = false;
  DateTime? date;
  String _format = 'dd-MM-yyyy';
  var userRole;
  DateTime minDate = DateTime(DateTime.now().year - 150);
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

////// json string to store roles with ids for staffs
  var roleJson = [
    {
      'id': 5,
      'role': 'Management',
    },
    {
      'id': 4,
      'role': 'Teacher',
    }
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            color: HexColor('#d5dce0'),
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CachedNetworkImage(
          imageUrl: widget.schoolLogo!,
          width: 60.w,
          fit: BoxFit.cover,
        ),
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //implement login with 13 digit RSA ID and password
            SizedBox(
              height: 5.h,
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
                padding: EdgeInsets.all(30.sp),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose your role*',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 10.sp,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ).fontFamily,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor('#d5dce0'),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: DropdownButton(
                          isExpanded: true,
                          value: userRole,
                          underline: const SizedBox(),
                          hint: Text(
                            'Not selected',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.4,
                          items: roleJson
                              .map((role) => DropdownMenuItem<String>(
                                    value: (role['id'].toString()),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        role['role'] as String,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (dynamic value) {
                            if (value == '5')
                              Utils.showThemeToast(
                                  'You are logging in as Management');
                            else
                              Utils.showThemeToast(
                                  'You are logging in as Teacher');
                            setState(() {
                              userRole = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  DateSelectorTextField(
                    controller: _staffDobController,
                    locale: _locale,
                    title: 'Date of Birth*',
                    hintText: 'Enter Your Date of Birth',
                    validatorMessage: 'Invalid Date of Birth',
                    onDateSelected: (value) {},
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
                                roleId: userRole,
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
                ]),
              ),
            ),

            // var loginParams = {
            //                   'sdob': staffDob,
            //                   'role':
            //                       userRole == '5' ? 'management' : 'teacher',
            //                 };
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
                FocusScope.of(context).requestFocus(new FocusNode());
                if (_formKey.currentState!.validate()) {
                  print('Login Button Pressed');
                  var password = _passwordController.text;
                  var data = {
                    'sdob': _staffDobController.text,
                    'role': userRole == '5' ? 'management' : 'teacher',
                    'password': password,
                  };

                  try {
                    setState(() {
                      InfixApi.baseUrl = this.widget.schoolUrl!;
                    });
                    await Login2(data).getData2(context).then((result) async {
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
          ],
        ),
      ]),
    );
  }
}
