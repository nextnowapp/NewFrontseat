import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/notice/AdminNoticeModel.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/date_selector_textfield.dart';
import 'package:nextschool/utils/widget/submit_button.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class AddNoticeScreen extends StatefulWidget {
  final bool isEdit;
  final Datum? data;
  const AddNoticeScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  _AddNoticeScreenState createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  //make texteditingcontrollers for title, description, image, imageurl,date
  final _titleController = TextEditingController();
  HtmlEditorController controller = HtmlEditorController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _publishDate = DateTime.now();
  File? _file;
  String desc = '';
  //check boxes variable
  DateTimePickerLocale locale = DateTimePickerLocale.en_us;
  bool? _publishToWebsite = false;
  bool _allParents = false;
  bool _allTeachers = false;
  bool _allManagement = false;
  var _id;
  var _token;
  var id;

  var _formKey = GlobalKey<FormState>();

  late SimulatedSubmitController submitController;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  Dio dio = Dio();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    submitController = SimulatedSubmitController(
        onOpenError: () {}, onOpenSuccess: () {}, onPressed: onPressed);
    _token = _userDetailsController.token;
    _id = _userDetailsController.id;

    if (widget.isEdit) {
      _titleController.text = widget.data!.noticeTitle!;
      id = widget.data!.id;
      _dateController.text = widget.data!.noticeDate!;
      _publishToWebsite = widget.data!.isPublished! == 1 ? true : false;
      _allParents = widget.data!.informTo!.split(',').contains('3');
      _allTeachers = widget.data!.informTo!.split(',').contains('4');
      _allManagement = widget.data!.informTo!.split(',').contains('5');
      desc = widget.data!.noticeMessage!;
    }
    super.initState();
  }

  //date time formatter
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          title: widget.isEdit ? 'Edit Notice' : 'Add Notice',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TxtField(
                      hint: 'Notice Title*',
                      controller: _titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title';
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
                          'Description*',
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
                          height: 20.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor('#e5e5e5'),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: HtmlEditor(
                            controller: controller,
                            //required
                            htmlEditorOptions: HtmlEditorOptions(
                                spellCheck: true,
                                initialText: desc,
                                shouldEnsureVisible: false,
                                androidUseHybridComposition: false),
                            htmlToolbarOptions: const HtmlToolbarOptions(
                              defaultToolbarButtons: [
                                StyleButtons(),
                                FontButtons(),
                              ],
                              toolbarPosition: ToolbarPosition.belowEditor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Visibility(
                      visible: !(widget.isEdit),
                      child: DateSelectorTextField(
                        controller: _dateController,
                        locale: locale,
                        title: 'Publish on*',
                        validatorMessage: 'Please select notice publish date',
                        onDateSelected: (date) {
                          setState(() {
                            _publishDate = DateTime.parse(date);
                            _dateController.text =
                                _dateFormat.format(DateTime.parse(date));
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Featured Image',
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5.sp),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: HexColor('#e2e4ed'),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    _file == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: HexColor('#bec4d4'),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: EdgeInsets.all(5.sp),
                                            child: Transform.rotate(
                                              angle: 45 * pi / 180,
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(_file!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    _file == null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Browse Image',
                                                style: TextStyle(
                                                  color: HexColor('#8e9aa6'),
                                                  fontSize: 10.sp,
                                                  fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                  ).fontFamily,
                                                ),
                                              ),
                                              Text(
                                                'Supports JPGs or PNGs',
                                                style: TextStyle(
                                                  color: HexColor('#8e9aa6'),
                                                  fontSize: 8.sp,
                                                  fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                  ).fontFamily,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            _file!.path.split('/').last,
                                            style: TextStyle(
                                              color: HexColor('#8e9aa6'),
                                              fontSize: 12.sp,
                                              fontFamily: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ).fontFamily,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            InkWell(
                              onTap: () {
                                pickDocument();
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: HexColor('#3ab28d'),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //icon
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 24,
                                      color: Colors.white,
                                    ),

                                    //text
                                    Text(
                                      'Browse',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        'Send to.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //container with image and text in row
                        SelectableCard(
                          svgIcon: 'assets/svg/Staffs.svg',
                          title: 'Parents',
                          value: _allParents,
                          onChanged: (value) {
                            setState(() {
                              _allParents = value;
                            });
                          },
                        ),
                        SelectableCard(
                          svgIcon: 'assets/svg/Management.svg',
                          title: 'Staffs',
                          value: _allTeachers,
                          onChanged: (value) {
                            setState(() {
                              _allTeachers = value;
                            });
                          },
                        ),
                        SelectableCard(
                          svgIcon: 'assets/svg/Management.svg',
                          title: 'Managements',
                          value: _allManagement,
                          onChanged: (value) {
                            setState(() {
                              _allManagement = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 10),
                      child: Text(
                        'Check to publish this notice on website.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          side: BorderSide(
                            color: HexColor('#8e9aa6'),
                            width: 1.0,
                          ),
                          value: _publishToWebsite,
                          onChanged: (bool? value) {
                            setState(() {
                              _publishToWebsite = value;
                            });
                          },
                        ),
                        Text(
                          'Publish to Website:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: SizedBox(
            height: 6.5.h,
            child: RoundedLoadingButton(
              child:
                  const Text('Submit', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: onPressed,
              successColor: HexColor('#6f9eff'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    var _publishedDate =
        '${_publishDate.day}/${_publishDate.month}/${_publishDate.year}';
    var isPublished = _publishToWebsite! ? 1 : 0;
    var createdBy = _id;
    String informTo = '';
    //return comma separated string of parents, teachers, management
    if (_allParents) {
      informTo = '3';
    }
    if (_allTeachers) {
      if (informTo.isNotEmpty) {
        informTo += ',';
        informTo += '4';
      } else
        informTo = '4';
    }
    if (_allManagement) {
      if (informTo.isNotEmpty) {
        informTo += ',';
        informTo += '5';
      } else
        informTo = '5';
    }
    var token = _token;
    var description = await controller.getText();
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      uploadNotice(_titleController.text, description, _publishedDate, informTo,
          createdBy, isPublished, token);
    } else {
      Timer(const Duration(seconds: 0), () {
        _btnController.stop();
      });
    }
  }

  void uploadNotice(title, message, publishOn, informTo, createdBy, isPublished,
      token) async {
    var today = DateTime.now();
    var noticeDate =
        '${Utils.getAbsoluteDate(today.day)}/${Utils.getAbsoluteDate(today.month)}/${today.year}';
    if (widget.isEdit) {
      FormData formData = FormData.fromMap({
        'notice_id': id,
        'notice_title': title,
        'notice_message': message,
        'notice_date': noticeDate,
        'publish_on': publishOn,
        'role[]': informTo,
        'login_id': createdBy,
        'is_published': isPublished,
        'notice_image': _file != null
            ? await MultipartFile.fromFile(_file!.path, filename: 'image')
            : MultipartFile.fromBytes(
                await rootBundle.load('assets/images/default_notice.jpeg').then(
                      (data) => data.buffer.asUint8List(),
                    ),
              ),
      });
      submitController.submitStatus = SubmitStatus.busy;

      var response = await dio.post(
        InfixApi.editNoticeData(),
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': _token.toString(),
          },
        ),
        onSendProgress: (received, total) {
          setState(() {});
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
      ).catchError((e) {
        print(e);
        final errorMessage = e.response.data['message'].toString();
        Utils.showErrorToast(errorMessage);
        setState(() {
          _btnController.error();
        });
      });
      print('Status Code : ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = json.decode(response.toString());

        if (data['success'] == true) {
          setState(() {
            Timer(const Duration(seconds: 0), () {
              _btnController.success();
            });
          });
          Utils.showToast(
            'Notice updated Successfully',
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          // Utils.showSnackBar(context, 'Some error occurred');
          setState(() {
            Timer(const Duration(seconds: 0), () {
              _btnController.error();
            });
          });
          Utils.showToast(
            'Some error occurred',
          );
        }
      } else {
        // Utils.showSnackBar(context, 'Some error occurred');
        Utils.showToast(
          'Some error occurred',
        );
      }
    } else {
      FormData formData = FormData.fromMap({
        'notice_title': title,
        'notice_message': message,
        'notice_date': noticeDate,
        'publish_on': publishOn,
        'role[]': informTo,
        'login_id': createdBy,
        'is_published': isPublished,
        'notice_image': _file != null
            ? await MultipartFile.fromFile(_file!.path, filename: 'image')
            : MultipartFile.fromBytes(
                await rootBundle.load('assets/images/default_notice.jpeg').then(
                      (data) => data.buffer.asUint8List(),
                    ),
              ),
      });
      submitController.submitStatus = SubmitStatus.busy;

      var response = await dio.post(
        InfixApi.saveNoticeData(),
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': _token.toString(),
          },
        ),
        onSendProgress: (received, total) {
          setState(() {});
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
      ).catchError((e) {
        var errorMessage = e.response.data['message'];
        Utils.showErrorToast(errorMessage);
        setState(() {
          _btnController.error();
        });
      });
      print(response.data);
      print('Status Code : ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = json.decode(response.toString());

        if (data['success'] == true) {
          setState(() {
            Timer(const Duration(seconds: 0), () {
              _btnController.success();
            });
            // submitController.submitStatus = SubmitStatus.success;
          });
          Utils.showToast(
            'Uploaded Notice Successfully',
          );
          Navigator.of(context).pop();
        } else {
          // Utils.showSnackBar(context, 'Some error occurred');
          setState(() {
            Timer(const Duration(seconds: 0), () {
              _btnController.error();
            });
            // submitController.submitStatus = SubmitStatus.error;
          });
          Utils.showToast(
            'Some error occurred',
          );
        }
      } else {
        // Utils.showSnackBar(context, 'Some error occurred');
        Utils.showToast(
          'Some error occurred',
        );
      }
    }
  }
}

class SelectableCard extends StatefulWidget {
  final String svgIcon;
  final String title;
  final bool value;
  // final Function(bool) onChanged;
  final Function(bool) onChanged;

  const SelectableCard({
    Key? key,
    required this.svgIcon,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  late bool _value;

  @override
  initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: Container(
        height: 45,
        width: 28.w,
        decoration: BoxDecoration(
          color: _value ? Colors.blueAccent: HexColor('#f8f8f8'),
          borderRadius: BorderRadius.circular(15),
          //border
          border: _value
              ? Border.all(
                  color: Colors.blueAccent,
                  width: 1,
                )
              : const Border.fromBorderSide(BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //image
            SvgPicture.asset(
              widget.svgIcon,
            ),
            SizedBox(
              width: 1.w,
            ),
            //text
            FittedBox(
              child: Text(
                widget.title,
                style: TextStyle(
                  color:_value ? Colors.white: Colors.black,
                  fontSize: 8.sp,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
