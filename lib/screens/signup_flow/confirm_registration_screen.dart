import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/choose_school.dart';
import 'package:nextschool/screens/landing_screen.dart';
import 'package:nextschool/screens/signup_flow/parent_form.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/textwidget.dart';

class ConfirmRegistration extends StatefulWidget {
  final String schoolLogo;
  final Map<String, dynamic> map;
  final String passcode;
  const ConfirmRegistration(
      {Key? key,
      required this.schoolLogo,
      required this.map,
      required this.passcode})
      : super(key: key);

  @override
  State<ConfirmRegistration> createState() => _ConfirmRegistrationState();
}

class _ConfirmRegistrationState extends State<ConfirmRegistration> {
  bool firstCheckBox = false;
  bool secondCheckBox = false;
  bool buttonPressed = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CachedNetworkImage(
            imageUrl: widget.schoolLogo,
            width: 60.w,
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: 100.h,
              padding:
                  EdgeInsets.only(bottom: 2.h, left: 4.w, right: 4.w, top: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                      'assets/svg/parent_onboarding/Confirm Registration.svg'),
                  SizedBox(
                    height: 8.h,
                  ),
                  Column(
                    children: [
                      Text(
                        'To register you, on our school digital platform, we need you to provide your details as a parent and the details of your learner for this registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: firstCheckBox,
                              onChanged: (value) {
                                setState(() {
                                  firstCheckBox = value!;
                                });
                              },
                              activeColor: Colors.blue,
                              fillColor: MaterialStateProperty.all(Colors.blue),
                              side: const BorderSide(
                                  color: Colors.black54, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Please accept our ',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: 'T&Cs ',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue)),
                                  TextSpan(
                                      text: 'before you can proceed',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: secondCheckBox,
                              onChanged: (value) {
                                setState(() {
                                  secondCheckBox = value!;
                                });
                              },
                              activeColor: Colors.blue,
                              fillColor: MaterialStateProperty.all(Colors.blue),
                              side: const BorderSide(
                                  color: Colors.black54, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'Using this digital platform, we also require your expressed consent as per POPIA/GDPR',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Register as Parent',
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff1a1a1a))),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LandingScreen()),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 110,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: HexColor('#3fb18f'),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.navigate_before,
                                  color: HexColor('#3fb18f'),
                                  size: 26,
                                ),
                                TextWidget(
                                  txt: 'Cancel',
                                  clr: HexColor('#3fb18f'),
                                  size: 12.sp,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            ),
                          )),
                      InkWell(
                        onTap: () {
                          if (firstCheckBox && secondCheckBox) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentFormScreen(
                                  schoolLogo: widget.schoolLogo,
                                  passcode: widget.passcode,
                                  map: widget.map,
                                ),
                              ),
                            );
                          } else {
                            Utils.showErrorToast(
                                'Please accept the terms and conditions');
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: HexColor('#3fb18f'),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: HexColor('#3fb18f'),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 10),
                              TextWidget(
                                  txt: "Let's begin",
                                  clr: Colors.white,
                                  size: 12.sp,
                                  weight: FontWeight.w600),
                              const Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
}
