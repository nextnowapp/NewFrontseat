import 'package:flutter/material.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/submitted_for_verification.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../model/frontseat_user_detail_model.dart';
import '../../../../../utils/widget/textwidget.dart';

class AgentDetailsVerificationScreen extends StatelessWidget {
  AgentDetailsVerificationScreen({required this.data, Key? key})
      : super(key: key);
  final AgentDetails data;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              txt: 'Verify your Details',
              size: 14.sp,
              weight: FontWeight.w600,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, top: 10, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetailRow(title: 'First Name', value: data.firstName ?? ''),
                    DetailRow(
                        title: 'Middle Name', value: data.middleName ?? ''),
                    DetailRow(title: 'Last Name', value: data.lastName ?? ''),
                    DetailRow(
                        title: 'E-mail', value: data.applicationEmail ?? ''),
                    DetailRow(
                        title: 'Phone No', value: data.applicationPhone ?? ''),
                    DetailRow(
                        title: 'Bank Account No.',
                        value: data.bankAccountNumber ?? ''),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RoundedLoadingButton(
                            resetAfterDuration: true,
                            resetDuration: const Duration(seconds: 10),
                            width: 100.w,
                            borderRadius: 10,
                            color: Colors.red,
                            controller: _btnController,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SubmittedForVerificationScreen()),
                              );
                            },
                            child: const Text('Verify',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class DetailRow extends StatelessWidget {
  DetailRow({Key? key, required this.title, required this.value})
      : super(key: key);
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: TextWidget(
                  txt: title,
                  weight: FontWeight.w600,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: TextWidget(
                  txt: value,
                  weight: FontWeight.w600,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
