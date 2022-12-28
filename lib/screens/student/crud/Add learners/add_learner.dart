import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/grade_list_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/model/Classes.dart';
import '../../../../utils/widget/addn_deleteButton.dart';
import '../../../../utils/widget/txtbox.dart';

class AddLearner extends StatefulWidget {
  const AddLearner({Key? key}) : super(key: key);

  @override
  State<AddLearner> createState() => _AddLearnerState();
}

class _AddLearnerState extends State<AddLearner>
    with SingleTickerProviderStateMixin {
  String? _token;

  bool isResponse = false;
  DateTime? date;
  String _format = 'dd/MM/yyyy';
  DateTime minDate = DateTime(DateTime.now().year - 150);
  DateTime? _dateOfBirth;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  TextEditingController nameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController learnerPhoneController = TextEditingController();
  TextEditingController parentnameController = TextEditingController();
  TextEditingController parentMiddlenameController = TextEditingController();
  TextEditingController parentLastnameController = TextEditingController();
  TextEditingController parentDateOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController parent1nidController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  GradeListController gradeListController = getx.Get.put(GradeListController());
  UserDetailsController _userDetailsController =
      getx.Get.put(UserDetailsController());
  String? genderId;
  String? gender;
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
  }

  int? classId;
  String? _selectedClass;
  Future<ClassList?>? classes;

  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    // _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Learner',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learner\'s Information',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                          .fontFamily,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TxtField(
                          hint: 'First Name*',
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Flexible(
                        flex: 2,
                        child: TxtField(
                          hint: 'Middle Name (Optional)',
                          controller: middleNameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'Surname / Last Name*',
                    controller: lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 2, child: getGenderDropdown()),
                      SizedBox(
                        width: 2.w,
                      ),
                      Flexible(
                        flex: 2,
                        child: getx.Obx(() =>
                            getClassNewDropdown(gradeListController.gradeList)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth*',
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
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: dateOfBirthController,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
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
                            initialDateTime: DateTime.now(),
                            dateFormat: _format,
                            locale: _locale,
                            onClose: () => print('----- onClose -----'),
                            onCancel: () => print('onCancel'),
                            onChange: (dateTime, List<int> index) {
                              setState(() {
                                _dateOfBirth = dateTime;
                                dateOfBirthController.text =
                                    DateFormat('dd-MM-yyyy').format(dateTime);
                              });
                            },
                            onConfirm: (dateTime, List<int> index) {
                              setState(() {
                                setState(() {
                                  _dateOfBirth = dateTime;
                                  dateOfBirthController.text =
                                      DateFormat('dd-MM-yyyy').format(dateTime);
                                });
                              });
                            },
                          );
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 8.sp,
                            color: HexColor('#de5151'),
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          labelStyle: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#d5dce0'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#5374ff'),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                        ),
                        inputFormatters: [
                          //formatter for date
                          FilteringTextInputFormatter.singleLineFormatter,
                          //formatter for date in dd/mm/yyyy format
                          FilteringTextInputFormatter.deny(RegExp(r'[^0-9/]')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter date of birth';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'RSA ID Number (13 Digits)',
                    controller: nidController,
                    length: 13,
                    type: TextInputType.number,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    // value: widget.lastName,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length < 13) {
                        return 'Please enter a valid 13-digit RSA ID number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number (Optional)',
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
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: learnerPhoneController,
                        maxLength: 10,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                        inputFormatters: [
                          //formatter for phone number
                          FilteringTextInputFormatter.singleLineFormatter,
                          //formatter for phone number in xxx-xxx-xxxx format
                          FilteringTextInputFormatter.deny(RegExp(r'[^0-9-]')),
                        ],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 8.sp,
                            color: HexColor('#de5151'),
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#d5dce0'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#5374ff'),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty && value[0] != '0') {
                            return 'Please enter 10-digit phone number starting with 0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Text(
                    'Parent\'s Information',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                          .fontFamily,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TxtField(
                          hint: 'First Name*',
                          controller: parentnameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Flexible(
                        flex: 2,
                        child: TxtField(
                          hint: 'Middle Name (Optional)',
                          controller: parentMiddlenameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'Surname / Last Name*',
                    controller: parentLastnameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth*',
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
                      TextFormField(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: parentDateOfBirthController,
                        readOnly: true,
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
                            initialDateTime: DateTime.now(),
                            dateFormat: _format,
                            locale: _locale,
                            onClose: () => print('----- onClose -----'),
                            onCancel: () => print('onCancel'),
                            onChange: (dateTime, List<int> index) {
                              setState(() {
                                _dateOfBirth = dateTime;
                                parentDateOfBirthController.text =
                                    DateFormat('dd-MM-yyyy').format(dateTime);
                              });
                            },
                            onConfirm: (dateTime, List<int> index) {
                              setState(() {
                                setState(() {
                                  _dateOfBirth = dateTime;
                                  parentDateOfBirthController.text =
                                      DateFormat('dd-MM-yyyy').format(dateTime);
                                });
                              });
                            },
                          );
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 8.sp,
                            color: HexColor('#de5151'),
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#d5dce0'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#5374ff'),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color(0xFF343B67)),
                          ),
                        ),
                        inputFormatters: [
                          //formatter for date
                          FilteringTextInputFormatter.singleLineFormatter,
                          //formatter for date in dd/mm/yyyy format
                          FilteringTextInputFormatter.deny(RegExp(r'[^0-9/]')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter date of birth';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                      hint: 'E-mail (Optional)',
                      controller: emailController,
                      validator: (value) {
                        if (value!.isNotEmpty && !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  TxtField(
                    hint: 'RSA ID Number (13 Digits)(Parent)',
                    controller: parent1nidController,
                    length: 13,
                    type: TextInputType.number,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    // value: widget.lastName,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length < 13) {
                        return 'Please enter a valid 13 Digit RSA ID number';
                      }
                      return null;
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number (Optional)',
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
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: parentPhoneController,
                        maxLength: 10,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                        inputFormatters: [
                          //formatter for phone number
                          FilteringTextInputFormatter.singleLineFormatter,
                          //formatter for phone number in xxx-xxx-xxxx format
                          FilteringTextInputFormatter.deny(RegExp(r'[^0-9-]')),
                        ],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 8.sp,
                            color: HexColor('#de5151'),
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#d5dce0'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#5374ff'),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: HexColor('#de5151'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty && value[0] != '0') {
                            return 'Please enter 10-digit phone number starting with 0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: AddnDeleteButton(
                borderColor: '#4e88ff',
                textColor: '#4e88ff',
                title: 'Cancel',
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 40.w,
              child: RoundedLoadingButton(
                color: Colors.blueAccent,
                width: 40.w,
                height: 50,
                controller: _btnController,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addLearner();
                  } else {
                    _btnController.reset();
                  }
                },
                child: Text('Add Learner',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addLearner() async {
    print(classId);
    FormData parameter = FormData.fromMap({
      'first_name': nameController.text,
      'middle_name': middleNameController.text,
      'last_name': lastNameController.text,
      'class': classId,
      'date_of_birth': dateOfBirthController.text.replaceAll('-', '/'),
      'national_id_no': nidController.text,
      'gender': genderId,
      // email_address
      'mobile': learnerPhoneController.text,
      'phone_number': learnerPhoneController.text,
      'parent_1_name': parentnameController.text,
      'parent1_middle_name': parentMiddlenameController.text,
      'parent1_last_name': parentLastnameController.text,
      'parent_1_email': emailController.text,
      'parent1_phone': parentPhoneController.text,
      'parent_1_nid': parent1nidController.text,
      'parent1_dob': parentDateOfBirthController.text.replaceAll('-', '/'),
    });
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _token.toString()},
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.addLearner(),
      data: parameter,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = e.response.data['message'];
      setState(() {
        isResponse = false;
      });
      Utils.showErrorToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Learner Added Successfully!');
      _btnController.success();
      Navigator.pop(context);
    } else {
      _btnController.stop();
      throw Exception('Failed to load');
    }
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
              errorMsg = '';
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
        DropdownSearch<String>(
          // mode: Mode.MENU,
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
          onChanged: (dynamic newValue) {
            setState(() {
              gender = newValue;
              genderId =
                  _genders.singleWhere((e) => e['gender'] == newValue)['id'];
              print(_genders.singleWhere((e) => e['gender'] == newValue)['id']);
              debugPrint('User select $genderId');
            });
          },
          selectedItem: gender,
        ),
      ],
    );
  }
  // Widget  _animatedButton(String text) {
  //   return Container(
  //     height: 50,
  //     width: 40.w,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30.0),
  //         color: HexColor('#4e88ff'),
  //
  //         border: Border.all(color: HexColor('#4e88ff')),
  //         // boxShadow: [
  //         //   BoxShadow(
  //         //     color: Color(0x80000000),
  //         //     blurRadius: 12.0,
  //         //     offset: Offset(0.0, 5.0),
  //         //   ),
  //         // ],
  //         // gradient: LinearGradient(
  //         //   begin: Alignment.topLeft,
  //         //   end: Alignment.bottomRight,
  //         //   colors: [
  //         //     Color(0xff33ccff),
  //         //     Color(0xffff99cc),
  //         //   ],
  //         // )
  //     ),
  //     child: Center(
  //       child: Text(
  //         text,
  //         style:  TextStyle(
  //           color: HexColor('#ffffff'),
  //           fontFamily:
  //           GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
  //           fontSize: 12.sp,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // void _tapDown(TapDownDetails details) {
  //   _controller.forward();
  // }
  //
  // void _tapUp(TapUpDetails details) {
  //   _controller.reverse();
  // }
}
