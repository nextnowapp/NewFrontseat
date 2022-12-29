import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controller/kyc_step_model.dart';
import 'controller/upload_selfie_bloc.dart';

class UploadSelfieScreen extends StatelessWidget {
   UploadSelfieScreen({
    Key? key,
  }) : super(key: key);

  final kycStepModelController = Get.put(KycStepModel());
  String? profileDownloadUrl;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadSelfieBloc, UploadSelfieState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4 + 15,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(File(state.imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    PickedFile? file = await ImagePicker.platform.pickImage(
                      source: ImageSource.camera,
                      preferredCameraDevice: CameraDevice.front,
                      imageQuality: 80,
                    );
                    if (file != null) {
                      context
                          .read<UploadSelfieBloc>()
                          .add(PickImageEvent(image: file.path));
                    }
                  },
                  child: const Text('Retake',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () async {
                      context.read<UploadSelfieBloc>().add(UpdateSelfieEvent(
                          image: state.imagePath, context: context));
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('Upload Selfie',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
