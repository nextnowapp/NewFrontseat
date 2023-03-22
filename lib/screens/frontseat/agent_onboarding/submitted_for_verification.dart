import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/kyc_step_model.dart';
import '../nav_bar.dart';


class SubmittedForVerificationScreen extends StatelessWidget {
  const SubmittedForVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kycStepModelController = Get.put(KycStepModel());
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kycStepModelController.inContractingValue ||
                    kycStepModelController.contractedValue
                ? const Text(
                    'Signature Submitted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : const Text(
                    'Application Submitted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
            kycStepModelController.inContractingValue ||
                    kycStepModelController.contractedValue
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Text(
                      'Your signature has been submitted for contract. We will notify you once the contract is ready.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Text(
                      'Your application has been submitted for review. We will notify you once it has been approved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const BottomBar(
                              index: 1,
                            ))));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('View Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
