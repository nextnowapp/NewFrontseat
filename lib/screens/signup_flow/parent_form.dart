import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/signup_flow/parent_registration_details.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/back_button.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class ParentFormScreen extends StatefulWidget {
  final Map<String, dynamic> map;
  final String passcode;
  final String schoolLogo;

  const ParentFormScreen(
      {Key? key,
      required this.map,
      required this.passcode,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<ParentFormScreen> createState() => _ParentFormScreenState();
}

class _ParentFormScreenState extends State<ParentFormScreen> {
  String? genderId;
  String gender = 'Gender';
  String? parentDOB;
  DateTime? date;
  DateTime? _dateTime;
  String _format = 'dd/MM/yyyy';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime minDate = DateTime.now().subtract(const Duration(days: 365 * 100));

  //keys and controllers for form
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var _formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var dobController = TextEditingController();
  var middleNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var nidController = TextEditingController();
  var addressController = TextEditingController();
  var realtionController = TextEditingController();

  //drop down list
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CachedNetworkImage(
            imageUrl: widget.schoolLogo,
            width: 60.w,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/svg/parent_onboarding/Step 1.svg'),
                              SizedBox(
                                width: 2.w,
                              ),
                              TextWidget(
                                txt: 'Step 1 of 3',
                                size: 12.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          TextWidget(
                            txt: "Parent's Registration",
                            size: 14.sp,
                            weight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    'To proceed, you need to provide your details as Parent:',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'First Name*',
                            insideHint: 'Enter your First Name',
                            controller: firstNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Middle Name',
                            controller: middleNameController,
                            insideHint: 'Enter your Middle Name',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Last Name*',
                            controller: lastNameController,
                            insideHint: 'Enter your Last Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'E-mail',
                            controller: emailController,
                            insideHint: 'Enter your E-mail',
                            validator: (value) {
                              if (value!.isEmpty) {
                              }
                              //add email validation
                              else if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Address*',
                            controller: addressController,
                            insideHint: 'Enter your Address',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Relationship',
                            controller: realtionController,
                            insideHint: 'Enter your relationship with Learner',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'RSA ID',
                            controller: nidController,
                            insideHint: 'Your RSA ID',
                            length: 13,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value!.isNotEmpty && value.length < 13) {
                                return 'RSA ID must be 13 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TxtField(
                            hint: 'Phone No.*',
                            controller: phoneController,
                            insideHint: 'Phone No.',
                            length: 10,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (!value.startsWith('0')) {
                                return 'First digit must be 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          getGenderDropdown(),
                          const SizedBox(
                            height: 20,
                          ),
                          DateSelectorTextField(
                            controller: dobController,
                            locale: _locale,
                            minDate: DateTime(1900),
                            maxDate: DateTime.now(),
                            dateFormat: 'dd/MM/yyyy',
                            title: 'Date of Birth*',
                            validatorMessage: 'Please select  date of birth',
                            onDateSelected: (date) {
                              dobController.text = date;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: BackBtn(
                                    color: HexColor('#3fb18f'),
                                    textColor: HexColor('#3fb18f'),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              RoundedLoadingButton(
                                height: 40,
                                width: 90,
                                borderRadius: 30,
                                color: HexColor('#40b08f'),
                                controller: _btnController,
                                onPressed: () async {
                                  log(dobController.text.toString());
                                  if (_formKey.currentState!.validate() &&
                                      genderId != null) {
                                    _formKey.currentState!.save();

                                    Map<String, dynamic> data = {
                                      'p_dob': dobController.text,
                                      'p_first_name': firstNameController.text,
                                      'p_middle_name':
                                          middleNameController.text,
                                      'p_last_name': lastNameController.text,
                                      'p_gender': genderId,
                                      'p_mobile': phoneController.text,
                                      'p_email': emailController.text,
                                      'p_relation': realtionController.text,
                                      'p_address': addressController.text,
                                      'p_nid': nidController.text,
                                    };
                                    print(data.values);

                                    Dio dio = new Dio();
                                    FormData formData =
                                        new FormData.fromMap(data);

                                    try {
                                      var response = await dio.post(
                                        InfixApi.saveParentDetails,
                                        data: formData,
                                        options: Options(
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': widget
                                                .map['accessToken']
                                                .toString(),
                                          },
                                        ),
                                      );

                                      if (response.statusCode == 200) {
                                        print(response.data);
                                        if (response.data['success'] == true) {
                                          Utils.showToast(
                                              response.data['message']);
                                          Map<String, dynamic> resdata =
                                              response.data['data'];

                                          var modifiedMap = {
                                            ...widget.map,
                                            ...resdata
                                          };

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParentRegistrationDetailsScreen(
                                                          map: modifiedMap,
                                                          passcode: widget
                                                              .passcode,
                                                          userData: data,
                                                          schoolLogo: widget
                                                              .schoolLogo,
                                                          firstName:
                                                              firstNameController
                                                                  .text,
                                                          middleName:
                                                              middleNameController
                                                                  .text,
                                                          lastName:
                                                              lastNameController
                                                                  .text,
                                                          email:
                                                              emailController
                                                                  .text,
                                                          address: addressController
                                                              .text,
                                                          relation:
                                                              realtionController
                                                                  .text,
                                                          gender: gender,
                                                          dob: dobController
                                                              .text,
                                                          number:
                                                              phoneController
                                                                  .text,
                                                          id: nidController
                                                              .text)));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: Text(
                                                    response.data['message']),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Ok'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    } on DioError catch (e) {
                                      switch (e.type) {
                                        case DioErrorType.response:
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                              Icons.clear,
                                                              size: 20,
                                                            ),
                                                            color: Colors.black,
                                                          )
                                                        ],
                                                      ),
                                                      SvgPicture.asset(
                                                          'assets/svg/parent_onboarding/Wrong Credentials.svg'),
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                      Text(
                                                        e.response!
                                                            .statusMessage
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          (e.response!.data[
                                                                      'message'] ??
                                                                  (e.response!
                                                                          .data ??
                                                                      ''))
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(e
                                                                    .response!
                                                                    .data[
                                                                        'error']
                                                                    .toString() ==
                                                                'null'
                                                            ? ''
                                                            : e.response!
                                                                .data['error']
                                                                .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          break;
                                        case DioErrorType.other:
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(e
                                                      .response!.statusMessage
                                                      .toString()),
                                                  content: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(e.response!
                                                            .data['message']
                                                            .toString()),
                                                        Text(e.response!
                                                            .data['error']
                                                            .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          break;
                                        default:
                                          print(e.message);
                                      }
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 10),
                                    const TextWidget(
                                        txt: 'Next',
                                        clr: Colors.white,
                                        size: 16,
                                        weight: FontWeight.w500),
                                    const Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 250,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender*',
          style: TextStyle(
            color: HexColor('#8e9aa6'),
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: DropdownSearch<String>(
            validator: (value) {
              if (value == null) {
                return 'Please select a gender';
              }
              return null;
            },
            // showSelectedItems: true,
            items: ['Male', 'Female'],

            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: selectedItem == 'Gender'
                      ? HexColor('#8e9aa6')
                      : Colors.black,
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
                    item == 'Female'
                        ? Container()
                        : Divider(
                            color: HexColor('#8e9aa6'),
                            thickness: 0.5,
                          )
                  ],
                );
              },
              showSelectedItems: true,
              constraints: BoxConstraints(
                maxHeight: (2 * 42.sp) < 170.sp ? (2 * 42.sp) : 170.sp,
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(
                  fontSize: 8.sp,
                  color: HexColor('#de5151'),
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
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: HexColor('#de5151'),
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
              ),
            ),
            onChanged: (newValue) {
              setState(() {
                gender = newValue!;
                genderId =
                    _genders.singleWhere((e) => e['gender'] == newValue)['id'];
                print(
                    _genders.singleWhere((e) => e['gender'] == newValue)['id']);
                debugPrint('User select $genderId');
              });
            },
            selectedItem: gender,
          ),
        ),
      ],
    );
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }
}
