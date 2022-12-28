import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/forget_password_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/server/Login.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class NewLoginScreen extends StatefulWidget {
  final String schoolLogo;
  final String roleId;
  const NewLoginScreen(
      {Key? key, required this.schoolLogo, required this.roleId})
      : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  var isResponse;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var nid = _usernameController.text;
      var password = _passwordController.text;
      try {
        print('Login Successful');
        setState(() {
          InfixApi.baseUrl = _userDetailsController.schoolUrl;
        });
        var role = _userDetailsController.role;
        await Login(nid, password).getData2(context).then((result) async {
          Utils.showLoginToast(result!);
        });
      } catch (e) {
        _btnController.reset();
        Utils.showErrorToast(e.toString());
      }
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          imageUrl: widget.schoolLogo,
          width: 60.w,
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(12.sp),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to\na digitally transforming school!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                    ).fontFamily,
                    color: Colors.black),
              ),
              SizedBox(
                height: 2.h,
              ),
              SvgPicture.asset(
                'assets/images/login-02.svg',
                width: 100.w,
                height: 20.h,
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'Login',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TxtField(
                      hint: 'Username/E-mail*',
                      insideHint: 'Enter Username / E-mail',
                      controller: _usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Username / E-mail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TxtField(
                      icon: const Icon(Icons.lock),
                      hint: 'Passcode*',
                      insideHint: 'Enter Passcode',
                      type: TextInputType.number,
                      pass: true,
                      formatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r'\s\b|\b\s')),
                      ],
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(
                                roleId: widget.roleId,
                                schoolLogo: widget.schoolLogo,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Passcode?',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: RoundedLoadingButton(
                    width: 80.w,
                    borderRadius: 25,
                    color: Colors.blueAccent,
                    controller: _btnController,
                    onPressed: () {
                      onSubmit();
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
