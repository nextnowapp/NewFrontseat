import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/screens/signup_flow/learner_registration_details.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/Section.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/back_button.dart';
import '../../utils/widget/date_selector_textfield.dart';
import '../../utils/widget/textwidget.dart';

class LearnerFormScreen extends StatefulWidget {
  final Map<String, dynamic> map;
  final String passcode;
  final Map<String, dynamic> userData;
  final String fullName;
  final String schoolLogo;

  const LearnerFormScreen(
      {Key? key,
      required this.map,
      required this.passcode,
      required this.userData,
      required this.fullName,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<LearnerFormScreen> createState() => _LearnerFormScreenState();
}

class _LearnerFormScreenState extends State<LearnerFormScreen> {
  String? genderId;
  String? gender = 'Gender';
  String? learnerDOB;
  DateTime? date;
  DateTime? _dateTime;
  Future<ClassList?>? classes;
  Future<SectionListModel?>? sections;
  int? classId;
  String? _selectedClass;
  String _format = 'dd/MM/yyyy';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime minDate = DateTime(1980);

  //keys and controllers for form
  var _formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var nidController = TextEditingController();
  var dobController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  //drop down list
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  @override
  void initState() {
    super.initState();
    classes = getAllClass();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CachedNetworkImage(
            imageUrl: widget.schoolLogo,
            width: 60.w,
          ),
        ),
        resizeToAvoidBottomInset: false,
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
                                  'assets/svg/parent_onboarding/Step 2.svg'),
                              SizedBox(
                                width: 2.w,
                              ),
                              TextWidget(
                                txt: 'Step 2 of 3',
                                size: 12.sp,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          TextWidget(
                            txt: "Learner's Registration",
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
                                    'Now, let\'s take you to your Learner\'s classroom. To proceed you need to provide your learner\'s details',
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
                            controller: firstNameController,
                            insideHint: 'Learner\'s First Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Learner\'s First Name';
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
                            insideHint: 'Learner\'s Middle Name',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                              hint: 'Last Name*',
                              insideHint: 'Learner\'s Last Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Learner\'s Last Name';
                                }
                                return null;
                              },
                              controller: lastNameController),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Phone No.',
                            controller: phoneController,
                            insideHint: 'Phone No.',
                            length: 10,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                              } else if (!value.startsWith('0')) {
                                return 'First digit must be 0';
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
                            insideHint: 'Learner\'s  E-mail',
                            validator: (value) {
                              if (value!.isEmpty) {
                              }
                              //add email validation
                              else if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return 'Please enter a valid e-mail';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'RSA ID',
                            insideHint: 'Learner\'s RSA ID',
                            controller: nidController,
                            length: 13,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value!.isNotEmpty && value.length < 13) {
                                return 'RSA ID must be 13 Digits';
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
                            height: 30,
                          ),
                          FutureBuilder<ClassList?>(
                              future: classes,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return getClassNewDropdown(
                                      snapshot.data!.classes);
                                }
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4),
                                  child: ShimmerList(
                                    itemCount: 1,
                                    height: 56,
                                    width: Utils.getWidth(context),
                                  ),
                                ));
                              }),
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
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    Dio dio = new Dio();
                                    Map<String, dynamic> data = {
                                      'session_p_dob': widget.userData['p_dob'],
                                      'l_dob': dobController.text,
                                      'l_first_name': firstNameController.text,
                                      'l_middle_name':
                                          middleNameController.text,
                                      'l_last_name': lastNameController.text,
                                      'l_gender': int.parse(genderId!),
                                      'l_mobile': phoneController.text,
                                      'l_email': emailController.text,
                                      'l_nid': nidController.text,
                                      'l_class_id': classId,
                                      'user_type': widget.map['user_type'],
                                      // // 'l_mobile': phoneController.text
                                    };
                                    print(data.values);
                                    FormData formData =
                                        new FormData.fromMap(data);

                                    try {
                                      var response = await dio.post(
                                        InfixApi.saveLearnerDetails,
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
                                          Map<String, dynamic> rdata =
                                              response.data['data'];

                                          var map = {
                                            ...widget.map,
                                            ...rdata,
                                          };
                                          Map<String, dynamic> userData = {
                                            ...widget.userData,
                                            ...data,
                                            'voucher_id': widget.passcode,
                                          };
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           PasswordFormScreen(
                                          //             map: widget.map,
                                          //             fullName:
                                          //                 widget.fullName,
                                          //             userData: userData,
                                          //           )),
                                          // );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnerRegistrationDetailsScreen(
                                                      map: map,
                                                      userData: userData,
                                                      schoolLogo:
                                                          widget.schoolLogo,
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
                                                          emailController.text,
                                                      cls: _selectedClass!,
                                                      gender: gender!,
                                                      dob: dobController.text,
                                                      number:
                                                          phoneController.text,
                                                      id: nidController.text),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    response.data['message']!),
                                                content:
                                                    Text(response.data['data']),
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
                                    } on DioException catch (e) {
                                      switch (e.type) {
                                        case DioExceptionType.badResponse:
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
                                        case DioExceptionType.sendTimeout:
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(e.response!
                                                      .data['message']!),
                                                  content: Text(
                                                      e.response!.data['data']),
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
                                  } else {
                                    _btnController.reset();
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(width: 10),
                                    TextWidget(
                                        txt: 'Next',
                                        clr: Colors.white,
                                        size: 16,
                                        weight: FontWeight.w500),
                                    Icon(
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

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class*',
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
        DropdownSearch<String>(
          validator: (value) {
            if (value == null) {
              return 'Please select a class';
            }
            return null;
          },
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
          items: classes.map((e) => e.name!).toList(),
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
              maxHeight:
                  (classes.length * 60) < 200 ? (classes.length * 60) : 200,
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
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
          ),
          onChanged: (dynamic newValue) async {
            setState(() {
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedClass,
        ),
      ],
    );
  }

  int? getCode<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
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

  Future<SectionListModel> getAllSection(int id, int classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(widget.map['accessToken'].toString()));

    print(InfixApi.getSectionById(id, classId));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SectionListModel.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<ClassList?> getAllClass() async {
    final response = await http.get(Uri.parse(InfixApi.getClassById()),
        headers: Utils.setHeader(widget.map['accessToken'].toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassList.fromJson(jsonData['data']['classes']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
