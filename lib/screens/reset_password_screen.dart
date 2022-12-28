import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../utils/widget/textwidget.dart';
import '../utils/widget/txtbox.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const TextWidget(
                  txt: 'Reset your Password',
                  size: 22,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 30),
                const TextWidget(
                  txt: 'Enter the email \n address linked to your \n account.',
                  size: 18,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TxtField(
                  hint: 'Email address',
                  controller: controller,
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
                    color: HexColor('#3fb18f'),
                    controller: _btnController,
                    onPressed: () {},
                    child: const Text('Send link',
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
}
