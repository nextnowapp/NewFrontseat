import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/widget/textwidget.dart';
import '../../../../utils/widget/txtbox.dart';
import '../../frontseat_constants.dart';
import '../../model/frontseat_user_detail_model.dart';
import 'controller/upload_bank_details_bloc.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key, this.data}) : super(key: key);
  final UserDetailModel? data;

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
  final TextEditingController bankNameController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String? _selectedBank;
  String? _selectedAccountType;
  String? _selectedAccHolderRelationship;

  String? bankStatementUrl;
  String? bankStatement;
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
    if (widget.data != null) {
      _selectedAccountType = widget.data!.data!.agentDetails!.accountType ?? '';
      _selectedAccHolderRelationship =
          widget.data!.data!.agentDetails!.accHolderRelationship ?? '';
      _selectedBank = widget.data!.data!.agentDetails!.bankName ?? '';
      bankAccountHolderNameController.text =
          widget.data!.data!.agentDetails!.bankAccountHolderName ?? '';
      bankAccountNumberController.text =
          widget.data!.data!.agentDetails!.bankAccountNumber ?? '';
      bankBranchNameController.text =
          widget.data!.data!.agentDetails!.bankBranchName ?? '';
      bankBranchCode.text =
          widget.data!.data!.agentDetails!.bankBranchCode ?? '';
      bankStatement = widget.data!.data!.agentDetails!.bankStatement ?? null;
      bankNameController.text = widget.data!.data!.agentDetails!.bankName ?? '';
      _selectedBank = widget.data!.data!.agentDetails!.bankName ?? '';
    }
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
                                    flex: 1, child: getAccountTypeDropdown()),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                    flex: 1,
                                    child: getAccountHolderRelationDropdown()),
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
                              hint: 'Account Number*',
                              controller: bankAccountNumberController,
                              type: TextInputType.number,
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
                              hint: 'Account Holder Name*',
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
                              hint: 'Branch Name',
                              controller: bankBranchNameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TxtField(
                              hint: 'Branch Code',
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
                                  txt: 'Proof of Bank account*',
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
                                    : widget.data != null && bankStatement != ''
                                        ? Image.network(bankStatement!)
                                        : const Icon(Icons.add,
                                            size: 100, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const TextWidget(
                              txt:
                                  'Proof of Bank account e.g. Statement with account details',
                              clr: Colors.black87,
                              size: 12,
                            ),
                            const SizedBox(height: 20),
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
                                  if (widget.data != null) {
                                    context.read<UploadBankDetailsBloc>().add(
                                        UploadBankDocumentsEvent(
                                            accountType: _selectedAccountType!,
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
                                            bankStatement: bankStatementUrl,
                                            context: context));
                                    kycStepModelController.isEditableValue =
                                        false;
                                    kycStepModelController
                                        .allStepsCompletedValue = true;
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      if (bankStatementUrl != null &&
                                          _selectedAccountType != null) {
                                        context
                                            .read<UploadBankDetailsBloc>()
                                            .add(UploadBankDocumentsEvent(
                                                accountType:
                                                    _selectedAccountType!,
                                                accountHolderRelation:
                                                    _selectedAccHolderRelationship!,
                                                bankName: _selectedBank!,
                                                branchName:
                                                    bankBranchNameController
                                                        .text,
                                                branchcode: bankBranchCode.text,
                                                accNumber:
                                                    bankAccountNumberController
                                                        .text,
                                                accountHolderName:
                                                    bankAccountHolderNameController
                                                        .text,
                                                bankStatement:
                                                    bankStatementUrl!,
                                                context: context));
                                      } else {
                                        _btnController.reset();
                                        Utils.showToast(
                                            'Please add all required data');
                                      }
                                    } else {
                                      _btnController.reset();
                                    }
                                  }
                                },
                                child: const Text('Upload',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 300,
                      )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Name*',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        SearchField<String>(
          controller: bankNameController,
          autoCorrect: true,
          suggestions:
              bankList.map((e) => SearchFieldListItem(e, item: e)).toList(),
          suggestionState: Suggestion.expand,
          //hasOverlay: false,
          searchStyle: const TextStyle(fontSize: 16, color: Colors.black),
          validator: (x) {
            if (x == null || x.isEmpty || !bankList.map((e) => e).contains(x)) {
              return 'Bank is required';
            }
            return null;
          },
          searchInputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: const Icon(Icons.search),
            fillColor: HexColor('#5374ff'),
            errorStyle: TextStyle(
              fontSize: 8.sp,
              color: HexColor('#de5151'),
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            hintStyle: TextStyle(
              color: HexColor('#8e9aa6'),
              fontSize: 12.sp,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#d5dce0'),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#5374ff'),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
          ),
          onSuggestionTap: (x) {
            setState(() {
              _selectedBank = x.item!;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
          maxSuggestionsInViewPort: 6,
          itemHeight: 50,
        ),
      ],
    );
  }

  Widget getAccountTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type*',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Account Type is required';
            }
            return null;
          },
          // showSelectedItems: true,
          items: accountType,

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },

          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (3 * 42.sp) < 170.sp ? (3 * 42.sp) : 170.sp,
            ),
          ),
          dropdownDecoratorProps: dropdownDecoratorProps,
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedAccountType = newValue;
            });
          },
          selectedItem: _selectedAccountType,
        ),
      ],
    );
  }

  Widget getAccountHolderRelationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acc Holder Relationship*',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Acc Holder Relationship is required';
            }
            return null;
          },
          // showSelectedItems: true,
          items: accHolderRelationship,

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },

          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (3 * 42.sp) < 170.sp ? (3 * 42.sp) : 170.sp,
            ),
          ),
          dropdownDecoratorProps: dropdownDecoratorProps,
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedAccHolderRelationship = newValue;
            });
          },
          selectedItem: _selectedAccHolderRelationship,
        ),
      ],
    );
  }
}
