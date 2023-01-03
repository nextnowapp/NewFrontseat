import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/widget/textwidget.dart';
import 'controller/upload_govt_id_bloc.dart';

class GovtIdUploadScreen extends StatefulWidget {
  const GovtIdUploadScreen({Key? key}) : super(key: key);

  @override
  State<GovtIdUploadScreen> createState() => _GovtIdUploadScreenState();
}

class _GovtIdUploadScreenState extends State<GovtIdUploadScreen> {
  final kycStepModelController = Get.put(KycStepModel());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String? drivingLicenseFrontImageUrl;
  String? drivingLicenseRearImageUrl;
  String? nidFrontImageUrl;
  String? nidRearImageUrl;

//function to upload image to firebase storage

  Future<void> _uploadImagefromCamera(String? type) async {
    PickedFile? file = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );
    if (type! == 'drivingLicenseFront') {
      setState(() {
        drivingLicenseFrontImageUrl = file!.path;
      });
    } else if (type == 'drivingLicenseRear') {
      setState(() {
        drivingLicenseRearImageUrl = file!.path;
      });
    } else if (type == 'nidFront') {
      setState(() {
        nidFrontImageUrl = file!.path;
      });
    } else if (type == 'nidRear') {
      setState(() {
        nidRearImageUrl = file!.path;
      });
    }
  }

  Future<void> _uploadImagefromGallery(String? type) async {
    PickedFile? file = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );
    if (type! == 'drivingLicenseFront') {
      setState(() {
        drivingLicenseFrontImageUrl = file!.path;
      });
    } else if (type == 'drivingLicenseRear') {
      setState(() {
        drivingLicenseRearImageUrl = file!.path;
      });
    } else if (type == 'nidFront') {
      setState(() {
        nidFrontImageUrl = file!.path;
      });
    } else if (type == 'nidRear') {
      setState(() {
        nidRearImageUrl = file!.path;
      });
    }
  }

  Future buildShowImagePickerModalBottomSheet(
      BuildContext context, String type) {
    return showModalBottomSheet(
        enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 0.3 * MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Utils.sizedBoxHeight(24),
                const Text(
                  'Upload From',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _uploadImagefromGallery(type);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/gallery.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _uploadImagefromCamera(type);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/camera.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  //upload image to firebase storage and user data to firebase firestore

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadGovtIdBloc, UploadGovtIdState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Document Verification',
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
              top: MediaQuery.of(context).padding.top,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Please upload your government ID to verify your identity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        txt: "Identity Document",
                        size: 18,
                        clr: Colors.red,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: InkWell(
                      onTap: () async {
                        buildShowImagePickerModalBottomSheet(
                            context, 'nidFront');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: nidFrontImageUrl != null
                            ? Image.file(File(nidFrontImageUrl!))
                            : const Icon(Icons.add,
                                size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const TextWidget(
                    txt: 'Identity documents (Front Photo)',
                    clr: Colors.grey,
                    size: 12,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: InkWell(
                      onTap: () async {
                        buildShowImagePickerModalBottomSheet(
                            context, 'nidRear');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: nidRearImageUrl != null
                            ? Image.file(File(nidRearImageUrl!))
                            : const Icon(Icons.add,
                                size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const TextWidget(
                    txt: 'Identity documents (Rear Photo) ',
                    clr: Colors.grey,
                    size: 12,
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        txt: "Driving Licence(Optional)",
                        size: 18,
                        clr: Colors.red,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: InkWell(
                      onTap: () async {
                        buildShowImagePickerModalBottomSheet(
                            context, 'drivingLicenseFront');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: drivingLicenseFrontImageUrl != null
                            ? Image.file(File(drivingLicenseFrontImageUrl!))
                            : const Icon(Icons.add,
                                size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const TextWidget(
                    txt: 'Driving Licence documents (Front Photo)',
                    clr: Colors.grey,
                    size: 12,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: InkWell(
                      onTap: () async {
                        buildShowImagePickerModalBottomSheet(
                            context, 'drivingLicenseRear');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: drivingLicenseRearImageUrl != null
                            ? Image.file(File(drivingLicenseRearImageUrl!))
                            : const Icon(Icons.add,
                                size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const TextWidget(
                    txt: 'Driving Licence documents (Rear Photo)',
                    clr: Colors.grey,
                    size: 12,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RoundedLoadingButton(
                            resetAfterDuration: true,
                            resetDuration: const Duration(seconds: 10),
                            width: 100.w,
                            borderRadius: 10,
                            color: Colors.red,
                            controller: _btnController,
                            onPressed: () {
                              if (nidFrontImageUrl != null &&
                                  nidRearImageUrl != null) {
                                context.read<UploadGovtIdBloc>().add(
                                    UploadGovtIdDocumentsEvent(
                                        idFront: nidFrontImageUrl!,
                                        idRear: nidRearImageUrl!,
                                        dlFront: drivingLicenseFrontImageUrl,
                                        dlRear: drivingLicenseRearImageUrl,
                                        context: context));
                              } else {
                                _btnController.reset();
                                Utils.showToast(
                                    'Please add all required documents');
                              }
                            },
                            child: const Text('Upload',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
