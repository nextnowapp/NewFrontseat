import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/contract_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_signature/signature_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/verify_email_screen.dart';
import 'package:nextschool/screens/frontseat/change_password_screen.dart';
import 'package:nextschool/screens/frontseat/status_page/widgets/detail_card.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/widget/DetailFields.dart';
import '../../../utils/widget/textwidget.dart';
import '../agent_onboarding/form_resubmission_page.dart';
import '../agent_onboarding/submitted_for_verification.dart';
import '../agent_onboarding/verify_account.dart';
import '../model/frontseat_user_detail_model.dart';
import '../services/kyc_api.dart';
import '../widgets/custom_appbar.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({Key? key}) : super(key: key);
  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  final kycStepModelController = Get.put(KycStepModel());
  Future<UserDetailModel?>? userdata;
  String? mobile;
  String? firstName;
  String? lastName;
  String? email;
  String? agentCode;
  String? mtnNo;
  String? otpCode;
  bool? mobileVerified;
  bool? uploadDocuments;
  bool? emailVerified;
  String? status;
  var image;
  var id;

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    setState(() {
      userdata = KycApi.getUserDetails();
      KycApi.AgentStatus();
    });

    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: CustomAppbar(
          title: 'Status',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: userdata,
                  builder: (context, AsyncSnapshot<UserDetailModel?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: 90.h,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    if (snapshot.data != null) {
                      var data = snapshot.data!.data!.agentDetails!;
                      mobile = data.mobile;
                      firstName = data.fullName ?? '';
                      email = data.email;

                      emailVerified = data.emailVerifiedAt;
                      mobileVerified = data.mobileVerified;
                      uploadDocuments = data.bankingDocument;
                      agentCode = data.agentCode;
                      mtnNo = data.mtnNo;
                      status = data.agentStatus;
                    }
                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          shadowColor: Colors.grey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                color: const Color(0xffe3e3e3),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextWidget(
                                      txt: 'Login Profile Details',
                                      clr: Colors.black,
                                      size: 18,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, bottom: 20),
                                child: Column(
                                  children: [
                                    DetailFields(
                                        title: 'Full Name: ',
                                        value: firstName ?? ''),
                                    DetailFields(
                                        title: 'Phone Number: ',
                                        value: mobile ?? ''),
                                    DetailFields(
                                        title: 'Email:', value: email ?? ''),
                                    DetailFields(
                                        title: 'MTN Mobile No:',
                                        value: mtnNo ?? ''),
                                    DetailFields(
                                        title: 'Agent Code:',
                                        value: agentCode ?? ''),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Utils.sizedBoxHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DetailCard(
                              scale: .8,
                              asset: 'assets/images/upload documents.png',
                              title: 'Upload',
                              title2: 'Documents',
                              buttonColor: uploadDocuments == true
                                  ? const Color(0xffd6ecdf)
                                  : const Color(0xffffd7d7),
                              buttonText:
                                  uploadDocuments == true ? 'Done' : 'Pending',
                              buttonIcon: uploadDocuments == true
                                  ? Icons.check_circle
                                  : Icons.alarm,
                              buttonWidgetColor: uploadDocuments == true
                                  ? const Color(0xff40a366)
                                  : const Color(0xfffb6869),
                            ),
                            InkWell(
                              onTap: () {
                                if (kycStepModelController.pdfReadyValue) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const ContractScreen(),
                                    ),
                                  );
                                } else if (kycStepModelController
                                        .allStepsCompletedValue &&
                                    kycStepModelController.inContractingValue &&
                                    kycStepModelController.contractedValue) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const SubmittedForVerificationScreen(),
                                    ),
                                  );
                                } else if (kycStepModelController
                                        .allStepsCompletedValue &&
                                    kycStepModelController.inContractingValue) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            SignatureScreen()),
                                  );
                                } else if (kycStepModelController
                                    .isEditableValue) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const FormReSubmissionScreen(),
                                    ),
                                  );
                                } else if (kycStepModelController
                                    .allStepsCompletedValue) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const SubmittedForVerificationScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const VerificationScreen(),
                                    ),
                                  );
                                }
                              },
                              child: DetailCard(
                                scale: .8,
                                asset: 'assets/images/application status.png',
                                title: 'Application',
                                title2: 'Status',
                                buttonColor: status == 'Active'
                                    ? const Color(0xffd6ecdf)
                                    : status == 'Submitted'
                                        ? const Color.fromARGB(
                                            228, 255, 220, 114)
                                        : const Color(0xffffd7d7),
                                buttonText: status == null
                                    ? 'Incomplete'
                                    : snapshot.hasData && status == 'new' ||
                                            status == 'pending' ||
                                            status == 'deactive'
                                        ? 'Pending Review'
                                        : status != null
                                            ? status!
                                            : 'Pending',
                                buttonIcon: status == 'Active'
                                    ? Icons.check_circle
                                    : Icons.alarm,
                                buttonWidgetColor: status == 'Active'
                                    ? const Color(0xff40a366)
                                    : status == 'Submitted'
                                        ? const Color.fromARGB(255, 200, 150, 0)
                                        : const Color(0xfffb6869),
                              ),
                            ),
                          ],
                        ),
                        Utils.sizedBoxHeight(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                emailVerified == true
                                    ? null
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VerifyEmailScreen(),
                                        ));
                              },
                              child: DetailCard(
                                scale: .8,
                                asset: 'assets/images/email verification.png',
                                title: 'Email',
                                title2: 'Verification',
                                buttonColor: emailVerified == true
                                    ? const Color(0xffd6ecdf)
                                    : const Color(0xffffd7d7),
                                buttonText:
                                    emailVerified == true ? 'Done' : 'Pending',
                                buttonIcon: emailVerified == true
                                    ? Icons.check_circle
                                    : Icons.alarm,
                                buttonWidgetColor: emailVerified == true
                                    ? const Color(0xff40a366)
                                    : const Color(0xfffb6869),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (mobileVerified == false) {
                                  KycApi.getOtp();

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor: Colors.white,
                                          insetPadding:
                                              const EdgeInsets.all(10),
                                          title: TextWidget(
                                            txt:
                                                'We have sent an OTP to ${mobile} , please check and verify',
                                            size: 17,
                                          ),
                                          content: PinFieldAutoFill(
                                            currentCode: otpCode,
                                            decoration: BoxLooseDecoration(
                                                radius:
                                                    const Radius.circular(10),
                                                strokeColorBuilder:
                                                    const FixedColorBuilder(
                                                        Colors.black)),
                                            codeLength: 6,
                                            onCodeChanged: (code) async {
                                              print('OnCodeChanged : $code');
                                            },
                                            onCodeSubmitted: (val) async {
                                              log(val.toString());
                                              var body = {
                                                'verification_code': val,
                                              };
                                              await KycApi.mobileVerified(
                                                  body, context);
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                                child: const TextWidget(
                                                    txt: 'Skip'),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      });
                                }
                              },
                              child: DetailCard(
                                scale: .58,
                                asset: 'assets/images/phone verification.png',
                                title: 'Phone',
                                title2: 'Verification',
                                buttonColor: mobileVerified == true
                                    ? const Color(0xffd6ecdf)
                                    : const Color(0xffffd7d7),
                                buttonText:
                                    mobileVerified == true ? 'Done' : 'Pending',
                                buttonIcon: mobileVerified == true
                                    ? Icons.check_circle
                                    : Icons.alarm,
                                buttonWidgetColor: mobileVerified == true
                                    ? const Color(0xff40a366)
                                    : const Color(0xfffb6869),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPassword(),
                                    ));
                              },
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
