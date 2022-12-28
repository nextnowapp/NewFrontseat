import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/widget/addn_deleteButton.dart';

class SendChatScreen extends StatefulWidget {
  const SendChatScreen({Key? key}) : super(key: key);

  @override
  State<SendChatScreen> createState() => _SendChatScreenState();
}

class _SendChatScreenState extends State<SendChatScreen> {
  List _sendto = [
    {'id': '3', 'sendto': 'All Parents of the Class'},
    {'id': '4', 'sendto': 'All Staff of the Class'},
    {'id': '5', 'sendto': 'All Management of the Class'}
  ];
  String? selectedto;
  String? sendtoID;
  File? _file;
  String? id;
  String? token;
  RegExp exp = RegExp('\/((?:.(?!\/))+\$)');
  UserDetailsController _userDetailsController =
      getx.Get.put(UserDetailsController());
  var _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    id = _userDetailsController.id.toString();
    token = _userDetailsController.token;
    super.initState();
  }

  @override
  final TextEditingController messageController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Send Chat',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: HexColor('#7cd4ae'),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: getSendtoDropdown(),
                    )),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: HexColor('#e7edf5'),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Message :',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          TextFormField(
                            maxLines: 5,
                            controller: messageController,
                            validator: (value) {
                              if (value == '') {
                                return 'Enter the Message';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Type your Message ',
                              hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.inter().fontFamily),
                              filled: true,
                              fillColor: Colors.white,
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
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: HexColor('#e7edf5'),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Attachment (If any) :',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: HexColor('#e8e9ec'),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child:
                                              Icon(Icons.attach_file_rounded),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        _file == null
                                            ? 'Select File (Image Or PDF files only!)'
                                            : exp
                                                .firstMatch(_file!.path)!
                                                .group(1)!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 7.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickDocument();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: HexColor('#4e88ff'),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.arrow_upward_outlined,
                                              size: 15,
                                            ),
                                            Text(
                                              'Upload',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8.sp,
                                                fontFamily: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                ).fontFamily,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
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
                controller: _btnController,
                onPressed: () {
                  log(_userDetailsController.schoolUrl);
                  if (_formKey.currentState!.validate()) {
                    sendChat();
                  } else {
                    _btnController.reset();
                  }
                },
                child:
                    const Text('Send', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSendtoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send to :',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Please select any option';
            }
            return null;
          },
          // showSelectedItems: true,
          items: [
            'All Parents of the Class',
            'All Staff of the Class',
            'All Management of the Class'
          ],

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
                  const Divider()
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (3 * 42.sp) < 170.sp ? (3 * 42.sp) : 170.sp,
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
              filled: true,
              fillColor: Colors.white,
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.black54,
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
              selectedto = newValue;
              sendtoID =
                  _sendto.singleWhere((e) => e['sendto'] == newValue)['id'];
              print(_sendto.singleWhere((e) => e['sendto'] == newValue)['id']);
              debugPrint('User select $sendtoID');
            });
          },
          selectedItem: selectedto,
        ),
      ],
    );
  }

  sendChat() async {
    log(InfixApi.sendChat);
    FormData parameter = FormData.fromMap({
      'chat_message': messageController.text,
      'login_id': id,
      'role[]': sendtoID,
      'chat_image':
          _file != null ? await MultipartFile.fromFile(_file!.path) : '',
    });
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token},
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.sendChat,
      data: parameter,
    );
    if (response.statusCode == 200) {
      log('Message sent Successfully!');
      Utils.showToast('Message sent Successfully!');
      _btnController.success();
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      Utils.showToast('Failed to sent message');
      _btnController.reset();
    } else {
      _btnController.reset();
      throw Exception('Failed to load');
    }
  }

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
}
