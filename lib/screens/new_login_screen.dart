import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/new_register_screen.dart';
import 'package:nextschool/screens/reset_password_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/widget/textwidget.dart';
import '../utils/widget/txtbox.dart';

class LoginNextschool extends StatefulWidget {
  LoginNextschool({Key? key}) : super(key: key);

  @override
  State<LoginNextschool> createState() => _LoginNextschoolState();
}

class _LoginNextschoolState extends State<LoginNextschool> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscure = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                            } else if (value.length < 8) {
                              return 'password must be at least 8 characters';
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
                                child:
                                    const TextWidget(txt: 'Forgot password?'))
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
                        await launchUrl(
                            Uri.parse('https://schoolmanagement.co.za/terms'));
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
                      color: HexColor('#3fb18f'),
                      controller: _btnController,
                      onPressed: () {},
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NewRegisterScreen()));
                        },
                        child: Text('Apply here',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: HexColor('#3fb18f'),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
