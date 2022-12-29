import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/submitted_for_verification.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_bank_details/bank_details_page.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_govt_id/govt_id_details.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_personal_information/onboard_personal_data_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_selfie/upload_selfie_help_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with WidgetsBindingObserver {
  final kycStepModelController = Get.put(KycStepModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Agent Onboarding',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //form to get details like, first name, last name, email, phone number, profile picture, address, etc.

                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'We need to verify your identity to onboard you to the app as an Agent.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!kycStepModelController.selfieUpdatedValue) {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UploadSelfieHelpScreen()));
                        }
                      },
                      child: SizedBox(
                        height: 70,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/face-recognition.svg',
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Take a Selfie',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Icon(
                                    kycStepModelController.selfieUpdatedValue
                                        ? Icons.check
                                        : Icons.arrow_forward_ios,
                                    size: 20,
                                    color: kycStepModelController
                                            .selfieUpdatedValue
                                        ? Colors.green
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!kycStepModelController
                                .personalInformationUpdatedValue &&
                            kycStepModelController.selfieUpdatedValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OnboardPersonalInformation()));
                        }
                      },
                      child: SizedBox(
                        height: 70,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/face-recognition.svg',
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Icon(
                                    kycStepModelController
                                            .personalInformationUpdatedValue
                                        ? Icons.check
                                        : (kycStepModelController
                                                .selfieUpdatedValue)
                                            ? Icons.arrow_forward_ios
                                            : null,
                                    size: 20,
                                    color: kycStepModelController
                                            .personalInformationUpdatedValue
                                        ? Colors.green
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    GestureDetector(
                      onTap: () {
                        if (!kycStepModelController.govtIdUploadedValue &&
                            kycStepModelController.selfieUpdatedValue &&
                            kycStepModelController
                                .personalInformationUpdatedValue) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GovtIdDetails()));
                        }
                      },
                      child: SizedBox(
                        height: 70,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/face-recognition.svg',
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Documents',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Icon(
                                    kycStepModelController.govtIdUploadedValue
                                        ? Icons.check
                                        : (kycStepModelController
                                                    .selfieUpdatedValue &&
                                                kycStepModelController
                                                    .personalInformationUpdatedValue)
                                            ? Icons.arrow_forward_ios
                                            : null,
                                    size: 20,
                                    color: kycStepModelController
                                            .govtIdUploadedValue
                                        ? Colors.green
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!kycStepModelController.bankDetailsValue &&
                            kycStepModelController.selfieUpdatedValue &&
                            kycStepModelController
                                .personalInformationUpdatedValue &&
                            kycStepModelController.govtIdUploadedValue) {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BankDetails()));
                        }
                      },
                      child: SizedBox(
                        height: 70,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/face-recognition.svg',
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Bank Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Icon(
                                    kycStepModelController.bankDetailsValue
                                        ? Icons.check
                                        : (kycStepModelController
                                                    .selfieUpdatedValue &&
                                                kycStepModelController
                                                    .personalInformationUpdatedValue &&
                                                kycStepModelController
                                                    .govtIdUploadedValue)
                                            ? Icons.arrow_forward_ios
                                            : null,
                                    size: 20,
                                    color:
                                        kycStepModelController.bankDetailsValue
                                            ? Colors.green
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 200,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'You accept consent to our ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse("https://schoolmanagement.co.za/terms"));
                    },
                    child: const Text(
                      'privacy ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.blue),
                    ),
                  ),
                  const Text(
                    "and",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse("https://schoolmanagement.co.za/privacy"));
                    },
                    child: const Text(
                      ' data policy.',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Obx(
                () => TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kycStepModelController.bankDetailsValue
                          ? Colors.red
                          : Colors.grey),
                  onPressed: () async {
                    if (kycStepModelController.bankDetailsValue) {
                      kycStepModelController.allStepsCompleted(true);
                       Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubmittedForVerificationScreen()));
                      Utils.showToast('Application Submitted Successfully');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Submit for Review',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
