import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/submit_button.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String schoolLogo;
  final String roleId;
  const ForgotPasswordScreen({
    Key? key,
    required this.schoolLogo,
    required this.roleId,
  }) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  DateTime? _dateOfBirth;

  //define userDetailsController
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? errorMsg;
  //controllers
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  late SimulatedSubmitController submitController;
  var _formKey = GlobalKey<FormState>();

  //define time locale
  var timeLocale = DateTimePickerLocale.en_us;

  String? userRole;

  var roleJson = [
    {
      'id': 3,
      'role': 'Parent',
    },
    {
      'id': 4,
      'role': 'Teacher',
    },
    {
      'id': 5,
      'role': 'Management',
    }
  ];

  @override
  void initState() {
    submitController = SimulatedSubmitController(
      onOpenError: () {},
      onPressed: onSubmit,
      onOpenSuccess: () {},
    );

    super.initState();
  }

  //define onSubmit function
  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate()) {
      Dio dio = Dio();

      var response = await dio.post(
        InfixApi.forgotPassword(),
        data: {
          'username': _usernameController.text,
          'dob': _dobController.text,
          'role_id': widget.roleId,
        },
      ).catchError((e) {
        setState(() {
          errorMsg = e.response.data['message'];
        });
      });

      //if response is successful
      if (response.statusCode == 200) {
        _btnController.success();
        var data = response.data;
        UserContactInformation userContactInformation =
            UserContactInformation.fromJson(data['data']);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RecoverPasswordScreen(
            userContactInformation: userContactInformation,
            dob: _dobController.text,
            username: _usernameController.text,
          );
        }));
      }
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                SvgPicture.asset(
                  'assets/images/Forgot Passcode.svg',
                  width: 100.w,
                  height: 16.h,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Forgot Passcode',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    children: [
                      // TxtField(
                      //   hint: 'Phone No.',
                      //   insideHint: 'Enter your phone no.',
                      //   controller: _phoneController,
                      //   length: 10,
                      //   validator: (value) {
                      //     //first digit should be 0 and length should be 10
                      //     if (!(value.isEmpty) && value.length != 10) {
                      //       return 'Phone no. should be 10 digits';
                      //     } else if (!(value.isEmpty) && value[0] != '0') {
                      //       return 'Phone no. should start with 0';
                      //     }
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 2.h,
                      // ),
                      TxtField(
                        hint: 'Username/E-mail/Phone',
                        insideHint: 'Enter your username/E-mail/Phone',
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      DateSelectorTextField(
                        locale: timeLocale,
                        controller: _dobController,
                        title: 'Date of Birth*',
                        validatorMessage: 'Invalid Date of Birth',
                        onDateSelected: (value) {},
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Visibility(
                  visible: errorMsg != null,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Text(
                        errorMsg.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                RoundedLoadingButton(
                  borderRadius: 30,
                  color: const Color(0xFF3ab28d),
                  child: Text(
                    'Recover Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                  controller: _btnController,
                  onPressed: () async {
                    setState(() {
                      errorMsg = null;
                    });
                    await onSubmit();
                  },
                  resetAfterDuration: true,
                  resetDuration: const Duration(seconds: 3),
                  successColor: const Color(0xFF222744),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecoverPasswordScreen extends StatefulWidget {
  final String username;
  final String dob;
  final UserContactInformation userContactInformation;
  const RecoverPasswordScreen(
      {Key? key,
      required this.userContactInformation,
      required this.username,
      required this.dob})
      : super(key: key);

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: '',
      ),
      body: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            return true;
          },
          child: this.widget.userContactInformation != null
              ? Container(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 30.0, right: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recover Passcode',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Select which contact details you would\nlike to use to recieve your new Passcode',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Visibility(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 30.0, right: 30.0),
                          decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                    'Sorry! We are not able to contact you. Please contact your school administrator for assistance.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        visible: (this.widget.userContactInformation.email ==
                                    null ||
                                this.widget.userContactInformation.email ==
                                    '') &&
                            (this.widget.userContactInformation.phone == null ||
                                this.widget.userContactInformation.phone == ''),
                      ),
                      Visibility(
                        visible: this.widget.userContactInformation.email != '',
                        child: GestureDetector(
                          onTap: () async {
                            Dio dio = Dio();
                            var response = await dio
                                .post(InfixApi.recoverPassword(), data: {
                              'username': this.widget.username,
                              'dob': this.widget.dob,
                              'recover_method': 'email',
                            }).catchError((e) {
                              var msg = e.response.data['message'];
                              Utils.showErrorToast(msg.toString());
                              return e;
                            });

                            if (response.statusCode == 200) {
                              var msg = response.data['message'];
                              Utils.showToast(msg);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LandingScreen()));
                            }
                          },
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.grey[100],
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: const Icon(
                                      Icons.email,
                                      size: 40,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Send me on email',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        this
                                            .widget
                                            .userContactInformation
                                            .email!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: this.widget.userContactInformation.phone != '',
                        child: GestureDetector(
                          onTap: () async {
                            Dio dio = Dio();
                            var response = await dio
                                .post(InfixApi.recoverPassword(), data: {
                              'username': this.widget.username,
                              'dob': this.widget.dob,
                              'recover_method': 'mobile',
                            }).catchError((e) {
                              var msg = e.response.data['message'];
                              Utils.showErrorToast(msg);
                              return e;
                            });

                            if (response.statusCode == 200) {
                              var msg = response.data['message'];
                              Utils.showToast(msg);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LandingScreen()));
                            }
                          },
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.grey[100],
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: const Icon(
                                      Icons.mobile_friendly,
                                      size: 40,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Send me on mobile',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        this
                                            .widget
                                            .userContactInformation
                                            .phone!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      // Expanded(
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

class UserContactInformation {
  String? email;
  String? phone;
  UserContactInformation({this.email, this.phone});

  UserContactInformation.fromJson(Map<String, dynamic> json) {
    email = json['enc_email'] ?? '';
    phone = json['enc_mobile'] ?? '';
  }
}
