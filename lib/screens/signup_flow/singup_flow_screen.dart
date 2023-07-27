import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/signup_flow/check_approval_status.dart';
import 'package:nextschool/screens/signup_flow/confirm_registration_screen.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/back_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/textwidget.dart';

class SignupFlowScreen extends StatefulWidget {
  final String schoolName;
  final String schoolID;
  final String schoolUrl;
  final String schoolLogo;
  const SignupFlowScreen(
      {Key? key,
      required this.schoolName,
      required this.schoolID,
      required this.schoolUrl,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends State<SignupFlowScreen> {
  bool validate = false;
  String errorMessage = '';
  var focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _passcodeController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
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
        backgroundColor: HexColor('#f5f5f5'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 2.h,
                      ),
                      Text('Welcome!',
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff1a1a1a))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Register as Parent',
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff1a1a1a))),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            'Let\'s start the digital revolution and do things smartly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1a1a1a))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, top: 60, right: 20, bottom: 60),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        'To continue, please provide your unique 12 digit OTP as issued to you from school',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600])),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Enter Registration OTP',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  TextFormField(
                                    focusNode: focusNode,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                        RegExp('[A-Z0-9]'),
                                        allow: true,
                                      ),
                                    ],
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    controller: _passcodeController,
                                    cursorColor: Colors.grey[400],
                                    cursorWidth: 1,
                                    maxLength: 12,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fillColor: const Color.fromARGB(
                                          242, 245, 243, 243),
                                      filled: true,
                                      focusColor: Colors.grey,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.blueAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter passcode';
                                      } else if (value.length < 12) {
                                        return 'Please enter 12 digit passcode';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            (validate)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            errorMessage,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: BackBtn(
                                      color: HexColor('#40b08f'),
                                      textColor: HexColor('#40b08f'),
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
                                      if (_passcodeController.text.length !=
                                          0) {
                                        if (validate == true) {
                                          validate = false;
                                        }
                                        //save school id in shared preferences
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setString(
                                              'schoolId', widget.schoolID);
                                        });

                                        //post request to get school details using dio
                                        Dio dio = new Dio();
                                        FormData formData =
                                            new FormData.fromMap({
                                          'passcode': _passcodeController.text,
                                          'app_config_token': '1234567890',
                                        });

                                        try {
                                          var response = await dio.post(
                                            InfixApi.searchSchool,
                                            data: formData,
                                          );

                                          if (response.statusCode == 200) {
                                            _btnController.reset();
                                            print(response.data);
                                            if (response.data['success'] ==
                                                true) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConfirmRegistration(
                                                            schoolLogo: widget
                                                                .schoolLogo,
                                                            map: response
                                                                .data['data'],
                                                            passcode:
                                                                _passcodeController
                                                                    .text,
                                                          )));
                                            } else {
                                              _btnController.reset();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Error'),
                                                    content: Text(response
                                                        .data['message']),
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
                                          _btnController.reset();
                                          switch (e.type) {
                                            case DioExceptionType.badResponse:
                                              {
                                                setState(() {
                                                  errorMessage = e.response!
                                                      .data['message'];
                                                  validate = true;
                                                });
                                              }
                                              break;
                                            case DioExceptionType.sendTimeout:
                                              {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content:
                                                          Text(e.message ?? ''),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
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
                            SizedBox(
                              height: 3.h,
                            ),
                            //Already submitted the form? Check status
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckApprovalStatusScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //add icon
                                  const Icon(
                                    Icons.info,
                                    size: 20,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Already submitted the form? Check status',
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12.sp,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  }
}
