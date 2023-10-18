import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_bank_details/bank_details_page.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/verify_account.dart';
import 'package:nextschool/screens/frontseat/services/api_list.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';

class BankConfirmation extends StatefulWidget {
  const BankConfirmation({Key? key}) : super(key: key);

  @override
  State<BankConfirmation> createState() => _BankConfirmationState();
}

class _BankConfirmationState extends State<BankConfirmation> {
  bool hasBank = true;
  bool needAssist = false;
  UserDetailsController controller = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bank Details'),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: 95.w,
              height: 40.h,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: hasBank,
                    child: Column(
                      children: [
                        TextWidget(
                          txt: 'Do you have a Bank Account?',
                          size: 16.sp,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor('ED2029')),
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BankDetails(),
                                    ));
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor('ED2029')),
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'No!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  hasBank = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: hasBank == false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          txt: 'Do you need Assist in creating a new account?',
                          size: 16.sp,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor('ED2029')),
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                needAssist = true;
                                onSubmit();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor('ED2029')),
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'No!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                      ).fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                needAssist = true;
                                onSubmit();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BankDetails(),
                                ));
                          },
                          child: const Text(
                            'Already have an account',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> onSubmit() async {
    Utils.showProcessingToast();
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      'onboarding_steps': 5,
      'user_id': controller.id,
      'bank_available': 0,
      'need_bank': needAssist ? 1 : 0,
      'banking_document': true,
    });
    var response =
        await dio.post(FrontSeatApi.onboardAgent, data: data).catchError((e) {
      log(e.toString());
      Utils.showToast('Something went wrong');
      return e;
    });

    //if response is successful
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      Utils.showToast('Request Submitted');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const VerificationScreen()));
      log(response.data.toString());
    }
  }
}
