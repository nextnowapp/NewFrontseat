import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/Utils.dart';
import 'services/api_list.dart';
import '../../utils/widget/textwidget.dart';
import '../../utils/widget/txtbox.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController oldpasswordcontroller = TextEditingController();

  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  final RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const TextWidget(
                  txt: 'Reset Your Password',
                  size: 22,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 60),
                TxtField(
                  hint: 'Current Password',
                  controller: oldpasswordcontroller,
                  pass: obscure1,
                  icon: IconButton(
                      icon: Icon(
                        obscure1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      }),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password is required';
                    } else if (value.length < 8) {
                      return 'password must be at least 8 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TxtField(
                  hint: 'New Password',
                  controller: newpasswordcontroller,
                  pass: obscure2,
                  icon: IconButton(
                      icon: Icon(
                        obscure2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      }),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password is required';
                    } else if (value.length < 8) {
                      return 'password must be at least 8 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TxtField(
                  hint: 'Confirm Password',
                  controller: confirmpasswordcontroller,
                  pass: obscure3,
                  icon: IconButton(
                      icon: Icon(
                        obscure3 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscure3 = !obscure3;
                        });
                      }),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password is required';
                    } else if (value.length < 8) {
                      return 'password must be at least 8 characters';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Atleast one uppercase,lowercase,numeric and\nspecial character is required ';
                    } else if (value != newpasswordcontroller.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                    width: 100.w,
                    borderRadius: 5,
                    color: Colors.red,
                    controller: _btnController,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ResetPassword();
                      } else {
                        _btnController.reset();
                      }
                    },
                    child: const Text('Reset Password',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ResetPassword() async {
    var token = await Utils.getStringValue('token');
    var data = {
      'old_password': oldpasswordcontroller.text,
      'password': newpasswordcontroller.text,
      'password_confirmation': confirmpasswordcontroller.text
    };
    final response = await http.post(
      Uri.parse(FrontSeatApi.resetPass),
      headers: Utils.setHeader(token!),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      log(response.body);
      Utils.showToast('Password has been changed successfully');
      Navigator.pop(context);
      _btnController.reset();
    } else {
      _btnController.reset();
      log(response.body.toString());
      Utils.showErrorToast('Credentials does not match');
      throw Exception('Failed to load');
    }
  }
}
