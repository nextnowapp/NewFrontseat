import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/frontseat_constants.dart';
import '../../../../utils/model/frontseat_user_detail_model.dart';
import '../../../../utils/widget/txtbox.dart';
import 'controller/upload_personal_information_bloc.dart';

class OnboardPersonalInformation extends StatefulWidget {
  const OnboardPersonalInformation({Key? key, this.data}) : super(key: key);
  final UserDetailModel? data;

  @override
  State<OnboardPersonalInformation> createState() =>
      _OnboardPersonalInformationState();
}

class _OnboardPersonalInformationState
    extends State<OnboardPersonalInformation> {
  final kycStepModelController = Get.put(KycStepModel());
  DateTime? _dateOfBirth;
  DateTime? maxDate = DateTime.now();
  DateTime? minDate = DateTime(1900);
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'dd-MM-yyyy';
  String? selectedTitle;
  String? selectedGender;
  int? genderId;
  String? selectedMaritalStatus;
  String? selectedEquity;
  String? selectedDisability;
  String? selectedResidentialProvince;
  String? selectedNationality;
  String? selectedCountryofBirth;
  String? selectedPostalProvince;
  String? selectedWorkProvince;
  String? selectedPoBox;
  String? selectedEContactRelationship;
  String? selectedWorkLocation;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passportNumberController =
      TextEditingController();
  final TextEditingController alternativeNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController residentialAddressController =
      TextEditingController();
  final TextEditingController residentialCityController =
      TextEditingController();
  final TextEditingController residentialPostalCodeController =
      TextEditingController();
  final TextEditingController postalAddressController = TextEditingController();
  final TextEditingController postalCityController = TextEditingController();
  final TextEditingController postalPostalCodeController =
      TextEditingController();
  final TextEditingController emergencyContactFullNameController =
      TextEditingController();
  final TextEditingController emergencyContactNumberController =
      TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (kycStepModelController.isEditableValue) {
      // selectedTitle = widget.data!.data!.agentDetails!.first.title;
      firstNameController.text = widget.data!.data!.agentDetails!.firstName ?? '';
      // middleNameController.text = widget.data!.data!.agentDetails!.first.middleName ?? '';
      lastNameController.text = widget.data!.data!.agentDetails!.lastName ?? '';
      phoneNumberController.text = widget.data!.data!.agentDetails!.applicationPhone ?? '';
      emailController.text = widget.data!.data!.agentDetails!.email ?? '';
      // selectedGender = widget.data!.data!.agentDetails!.genderId;
      selectedMaritalStatus = widget.data!.data!.agentDetails!.maritalStatus;
      selectedNationality = widget.data!.data!.agentDetails!.nationality;
      selectedCountryofBirth = widget.data!.data!.agentDetails!.countryOfBirth;
      selectedDisability = widget.data!.data!.agentDetails!.disability;
      selectedEquity = widget.data!.data!.agentDetails!.equityGroup;
      dobController.text = widget.data!.data!.agentDetails!.dateOfBirth ?? '';
      residentialAddressController.text =
          widget.data!.data!.agentDetails!.residentialAddress ?? '';
      residentialCityController.text =
          widget.data!.data!.agentDetails!.residentialCity ?? '';
      residentialPostalCodeController.text =
          widget.data!.data!.agentDetails!.residentialPostalCode ?? '';
      selectedResidentialProvince =
          widget.data!.data!.agentDetails!.residentialprovince ?? '';
      postalAddressController.text = widget.data!.data!.agentDetails!.postalAddress ?? '';
      postalCityController.text = widget.data!.data!.agentDetails!.postalCity ?? '';
      postalPostalCodeController.text = widget.data!.data!.agentDetails!.postalPostalCode ?? '';
      selectedPostalProvince = widget.data!.data!.agentDetails!.postalprovince;
      selectedEContactRelationship =
          widget.data!.data!.agentDetails!.accHolderRelationship;
      emergencyContactFullNameController.text =
          widget.data!.data!.agentDetails!.emergencyContactFullName ?? '';
      emergencyContactNumberController.text =
          widget.data!.data!.agentDetails!.emergencyContactNumber ?? '';
      alternativeNoController.text =
          widget.data!.data!.agentDetails!.emergencyAlternativeNumber ?? '';
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadPersonalInformationBloc,
        UploadPersonalInformationState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Personal Information',
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text(
                        'Please provide your personal information',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedTitle == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedTitle,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedTitle = newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: titles.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 2,
                                  child: TxtField(
                                    hint: 'First Name*',
                                    controller: firstNameController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'First name is required';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: TxtField(
                                    hint: 'Middle Name',
                                    controller: middleNameController,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: TxtField(
                                    hint: 'Last Name*',
                                    controller: lastNameController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Last name is required';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Mobile Number*',
                            length: 10,
                            controller: phoneNumberController,
                            type: TextInputType.number,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                           validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone Number is required';
                              } else if (value.length != 10||value[0] != '0') {
                                return 'Phone number should be 10 digits starting with 0';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Email*',
                            controller: emailController,
                            validator: (value) {
                              if (value == null) {
                                return 'Email is required';
                              } else if (!(value.contains('@'))) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          Utils.sizedBoxHeight(20),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gender*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedGender == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedGender,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedGender = newValue;
                                                  if (newValue == 'Male') {
                                                    genderId = 1;
                                                  } else if (newValue ==
                                                      'Female') {
                                                    genderId = 2;
                                                  } else {
                                                    genderId = 3;
                                                  }
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: gender.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Marital Status*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedMaritalStatus == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedMaritalStatus,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedMaritalStatus =
                                                      newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: maritalStatus
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nationality*',
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
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#d5dce0'),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#5374ff'),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedNationality == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedNationality,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedNationality = newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: countries.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Country of Birth*',
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
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#d5dce0'),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#5374ff'),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedCountryofBirth == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedCountryofBirth,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedCountryofBirth = newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: countries.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Equity Group*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedEquity == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedEquity,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedEquity = newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: equity.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Utils.sizedBoxWidth(10),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Disability*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedDisability == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedDisability,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedDisability = newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: disability
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Birth*',
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
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: dobController,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#d5dce0'),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#5374ff'),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#de5151'),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#de5151'),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    pickerTheme: const DateTimePickerTheme(
                                      itemTextStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      confirm: Text('Done',
                                          style: TextStyle(color: Colors.red)),
                                      cancel: Text('cancel',
                                          style: TextStyle(color: Colors.cyan)),
                                      itemHeight: 40,
                                    ),
                                    pickerMode: DateTimePickerMode.date,
                                    minDateTime: minDate,
                                    maxDateTime: maxDate,
                                    initialDateTime: DateTime.now(),
                                    dateFormat: _format,
                                    locale: _locale,
                                    onClose: () => print('----- onClose -----'),
                                    onCancel: () => print('onCancel'),
                                    onChange: (dateTime, List<int> index) {
                                      setState(() {
                                        _dateOfBirth = dateTime;
                                        //assign date in DD/MM/YYYY format
                                        dobController.text =
                                            DateFormat('dd-MM-yyyy')
                                                .format(dateTime);
                                      });
                                    },
                                    onConfirm: (dateTime, List<int> index) {
                                      setState(() {
                                        setState(() {
                                          _dateOfBirth = dateTime;
                                          dobController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(dateTime);
                                        });
                                      });
                                    },
                                  );
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Date of Birth is required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          TxtField(
                            type: TextInputType.number,
                            hint: 'Income Tax Number',
                            controller: taxNumberController,
                          ),
                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Passport Number',
                            controller: passportNumberController,
                          ),
                          Utils.sizedBoxHeight(20),
                          Utils.sizedBoxHeight(20),
                          //make a section seperator title
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: const Text(
                              'Residential Address:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TxtField(
                            hint: 'Unit Number/Street Name/Complex*',
                            controller: residentialAddressController,
                            validator: (value) {
                              if (value == null) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Town/City*',
                            controller: residentialCityController,
                            validator: (value) {
                              if (value == null) {
                                return 'Town/City is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TxtField(
                                  hint: 'Postal Code*',
                                  controller: residentialPostalCodeController,
                                  formatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  type: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Province*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty:
                                              selectedResidentialProvince == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value:
                                                  selectedResidentialProvince,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedResidentialProvince =
                                                      newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items:
                                                  province.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: const Text(
                                  'Postal Address:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        state.sameAddress
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 20,
                                      ),
                                      color: state.sameAddress
                                          ? Colors.green
                                          : Colors.grey,
                                      onPressed: () {
                                        addressCopy() {
                                          if (state.sameAddress == false) {
                                            postalAddressController.text =
                                                residentialAddressController
                                                    .text;
                                            postalCityController.text =
                                                residentialCityController.text;
                                            postalPostalCodeController.text =
                                                residentialPostalCodeController
                                                    .text;
                                            selectedPostalProvince =
                                                selectedResidentialProvince;
                                          } else {
                                            postalAddressController.text = '';
                                            postalCityController.text = '';
                                            postalPostalCodeController.text =
                                                '';
                                            selectedPostalProvince = null;
                                          }
                                        }

                                        context
                                            .read<
                                                UploadPersonalInformationBloc>()
                                            .add(CopyAddressEvent());
                                        addressCopy();
                                      },
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Same as Residential Address',
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
                          TxtField(
                            hint: 'Postal Number/Street Number*',
                            controller: postalAddressController,
                            validator: (value) {
                              if (value == null) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Town/City*',
                            controller: postalCityController,
                            validator: (value) {
                              if (value == null) {
                                return 'Town/City is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TxtField(
                                  hint: 'Postal Code*',
                                  controller: postalPostalCodeController,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Postal Code is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Province*',
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
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#d5dce0'),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#5374ff'),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                color: HexColor('#de5151'),
                                              ),
                                            ),
                                          ),
                                          isEmpty: selectedPostalProvince == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedPostalProvince,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedPostalProvince =
                                                      newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items:
                                                  province.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PO Box',
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
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#d5dce0'),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#5374ff'),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedPoBox == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedPoBox,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedPoBox = newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: pobox.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: const Text(
                              'Emergency Contact:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Contact Relationship*',
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
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#d5dce0'),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#5374ff'),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedEContactRelationship == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        dropdownColor: const Color.fromARGB(
                                            255, 233, 231, 224),
                                        value: selectedEContactRelationship,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedEContactRelationship =
                                                newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: emergencyContactRelation
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.center,
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Full Name*',
                            controller: emergencyContactFullNameController,
                            validator: (value) {
                              if (value == null) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          TxtField(
                            type: TextInputType.number,
                            hint: 'Emergency Mobile Number*',
                            controller: emergencyContactNumberController,
                            length: 10,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                           validator: (value) {
                              if (value!.isEmpty) {
                                return 'Emergency mobile is required';
                              } else if (value.length != 10||value[0] != '0') {
                                return 'Phone number should be 10 digits starting with 0';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          TxtField(
                            type: TextInputType.number,
                            hint: 'Alternate Number',
                            controller: alternativeNoController,
                            length: 10,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value.isNotEmpty && value.length != 10) {
                                return 'Phone number should be 10 digits starting with 0';
                              } else if (value.isNotEmpty && value[0] != '0') {
                                return 'Phone number should be 10 digits starting with 0';
                              }
                              return null;
                            },
                          ),
                          Utils.sizedBoxHeight(20),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: const Text(
                              'Preffered Work Location:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TxtField(
                            hint: 'Location*',
                            controller: workLocationController,
                            validator: (value) {
                              if (value == null) {
                                return 'location is required';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'City*',
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
                                autoCorrect: true,
                                suggestions: cities
                                    .map((e) => SearchFieldListItem(e, item: e))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                hasOverlay: false,
                                searchStyle: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                validator: (x) {
                                  if (x == null ||
                                      x.isEmpty ||
                                      !cities.map((e) => e).contains(x)) {
                                    return 'Please select a city';
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#d5dce0'),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#5374ff'),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#de5151'),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: HexColor('#de5151'),
                                    ),
                                  ),
                                ),
                                onSuggestionTap: (x) {
                                  setState(() {
                                    selectedWorkLocation = x.item!;
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                maxSuggestionsInViewPort: 6,
                                itemHeight: 50,
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Province*',
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
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#d5dce0'),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#5374ff'),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: HexColor('#de5151'),
                                        ),
                                      ),
                                    ),
                                    isEmpty: selectedWorkProvince == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedWorkProvince,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedWorkProvince = newValue;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: province.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: RoundedLoadingButton(
                                    resetAfterDuration: true,
                                    resetDuration: const Duration(seconds: 10),
                                    width: 100.w,
                                    borderRadius: 10,
                                    color: Colors.red,
                                    controller: _btnController,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (selectedTitle != null &&
                                            selectedGender != null &&
                                            selectedMaritalStatus != null &&
                                            selectedNationality != null &&
                                            selectedCountryofBirth != null &&
                                            selectedEquity != null &&
                                            selectedDisability != null &&
                                            selectedWorkProvince != null &&
                                            selectedResidentialProvince !=
                                                null &&
                                            selectedPostalProvince != null &&
                                            selectedEContactRelationship !=
                                                null) {
                                          _formKey.currentState!.save();
                                          context.read<UploadPersonalInformationBloc>().add(UploadPersonalDataEvent(
                                              context: context,
                                              title: selectedTitle!,
                                              tax: taxNumberController.text,
                                              passportNumber:
                                                  passportNumberController.text,
                                              firstName:
                                                  firstNameController.text,
                                              middleName:
                                                  middleNameController.text,
                                              lastName: lastNameController.text,
                                              phoneNumber:
                                                  phoneNumberController.text,
                                              email: emailController.text
                                                  .toLowerCase(),
                                              gender: genderId!,
                                              maritalStatus:
                                                  selectedMaritalStatus!,
                                              equityGroup: selectedEquity!,
                                              workCity: selectedWorkLocation!,
                                              workLocation:
                                                  workLocationController.text,
                                              workProvince:
                                                  selectedWorkProvince!,
                                              disability: selectedDisability!,
                                              nationality: selectedNationality!,
                                              countryofBirth:
                                                  selectedCountryofBirth!,
                                              dob: dobController.text,
                                              residentialAddress:
                                                  residentialAddressController
                                                      .text,
                                              residentialCity:
                                                  residentialCityController
                                                      .text,
                                              residentialProvince:
                                                  selectedResidentialProvince!,
                                              residentialPostalCode:
                                                  residentialPostalCodeController
                                                      .text,
                                              postalAddress:
                                                  postalAddressController.text,
                                              postalCity:
                                                  postalCityController.text,
                                              postalProvince:
                                                  selectedPostalProvince!,
                                              postalPostalCode:
                                                  postalPostalCodeController
                                                      .text,
                                              emergencyContactRelation:
                                                  selectedEContactRelationship!,
                                              emergencyContactFullName:
                                                  emergencyContactFullNameController
                                                      .text,
                                              emergencyContactNumber:
                                                  emergencyContactNumberController
                                                      .text,
                                              emergencyAlternativeContactNumber:
                                                  alternativeNoController
                                                      .text));
                                        } else {
                                          _btnController.reset();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Please add all required fields to continue'),
                                          ));
                                        }
                                      } else {
                                        _btnController.reset();
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'NEXT',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
