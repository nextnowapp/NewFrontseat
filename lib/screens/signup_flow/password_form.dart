import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/signup_flow/submit_data.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';

class PasswordFormScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> map;
  final String fullName;
  final String schoolLogo;
  const PasswordFormScreen(
      {Key? key,
      required this.userData,
      required this.map,
      required this.fullName,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<PasswordFormScreen> createState() => _PasswordFormScreenState();
}

class _PasswordFormScreenState extends State<PasswordFormScreen> {
  //keys and controllers for form
  var _formKey = GlobalKey<FormState>();
  //controllers
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _device_token;

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool activeButton = false;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print('token is $token');
      _device_token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 5),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.schoolLogo,
                      width: 60.w,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                'assets/svg/parent_onboarding/Step 3.svg'),
                            SizedBox(
                              width: 2.w,
                            ),
                            TextWidget(
                              txt: 'Step 3 of 3',
                              size: 12.sp,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        TextWidget(
                          txt: 'Set Passcode*',
                          size: 14.sp,
                          weight: FontWeight.w700,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Please set your new 6 digit Passcode to proceed.',
                                style: TextStyle(
                                  color: HexColor('#8e9aa6'),
                                  fontSize: 10.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          maxLength: 6,
                          obscureText: hidePassword ? true : false,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey[500],
                          cursorWidth: 1.sp,
                          cursorHeight: 18.sp,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[500],
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                            hintText: 'Set Passcode',
                            fillColor: HexColor('#5374ff'),
                            errorStyle: TextStyle(
                              fontSize: 8.sp,
                              color: HexColor('#de5151'),
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#d5dce0'),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#5374ff'),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#de5151'),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#de5151'),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (value == _confirmPasswordController.text &&
                                  value.length == 6) {
                                setState(() {
                                  activeButton = true;
                                });
                              } else {
                                setState(() {
                                  activeButton = false;
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          maxLength: 6,
                          obscureText: hideConfirmPassword ? true : false,
                          cursorColor: Colors.grey[500],
                          cursorWidth: 1.sp,
                          cursorHeight: 18.sp,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Confirm Passcode',
                            suffixIcon: IconButton(
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[500],
                              ),
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                            ),
                            fillColor: HexColor('#5374ff'),
                            errorStyle: TextStyle(
                              fontSize: 8.sp,
                              color: HexColor('#de5151'),
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#d5dce0'),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#5374ff'),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#de5151'),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: HexColor('#de5151'),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm passcode is required';
                            }
                            if (value != _passwordController.text) {
                              return 'Passcodes do not match';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (value == _passwordController.text &&
                                  value.length == 6) {
                                setState(() {
                                  activeButton = true;
                                });
                              } else {
                                setState(() {
                                  activeButton = false;
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              child: Ink(
                                width: 40.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: activeButton
                                      ? HexColor('#3db591')
                                      : Colors.grey,
                                ),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: const Text(
                                    'Set Passcode',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Map<String, dynamic> userData = {
                                    ...widget.userData,
                                    'p_pass': _passwordController.text,
                                    'p_username': widget.map['parent']
                                        ['p_username'],
                                    'learner_id': widget.map['learner']
                                        ['learner_id'],
                                    'admission_no': widget.map['learner']
                                        ['admission_no'],
                                        
                                    // 'device_token': _device_token,
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubmitDataScreen(
                                        fullName: widget.fullName,
                                        map: widget.map,
                                        userData: userData,
                                        schoolLogo: widget.schoolLogo,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
