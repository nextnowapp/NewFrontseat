import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/contract_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_signature/signature_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/verify_email_screen.dart';
import 'package:nextschool/screens/frontseat/change_password_screen.dart';
import 'package:nextschool/screens/frontseat/status_page/widgets/detail_card.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../services/kyc_api.dart';
import '../model/frontseat_user_detail_model.dart';
import '../../../utils/widget/DetailFields.dart';
import '../../../utils/widget/textwidget.dart';
import '../agent_onboarding/form_resubmission_page.dart';
import '../agent_onboarding/submitted_for_verification.dart';
import '../agent_onboarding/verify_account.dart';
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
  bool? mobileVerified;
  bool? uploadDocuments;
  bool? emailVerified;
  String? status;
  var image;
  var id;

  @override
  void initState() {
    setState(() {
      userdata = KycApi.getUserDetails();
      KycApi.AgentStatus();
    });

    super.initState();
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const LinearProgressIndicator(),
                          ],
                        ),
                      );
                    }
                    if (snapshot.data != null) {
                      var data = snapshot.data!.data!.agentDetails!;
                      mobile = data.mobile;
                      firstName = data.fullName ?? '';
                      email = data.email;
                      emailVerified = data.emailVerifiedAt;
                      mobileVerified = data.mobileVerified;
                      uploadDocuments = data.bankingDocument;
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
                                        title: 'Full Name : ',
                                        value: firstName ?? ''),
                                    // Visibility(
                                    //   visible: lastName != null &&
                                    //       lastName != '',
                                    //   child: DetailFields(
                                    //       title: 'Last Name : ',
                                    //       value: lastName ?? ''),
                                    // ),
                                    DetailFields(
                                        title: 'Phone Number : ',
                                        value: mobile ?? ''),
                                    DetailFields(
                                        title: 'Email :', value: email ?? ''),
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
                                      builder: (context) => ContractScreen(),
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
                            DetailCard(
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
                                      builder: (context) => ResetPassword(),
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
