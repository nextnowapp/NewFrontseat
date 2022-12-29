import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

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

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passportNumberController = TextEditingController();
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
      // selectedTitle = widget.data!.userData!.title;
      firstNameController.text = widget.data!.userData!.firstname ?? "";
      // middleNameController.text = widget.data!.userData!.middleName ?? '';
      lastNameController.text = widget.data!.userData!.lastname ?? '';
      phoneNumberController.text = widget.data!.userData!.phonenumber ?? '';
      emailController.text = widget.data!.userData!.email ?? '';
      selectedGender = widget.data!.userData!.gender;
      selectedMaritalStatus = widget.data!.userData!.maritalStatus;
      selectedNationality = widget.data!.userData!.nationality;
      selectedCountryofBirth = widget.data!.userData!.countryOfBirth;
      selectedDisability = widget.data!.userData!.disability;
      selectedEquity = widget.data!.userData!.race;
      dobController.text = widget.data!.userData!.dateOfBirth ?? '';
      residentialAddressController.text =
          widget.data!.userData!.residentialAddress ?? '';
      residentialCityController.text =
          widget.data!.userData!.residentialTownCity ?? '';
      residentialPostalCodeController.text =
          widget.data!.userData!.residentialPostalCode ?? '';
      selectedResidentialProvince =
          widget.data!.userData!.residentialProvince ?? '';
      postalAddressController.text = widget.data!.userData!.postalAddress ?? '';
      postalCityController.text = widget.data!.userData!.postalTownCity ?? '';
      postalPostalCodeController.text = widget.data!.userData!.postalCode ?? '';
      selectedPostalProvince = widget.data!.userData!.postalProvince;
      selectedEContactRelationship =
          widget.data!.userData!.relationWithContactPerson;
      emergencyContactFullNameController.text =
          widget.data!.userData!.emergencyContactsFullName ?? '';
      emergencyContactNumberController.text =
          widget.data!.userData!.emergencyMobileNo ?? '';
      alternativeNoController.text =
          widget.data!.userData!.emergencyAlternativeNo ?? '';
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
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Please select Title',
                                          label: const Text('Title*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
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
                              if (value == null) {
                                return 'Mobile Number is required';
                              } else if (value.length != 10) {
                                return 'Mobile number should be of 10 digits';
                              } else if (value[0] != '0') {
                                return 'Phone Number must start with 0';
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
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Please select Gender',
                                          label: const Text('Gender*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: selectedGender == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedGender,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGender = newValue;
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
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 2,
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText:
                                              'Please select Marital Status',
                                          label: const Text('Marital Status*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: selectedMaritalStatus == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedMaritalStatus,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedMaritalStatus = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items:
                                              maritalStatus.map((String value) {
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
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),

                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: 'Nationality',
                                    label: const Text('Nationality*'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
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
                          Utils.sizedBoxHeight(20),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: '',
                                    label: const Text('Country of Birth*'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
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
                          Utils.sizedBoxHeight(20),
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
                                          hintText:
                                              'Please select Equity Group',
                                          label: const Text('Equity Group*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
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
                              ),
                              Utils.sizedBoxWidth(10),
                              Flexible(
                                flex: 1,
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: '',
                                          label: const Text('Disability*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
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
                                          items: disability.map((String value) {
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
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: dobController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth*',
                              hintText: 'DD/MM/YYYY',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                pickerTheme: const DateTimePickerTheme(
                                  itemTextStyle:
                                      TextStyle(fontWeight: FontWeight.w600),
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
                                onClose: () => print("----- onClose -----"),
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
                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: "Income Tax Number",
                            controller: taxNumberController,
                          ),
                            Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: "Passport Number",
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
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Please select Province',
                                          label: const Text('Province*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty:
                                          selectedResidentialProvince == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedResidentialProvince,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedResidentialProvince =
                                                  newValue;
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
                                            postalAddressController.text = "";
                                            postalCityController.text = "";
                                            postalPostalCodeController.text =
                                                "";
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
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Please select Province',
                                          label: const Text('Province*'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: selectedPostalProvince == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedPostalProvince,
                                          isDense: true,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedPostalProvince = newValue;
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
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(20),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: 'Please selected PO Box',
                                    label: const Text('PO Box'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
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
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: 'Emergency Contact Relationship',
                                    label: const Text(
                                        'Emergency Contact Relationship'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                isEmpty: selectedEContactRelationship == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color.fromARGB(
                                        255, 233, 231, 224),
                                    value: selectedEContactRelationship,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedEContactRelationship = newValue;
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
                            hint: 'Emergency Mobile Number*',
                            controller: emergencyContactNumberController,
                            length: 10,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return 'Emergency mobile is required';
                              } else if (value.length != 10) {
                                return 'Emergency mobile number should be of 10 digits';
                              } else if (value[0] != '0') {
                                return 'Phone Number must start with 0';
                              }
                              return null;
                            },
                          ),

                          Utils.sizedBoxHeight(20),
                          TxtField(
                            hint: 'Alternate Number*',
                            controller: alternativeNoController,
                            length: 10,
                            formatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return 'Alternate mobile is required';
                              } else if (value.length != 10) {
                                return 'Alternate mobile number should be of 10 digits';
                              } else if (value[0] != '0') {
                                return 'Phone Number must start with 0';
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
                          SearchField<String>(
                            autoCorrect: true,
                            suggestions: cities
                                .map((e) => SearchFieldListItem(e, item: e))
                                .toList(),
                            suggestionState: Suggestion.expand,
                            hasOverlay: false,
                            searchStyle:
                                const TextStyle(fontSize: 16, color: Colors.black),
                            validator: (x) {
                              if (x == null ||
                                  x.isEmpty ||
                                  !cities.map((e) => e).contains(x)) {
                                return 'Please select a city';
                              }
                              return null;
                            },
                            searchInputDecoration: InputDecoration(
                                // hintText: "Preffered Work Location",
                                label: const Text(
                                  "City*",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
                                  borderSide:
                                      const BorderSide(color: Colors.grey, width: 1.2),
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                suffixIcon: const Icon(Icons.search)),
                            onSuggestionTap: (x) {
                              setState(() {
                                selectedWorkLocation = x.item!;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            maxSuggestionsInViewPort: 6,
                            itemHeight: 50,
                          ),
                          Utils.sizedBoxHeight(20),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: 'Please select work Province',
                                    label: const Text('Province*'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
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
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
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

                                          Utils.showProcessingToast();
                                          context.read<UploadPersonalInformationBloc>().add(UploadPersonalDataEvent(
                                              context: context,
                                              title: selectedTitle!,
                                              tax: taxNumberController.text,
                                              passportNumber: passportNumberController.text,
                                              firstName:
                                                  firstNameController.text,
                                              middleName:
                                                  middleNameController.text,
                                              lastName: lastNameController.text,
                                              phoneNumber:
                                                  phoneNumberController.text,
                                              email: emailController.text
                                                  .toLowerCase(),
                                              gender: selectedGender!,
                                              maritalStatus:
                                                  selectedMaritalStatus!,
                                              equityGroup: selectedEquity!,
                                              workCity:
                                                  selectedWorkLocation!,
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Please add all required fields to continue"),
                                          ));
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
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
