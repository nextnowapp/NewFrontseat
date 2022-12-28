import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/choose_Login.dart';
import 'package:nextschool/screens/choose_school.dart';
import 'package:nextschool/screens/landing_screen.dart';
import 'package:nextschool/screens/signup_flow/singup_flow_screen.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  final String schoolName;
  final String schoolID;
  final String schoolUrl;
  final String schoolLogo;
  const WelcomeScreen(
      {Key? key,
      required this.schoolName,
      required this.schoolID,
      required this.schoolUrl,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.schoolLogo,
                width: 60.w,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 2.h, top: 2.h, left: 4.w, right: 4.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Column(
                            children: [
                              Text(
                                'Welcome to \n${this.widget.schoolName}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ).fontFamily,
                                ),
                              ),
                              Utils.sizedBoxHeight(1.h),
                              InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(widget.schoolUrl));
                                },
                                child: Text(
                                  '${(this.widget.schoolUrl.replaceAll('https://', 'www.')).replaceAll('/', '')}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 10.sp,
                                    decoration: TextDecoration.underline,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ).fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: firstCheckBox,
                                      onChanged: (value) {
                                        setState(() {
                                          firstCheckBox = value!;
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
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
                                              text: 'before you can proceed.',
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: secondCheckBox,
                                      onChanged: (value) {
                                        setState(() {
                                          secondCheckBox = value!;
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
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
                                                  'Using this digital platform, we also require your expressed consent as per POPIA.',
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black)),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: HexColor('#4fbe9e')),
                                        child: Container(
                                          height: 6.h,
                                          width: 60.w,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontFamily: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                              ).fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          buttonPressed = true;
                                        });
                                        if (firstCheckBox && secondCheckBox) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseLoginType(
                                                schoolLogo: widget.schoolLogo,
                                                schoolName: widget.schoolName,
                                                schoolID: widget.schoolID,
                                                schoolUrl: widget.schoolUrl,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[600],
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: HexColor('#4fbe9e'),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      child: Container(
                                        height: 6.h,
                                        width: 60.w,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'First Time? Register',
                                          style: TextStyle(
                                            color: HexColor('#4fbe9e'),
                                            fontSize: 12.sp,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          buttonPressed = true;
                                        });
                                        if (firstCheckBox && secondCheckBox) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignupFlowScreen(
                                                schoolLogo: widget.schoolLogo,
                                                schoolName: widget.schoolName,
                                                schoolID: widget.schoolID,
                                                schoolUrl: widget.schoolUrl,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 3.h),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: HexColor('#4fbe9e'),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      child: Ink(
                                        child: Container(
                                          height: 6.h,
                                          width: 60.w,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            'Continue as Guest',
                                            style: TextStyle(
                                              color: HexColor('#4fbe9e'),
                                              fontSize: 12.sp,
                                              fontFamily: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                              ).fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Utils.saveBooleanValue(
                                            'isLogged', true);
                                        Utils.saveStringValue('rule', '6');
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AppFunction.getFunctions(
                                                  context, '6', null);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                  visible: ((firstCheckBox == false ||
                                          secondCheckBox == false) &&
                                      buttonPressed),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Please accept the terms and conditions',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LandingScreen()),
                                );
                              },
                              child: const BackBtn())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
