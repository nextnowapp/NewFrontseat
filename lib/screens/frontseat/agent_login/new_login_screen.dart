import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nextschool/screens/frontseat/agent_login/controller/login_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_login/reset_password_screen.dart';
import 'package:nextschool/screens/frontseat/agent_register/new_register_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/widget/textwidget.dart';
import '../../../utils/widget/txtbox.dart';

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

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  return 'Email is required';
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
                                    return 'Password is required';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  } else if (!regExp.hasMatch(value)) {
                                    return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                                  }
                                  return null;
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: const TextWidget(
                                        txt: 'Forgot password?'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
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
                          controller: btnController,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginUserEvent(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  buttonController: btnController));
                            } else {
                              btnController.reset();
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
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18),
                      child: Row(
                        children: [
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
                    Row(
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
                  ],
                ),
              ),
            ));
      },
    );
  }
}
