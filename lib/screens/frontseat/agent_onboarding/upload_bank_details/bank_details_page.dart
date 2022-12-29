import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/frontseat_constants.dart';
import '../../../../utils/widget/textwidget.dart';
import '../../../../utils/widget/txtbox.dart';
import 'controller/upload_bank_details_bloc.dart';


class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  var id;

  final TextEditingController bankBranchNameController =
      TextEditingController();
  final TextEditingController bankBranchCode = TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();
  final TextEditingController bankAccountHolderNameController =
      TextEditingController();
  String? _selectedBank;
  String? _selectedAccountType;
  String? _selectedAccHolderRelationship;

  String? bankStatementUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _uploadImagefromCamera(String? type) async {
    PickedFile? file = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );
    if (type == 'bankStatement') {
      setState(() {
        bankStatementUrl = file!.path;
      });
    }
  }

  Future<void> _uploadImagefromGallery(String? type) async {
    PickedFile? file = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );
    if (type == 'bankStatement') {
      setState(() {
        bankStatementUrl = file!.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.getIntValue('id').then((value) {
      setState(() {
        id = value;
      });
    });
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

  final kycStepModelController = Get.put(KycStepModel());

  //upload image to firebase storage and user data to firebase firestore

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: BlocBuilder<UploadBankDetailsBloc, UploadBankDetailsState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Bank Details',
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Please provide your Bank Account Details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Type of Account',
                                          label: const Text('Account Type'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: _selectedAccountType == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedAccountType,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedAccountType = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items:
                                              accountType.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }, validator: (value) {
                                    if (value == null) {
                                      return "This Field is required";
                                    }
                                    return null;
                                  }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText:
                                              'Account holder Relationship',
                                          label: const Text(
                                              'Acc Holder Relationship'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty:
                                          _selectedAccHolderRelationship == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedAccHolderRelationship,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedAccHolderRelationship =
                                                  newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items: accHolderRelationship
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }, validator: (value) {
                                    if (value == null) {
                                      return "This Field is required";
                                    }
                                    return null;
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            getBankDropDown(banks),
                            const SizedBox(
                              height: 20,
                            ),
                            TxtField(
                              hint: 'Account Number',
                              controller: bankAccountNumberController,
                              formatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Account Number is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TxtField(
                              hint: 'Account Holder Name',
                              controller: bankAccountHolderNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Account Holder Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TxtField(
                              hint: 'Branch Name (optional)',
                              controller: bankBranchNameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TxtField(
                              hint: 'Branch Code (optional)',
                              controller: bankBranchCode,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                  txt: "Proof of Bank account",
                                  size: 18,
                                  clr: Colors.red,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                // await _uploadImage('bankStatement');
                                buildShowImagePickerModalBottomSheet(
                                    context, 'bankStatement');
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
                                child: bankStatementUrl != null
                                    ? Image.file(File(bankStatementUrl!))
                                    : const Icon(Icons.add,
                                        size: 100, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const TextWidget(
                              txt:
                                  'Proof of Bank account e.g. Statement with account details',
                              clr: Colors.grey,
                              size: 12,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (bankStatementUrl != null &&
                                        _selectedAccountType != null) {
                                      context.read<UploadBankDetailsBloc>().add(
                                          UploadBankDocumentsEvent(
                                              accountType:
                                                  _selectedAccountType!,
                                              accountHolderRelation:
                                                  _selectedAccHolderRelationship!,
                                              bankName: _selectedBank!,
                                              branchName:
                                                  bankBranchNameController.text,
                                              branchcode: bankBranchCode.text,
                                              accNumber:
                                                  bankAccountNumberController
                                                      .text,
                                              accountHolderName:
                                                  bankAccountHolderNameController
                                                      .text,
                                              bankStatement: bankStatementUrl!,
                                              context: context));
                                    } else {
                                      Utils.showToast(
                                          'Please add all required data');
                                    }
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text('Upload',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
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
            ),
          );
        },
      ),
    );
  }

  Widget getBankDropDown(List<String> bankList) {
    return SearchField<String>(
      autoCorrect: true,
      suggestions:
          bankList.map((e) => SearchFieldListItem(e, item: e)).toList(),
      suggestionState: Suggestion.expand,
      hint: 'Bank name',
      hasOverlay: false,
      searchStyle: const TextStyle(fontSize: 16, color: Colors.black),
      validator: (x) {
        if (x == null || x.isEmpty || !bankList.map((e) => e).contains(x)) {
          return 'Please select a bank';
        }
        return null;
      },
      searchInputDecoration: InputDecoration(
          labelText: "Bank Name",
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey, width: 1.2),
          ),
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: const Icon(Icons.search)),
      onSuggestionTap: (x) {
        setState(() {
          _selectedBank = x.item!;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      },
      maxSuggestionsInViewPort: 6,
      itemHeight: 50,
    );
  }
}
