import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';

class TerminationScreen extends StatefulWidget {
const TerminationScreen({Key? key}) : super(key: key);

  @override
  State<TerminationScreen> createState() => _TerminationScreenState();
}

class _TerminationScreenState extends State<TerminationScreen> {
  bool aceeptFirstAgreement = false;
  bool aceeptSecondAgreement = false;
  bool aceeptThirdAgreement = false;
  final kycStepModelController = Get.put(KycStepModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Termination',
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
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to terminate your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[900],
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(aceeptFirstAgreement
                        ? Icons.check_circle
                        : Icons.circle_outlined),
                    color: aceeptFirstAgreement ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(() {
                        aceeptFirstAgreement = !aceeptFirstAgreement;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: Text(
                      'By Agreeing to the Terms of Service, you agree to our Privacy Policy and acknowledge that you have read our Terms of Service.',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(aceeptSecondAgreement
                        ? Icons.check_circle
                        : Icons.circle_outlined),
                    color: aceeptSecondAgreement ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(() {
                        aceeptSecondAgreement = !aceeptSecondAgreement;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: Text(
                      'By Agreeing to the Terms of Service, you agree to our Privacy Policy and acknowledge that you have read our Terms of Service.',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(aceeptThirdAgreement
                        ? Icons.check_circle
                        : Icons.circle_outlined),
                    color: aceeptThirdAgreement ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(() {
                        aceeptThirdAgreement = !aceeptThirdAgreement;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: Text(
                      'By Agreeing to the Terms of Service, you agree to our Privacy Policy and acknowledge that you have read our Terms of Service.',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red),
                onPressed: () async {
                  if (aceeptFirstAgreement &&
                      aceeptSecondAgreement &&
                      aceeptThirdAgreement) {
                    Utils.clearAllValue();

                    kycStepModelController.allStepsCompletedValue = false;
                    kycStepModelController.bankDetailsValue = false;
                    kycStepModelController.govtIdUploadedValue = false;
                    kycStepModelController.personalInformationUpdatedValue =
                        false;
                    kycStepModelController.selfieUpdatedValue = false;
                    kycStepModelController.isEditableValue = false;
                    kycStepModelController.inContractingValue = false;
                    kycStepModelController.contractedValue = false;
                    kycStepModelController.commentValue = "";

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Your request is under process'),
                    ));
                    Utils.clearAllValue();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const LandingScreen()));
                  } else {
                    print("hey");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Terminate my account',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
