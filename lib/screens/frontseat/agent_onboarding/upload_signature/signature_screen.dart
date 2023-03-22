import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_signature/controller/signature_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:signature/signature.dart' hide SignatureState;
import 'package:sizer/sizer.dart';

import '../../../../../controller/kyc_step_model.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/widget/textwidget.dart';
import '../../../../../utils/widget/txtbox.dart';

class SignatureScreen extends StatefulWidget {
  SignatureScreen({Key? key}) : super(key: key);
  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController signatureController = SignatureController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var image;

  @override
  Widget build(BuildContext context) {
    final kycStepModelController = Get.put(KycStepModel());
    return BlocBuilder<SignatureBloc, SignatureState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Signing Contract',
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TxtField(
                        hint: 'Signature Location*',
                        controller: locationController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Signature location is required';
                          }
                          return null;
                        },
                      ),
                      Utils.sizedBoxHeight(30),
                      Row(
                        children: [
                          const TextWidget(
                            txt: 'Draw your signature below',
                            weight: FontWeight.w500,
                            size: 15,
                          ),
                        ],
                      ),
                      Utils.sizedBoxHeight(0.5.h),
                      Center(
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          color: Colors.red,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Signature(
                                  controller: signatureController,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          signatureController.undo();
                                        },
                                        icon: const Icon(
                                          Icons.undo,
                                          color: Colors.black54,
                                          size: 22,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          signatureController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.black54,
                                          size: 22,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Utils.sizedBoxHeight(20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(state.confirmDate
                                  ? Icons.check_circle
                                  : Icons.circle_outlined),
                              color: state.confirmDate
                                  ? Colors.green
                                  : Colors.grey,
                              onPressed: () {
                                context
                                    .read<SignatureBloc>()
                                    .add(ConfirmDateEvent());
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'I confirm the signature was added on ${parseDate()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Utils.sizedBoxHeight(20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: RoundedLoadingButton(
                          resetAfterDuration: true,
                          resetDuration: const Duration(seconds: 10),
                          width: 100.w,
                          borderRadius: 10,
                          color: Colors.red,
                          controller: _btnController,
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                state.confirmDate == true &&
                                signatureController.isNotEmpty) {
                              context.read<SignatureBloc>().add(SubmitDataEvent(
                                  location: locationController.text,
                                  controller: signatureController,
                                  date: parseDate(),
                                  context: context));
                            } else {
                              _btnController.reset();
                              Utils.showErrorToast(
                                  'Add every details to continue');
                            }
                          },
                          child: const Text('Next',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String parseDate() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return formattedDate;
  }
}
