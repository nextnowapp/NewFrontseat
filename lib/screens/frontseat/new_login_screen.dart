import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/screens/frontseat/new_register_screen.dart';
import 'package:nextschool/screens/frontseat/reset_password_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/user_controller.dart';
import '../../utils/apis/api_list.dart';
import '../../utils/widget/textwidget.dart';
import '../../utils/widget/txtbox.dart';
import 'nav_bar.dart';

class LoginFrontSeat extends StatefulWidget {
  LoginFrontSeat({Key? key}) : super(key: key);

  @override
  State<LoginFrontSeat> createState() => _LoginFrontSeatState();
}

class _LoginFrontSeatState extends State<LoginFrontSeat> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscure = true;
  UserDetailsController controller = Get.put(UserDetailsController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child:
                            SvgPicture.asset('assets/svg/frontseat_logo.svg')),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //controllers initialized in bloc state
                            TxtField(
                              hint: 'Email',
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'email is required';
                                } else if (!(value.contains('@'))) {
                                  return 'Please enter valid email';
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
                              pass: isObscure,
                              icon: IconButton(
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  }),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'password is required';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPasswordScreen()));
                                    },
                                    child: const TextWidget(
                                        txt: 'Forgot password?'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                            if (formKey.currentState!.validate()) {
                              login();
                            } else {
                              _btnController.reset();
                            }
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Row(
                        children: const [
                          Flexible(child: Divider()),
                          SizedBox(width: 10),
                          Text(
                            'New Agent?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(child: Divider()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(txt: 'Please register and'),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewRegisterScreen()));
                            },
                            child: const Text('Apply here',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  login() async {
    int id;
    int roleId;
    String role;
    String fullName;
    String email;
    String mobile;
    String dob;
    String photo;
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
      'email': emailController.text,
      'password': passwordController.text,
    };
    final response = await http.post(
      Uri.parse(FrontSeatApi.loginUser),
      body: data,
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var userData = data['data']['user'];
      // getting the required data from the response
      id = userData['id'];
      roleId = userData['role_id'];
      role = userData['role'];
      fullName = userData['fullname'];
      email = userData['email'] ?? '';
      mobile = userData['mobile'] ?? '';
      dob = userData['dob'];
      photo = userData['image'] ?? (userData['photo'] ?? '');
      genderId = userData['genderId'] ?? 1;
      gender = userData['gender'] ?? '';
      designation = userData['designation'] ?? '';
      zoom = userData['zoom'];
      is_administrator = userData['is_administrator'];
      user_type = userData['user_type'];
      token = userData['accessToken'];
      schoolUrl = FrontSeatApi.base;

      //saving data in local
      Utils.saveIntValue('id', id);
      Utils.saveIntValue('roleId', roleId);
      Utils.saveStringValue('rule', role);
      Utils.saveStringValue('fullname', fullName);
      Utils.saveStringValue('email', email);
      Utils.saveStringValue('mobile', mobile);
      Utils.saveStringValue('dob', dob);
      Utils.saveStringValue('image', photo);
      Utils.saveIntValue('genderId', genderId);
      Utils.saveStringValue('gender', gender);
      Utils.saveStringValue('designation', designation);
      Utils.saveIntValue('zoom', zoom);
      Utils.saveStringValue('isAdministrator', is_administrator);
      Utils.saveStringValue('user_type', user_type);
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
      controller.dob = dob;
      controller.photo = photo;
      controller.genderId = genderId;
      controller.gender = gender;
      controller.designation = designation;
      controller.zoom = zoom;
      controller.is_administrator = is_administrator;
      controller.user_type = user_type;
      controller.token = token;
      controller.isLogged = true;
      schoolUrl = FrontSeatApi.base;
      Utils.showToast('Successfully logged in');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const BottomBar()),
          (Route<dynamic> route) => route is BottomBar);
      _btnController.reset();
    } else {
      Utils.showToast('Incorrect Email or Password');
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }
}
