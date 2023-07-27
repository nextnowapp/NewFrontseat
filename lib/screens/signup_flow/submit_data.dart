import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/signup_flow/approval_pending.dart';
import 'package:nextschool/screens/signup_flow/password_form.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/back_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/textwidget.dart';

class SubmitDataScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> map;
  final String schoolLogo;
  final String fullName;
  const SubmitDataScreen(
      {Key? key,
      required this.userData,
      required this.fullName,
      required this.map,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<SubmitDataScreen> createState() => _SubmitDataScreenState();
}

class _SubmitDataScreenState extends State<SubmitDataScreen> {
  //keys and controllers for form
  //controllers
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var deviceToken;
  bool hidePassword = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    print(widget.userData);
    super.initState();
    messaging.getToken().then((value) {
      deviceToken = value;
    });
  }

  //function to generate a time based 6 digit alphanumeric code

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.schoolLogo,
                    width: 60.w,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'You are agreeing to use the data provided to us to help you to use the app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff1a1a1a)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        RoundedLoadingButton(
                          height: 50,
                          width: 220,
                          borderRadius: 25,
                          color: HexColor('#3db591'),
                          controller: _btnController,
                          onPressed: () async {
                            //generate 6 digit uppercase alphanumeric code from md5
                            Dio dio = new Dio();
                            FormData formData = new FormData.fromMap({
                              ...widget.userData,
                              'device_token': deviceToken,
                              'approval_request_id':
                                  widget.map['approval_request_id'],
                            });

                            try {
                              var response = await dio.post(
                                InfixApi.submitApproval,
                                data: formData,
                                options: Options(
                                  headers: {
                                    'Accept': 'application/json',
                                    'Authorization':
                                        widget.map['accessToken'].toString(),
                                  },
                                ),
                              );

                              var userData = {
                                ...widget.userData,
                                'approval_request_id':
                                    widget.map['approval_request_id'],
                              };

                              if (response.statusCode == 200) {
                                _btnController.reset();
                                print(response.data);
                                if (response.data['success'] == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PendingApprovalScreen(
                                        schoolLogo: widget.schoolLogo,
                                        data: userData,
                                      ),
                                    ),
                                  );
                                } else {
                                  _btnController.reset();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
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
                                                'assets/svg/parent_onboarding/Passcode Unavailable.svg'),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              response.statusMessage.toString(),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                (response.data['message'] ??
                                                        (response.data ?? ''))
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(response.data['error']
                                                          .toString() ==
                                                      'null'
                                                  ? ''
                                                  : response.data['error']
                                                      .toString()),
                                            ],
                                          ),
                                        ),
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svg/parent_onboarding/Passcode Unavailable.svg'),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Text(
                                                e.response!.statusMessage
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp),
                                              ),
                                            ],
                                          ),
                                          content: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  (e.response!.data[
                                                              'message'] ??
                                                          (e.response!.data ??
                                                              ''))
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(e.response!.data['error']
                                                            .toString() ==
                                                        'null'
                                                    ? ''
                                                    : e.response!.data['error']
                                                        .toString()),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PasswordFormScreen(
                                                                    schoolLogo:
                                                                        widget
                                                                            .schoolLogo,
                                                                    map: widget
                                                                        .map,
                                                                    fullName: widget
                                                                        .fullName,
                                                                    userData: widget
                                                                        .userData,
                                                                  )),
                                                        );
                                                      },
                                                      child: BackBtn(
                                                        color:
                                                            HexColor('#3fb18f'),
                                                        textColor:
                                                            HexColor('#3fb18f'),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        height: 42,
                                                        width: 90,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: HexColor(
                                                              '#3fb18f'),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: const Center(
                                                          child: TextWidget(
                                                            txt: 'Ok',
                                                            clr: Colors.white,
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
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
                                          title: const Text('Error'),
                                          content: Text(e.message ?? ''),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
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
                          },
                          child: const Text(
                            'Complete Registration',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
