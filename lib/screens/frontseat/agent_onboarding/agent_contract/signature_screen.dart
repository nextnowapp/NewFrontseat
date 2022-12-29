import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/contract_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/widget/textwidget.dart';
import 'controller/contract_bloc.dart';


class SignatureScreen extends StatelessWidget {
  SignatureScreen({Key? key}) : super(key: key);
  final SignatureController signatureController = SignatureController();
  var image;

  @override
  Widget build(BuildContext context) {
    final kycStepModelController = Get.put(KycStepModel());
    return BlocBuilder<ContractBloc, ContractState>(
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
            child: Column(
              children: [
                Utils.sizedBoxHeight(30),
                const TextWidget(
                  txt: "Sign to complete",
                  weight: FontWeight.bold,
                  size: 19,
                ),
                Utils.sizedBoxHeight(30),
                const TextWidget(
                  txt: "Draw your signature below",
                  weight: FontWeight.w500,
                  size: 15,
                ),
                Utils.sizedBoxHeight(20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      color: Colors.red,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: Signature(
                          controller: signatureController,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ),
                ),
                Utils.sizedBoxHeight(20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.red)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        signatureController.clear();
                      },
                      child: const TextWidget(
                        txt: "Clear Signature",
                        weight: FontWeight.w500,
                        clr: Colors.red,
                      )),
                ),
                Utils.sizedBoxHeight(20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ))),
                      onPressed: () async {
                        context.read<ContractBloc>().add(
                            SignatureEvent(controller: signatureController));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContractScreen(
                                      signed: true,
                                    )));
                      },
                      child: const TextWidget(
                        txt: "Save Signature & Continue",
                        weight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
