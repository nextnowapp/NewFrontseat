import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_personal_information/onboard_personal_data_screen.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../services/kyc_api.dart';
import '../../../utils/widget/textwidget.dart';

class FormReSubmissionScreen extends StatefulWidget {
  const FormReSubmissionScreen({Key? key}) : super(key: key);

  @override
  State<FormReSubmissionScreen> createState() => _FormReSubmissionScreenState();
}

class _FormReSubmissionScreenState extends State<FormReSubmissionScreen> {
  var id;
  @override
  Widget build(BuildContext context) {
    final KycStepModelController = Get.put(KycStepModel());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Verify your Identity',
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
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Application Rejected',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text(
                  KycStepModelController.rejectedValue
                      ? "Your application is rejected permanently, so you can't resubmit again"
                      : 'Your application has been rejected , Please resubmit the application',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              KycStepModelController.rejectedValue
                  ? const SizedBox()
                  : TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red),
                      onPressed: () async {
                        Utils.showProcessingToast();
                        final data = await KycApi.getUserDetails();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    OnboardPersonalInformation(data: data)));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextWidget(txt: 'Re-Submit'),
                      ),
                    ),
              const SizedBox(
                height: 50,
              ),
              Visibility(
                visible: KycStepModelController.commentValue.trim() != null,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          txt: 'Comment :-',
                          weight: FontWeight.bold,
                          size: 16,
                          clr: Colors.black54,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextWidget(
                          txt: KycStepModelController.commentValue,
                          clr: Colors.black54,
                        ),
                        const TextWidget(
                          txt: 'Reviewed by :-',
                          weight: FontWeight.bold,
                          size: 16,
                          clr: Colors.black54,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextWidget(
                          txt: KycStepModelController.reviewerValue,
                          clr: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
