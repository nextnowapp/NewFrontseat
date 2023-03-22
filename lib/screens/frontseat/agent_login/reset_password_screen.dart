import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../services/api_list.dart';
import '../../../utils/widget/textwidget.dart';
import '../../../utils/widget/txtbox.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController phonecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
                const SizedBox(height: 60),
                const TextWidget(
                  txt: 'Forgot Password',
                  size: 22,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 50),
                TxtField(
                  hint: 'Registered Mobile No.*',
                  controller: phonecontroller,
                  formatter: [
                    LengthLimitingTextInputFormatter(10),
                    //digits only
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  type: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone Number is required';
                    } else if (value.length != 10 || value[0] != '0') {
                      return 'Phone number should be 10 digits starting with 0';
                    }
                    return null;
                  },
                ),
                TxtField(
                  hint: 'Registered Email Address*',
                  controller: emailcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter the email address';
                    } else if (!(value.contains('@'))) {
                      return 'Please enter valid email';
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
                        forgotPassword();
                      } else {
                        _btnController.reset();
                      }
                    },
                    child: const Text('Send Password',
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

  forgotPassword() async {
    var data = {
      'phone': phonecontroller.text,
      'email': emailcontroller.text,
    };
    final response = await http.post(
      Uri.parse(FrontSeatApi.forgotPass),
      body: data,
    );
    if (response.statusCode == 200) {
      log(response.body);
      Utils.showToast(
          'password has been sent to your registered mobile no.');
      Navigator.pop(context);
      _btnController.reset();
    } else {
      _btnController.reset();
      Utils.showErrorToast('Invalid Credentials');
      throw Exception('Failed to load');
    }
  }
}
