// import 'dart:async';

// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:nextschool/config/app_config.dart';
// import 'package:nextschool/controller/user_controller.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/server/Login.dart';
// import 'package:nextschool/utils/widget/customLoader.dart';
// import 'package:sms_receiver/sms_receiver.dart';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String? countryCode;

//   OtpScreen({Key? key, required this.phoneNumber, this.countryCode})
//       : super(key: key);

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _mpinController = TextEditingController();
//   TextEditingController _newMpinController = TextEditingController();
//   TextEditingController _confirmMpinController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   late var _verificationId;
//   var rtlValue;
//   var _token;
//   bool validatedPincodeField = false;
//   var _pin;
//   bool isResponse = false;
//   String _textContent = 'Waiting for messages...';
//   SmsReceiver? _smsReceiver;
//   int secondsRemaining = 120;
//   bool enableResend = false;
//   late Timer timer;
//   FirebaseFunctions functions = FirebaseFunctions.instance;
//   UserDetailsController _userDetailsController =
//       Get.put(UserDetailsController());

//   //firebase cloud function to check if the user is registered with resource server or not
//   Future<String?> _verifyPhoneNumber(String phoneNumber) async {
//     var data = {'phone': phoneNumber};
//     HttpsCallable callable = functions.httpsCallable('checkUser');
//     var result = await callable.call(data).catchError((e) {
//       return e.data['result'];
//     });
//     return result.data['result'];
//   }

//   // bool isOtpCorrect = false;
//   // Future<String> setNewMPin(String mPin) async {
//   //   var data = {"mPin": mPin};
//   //   HttpsCallable callable = functions.httpsCallable('setNewMpin');
//   //   var result = await callable.call(data).catchError((e) {
//   //     print(e);
//   //     return e.data["message"];
//   //   });
//   //   return result.data["message"];
//   // }

//   @override
//   initState() {
//     super.initState();
//     _token = _userDetailsController.token;

//     timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (secondsRemaining != 0) {
//         setState(() {
//           secondsRemaining--;
//         });
//       } else {
//         setState(() {
//           enableResend = true;
//         });
//       }
//     });

//     _verifyPhone();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     timer.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         return true;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         key: _scaffoldKey,
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//             child: AppBar(
//               centerTitle: true,
//               flexibleSpace: Container(
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF222744),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       const Padding(
//                         padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
//                         child: Text(
//                           'Phone Verification',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//               // bottom: PreferredSize(
//               //   preferredSize: Size.fromHeight(1.0),
//               //   child: LinearProgressIndicator(
//               //     backgroundColor: Colors.white,
//               //     color: Colors.green,
//               //     value: isOtpCorrect ? 1.0 : 0.5,
//               //   ),
//               // ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: ScreenUtil().setHeight(30),
//                   ),
//                   Center(
//                     child: SizedBox(
//                       width:
//                           // width: isOtpCorrect
//                           //     ? ScreenUtil().setWidth(120)
//                           ScreenUtil().setWidth(240),
//                       // height: isOtpCorrect
//                       //     ? ScreenUtil().setHeight(120)
//                       height: ScreenUtil().setHeight(120),
//                       child: FittedBox(
//                         fit: BoxFit.fitWidth,
//                         child: SvgPicture.asset(
//                             'assets/images/Forgot Password.svg'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: ScreenUtil().setHeight(60),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Enter code',
//                         style: Theme.of(context).textTheme.headline3!.apply(
//                             color: const Color(0xFF343B67),
//                             fontWeightDelta: 4,
//                             fontSizeDelta: 2),
//                       ),
//                       SizedBox(
//                         height: ScreenUtil().setHeight(12),
//                       ),
//                       RichText(
//                         textAlign: TextAlign.center,
//                         softWrap: true,
//                         text: TextSpan(
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               height: 1.4,
//                             ),
//                             children: [
//                               const TextSpan(
//                                   text:
//                                       'We have sent an SMS with an OTP on your \nphone '),
//                               TextSpan(
//                                 text: '${this.widget.phoneNumber}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                 ),
//                               )
//                             ]),
//                       ),
//                       /* Text(
//                           "We have sent an SMS with an OTP on your\nphone ${this.widget.phoneNumber}",
//                           textAlign: TextAlign.center,
//                         ),*/
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   // Center(
//                   //   child: PinCodeTextField(
//                   //     autofocus: true,
//                   //     controller: _mpinController,
//                   //     maxLength: 6,
//                   //     highlightColor: Color(0xFF222744),
//                   //     defaultBorderColor: Colors.white,
//                   //     // highlightPinBoxColor: Colors.grey,
//                   //     pinBoxWidth: MediaQuery.of(context).size.width * 0.120,
//                   //     pinBoxHeight: 50,
//                   //     wrapAlignment: WrapAlignment.center,
//                   //     pinBoxRadius: 5.0,
//                   //     highlight: true,
//                   //     // pinBoxDecoration: ProvidedPinBoxDecoration
//                   //     //     .defaultPinBoxDecoration,
//                   //     pinTextStyle:
//                   //         TextStyle(fontSize: 22.0, color: Colors.black),
//                   //     pinTextAnimatedSwitcherTransition:
//                   //         ProvidedPinBoxTextAnimation.scalingTransition,
//                   //     pinBoxColor: Colors.white,
//                   //     pinTextAnimatedSwitcherDuration:
//                   //         Duration(milliseconds: 300),
//                   //     highlightAnimation: true,
//                   //     onDone: (pin) async {
//                   //       _pin = pin;
//                   //       if (pin.length == 6) {
//                   //         setState(() {
//                   //           validatedPincodeField = true;
//                   //         });
//                   //       }
//                   //     },
//                   //     // highlightAnimationBeginColor: Colors.black,
//                   //     // highlightAnimationEndColor: Colors.white12,
//                   //     keyboardType: TextInputType.number,
//                   //     pinBoxDecoration: (borderColor, pinBoxColor,
//                   //             {borderWidth, radius}) =>
//                   //         BoxDecoration(
//                   //       border:
//                   //           Border.all(color: borderColor, width: borderWidth),
//                   //       color: Colors.white,
//                   //       borderRadius: BorderRadius.circular(6),
//                   //       boxShadow: [
//                   //         BoxShadow(
//                   //             blurRadius: 5,
//                   //             offset: Offset(0, 5),
//                   //             color: Colors.grey[300])
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: ScreenUtil().setHeight(30),
//                   ),
//                   Visibility(
//                     visible: enableResend == false ? true : false,
//                     child: RichText(
//                         text: TextSpan(
//                       children: [
//                         const TextSpan(
//                           text: 'Send OTP again in ',
//                           style: TextStyle(fontSize: 12, color: Colors.black),
//                         ),
//                         TextSpan(
//                           text: '00:$secondsRemaining ',
//                           style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const TextSpan(
//                           text: ' seconds ',
//                           style: TextStyle(fontSize: 12, color: Colors.black),
//                         ),
//                       ],
//                     )),
//                   ),
//                   Visibility(
//                     visible: enableResend,
//                     child: TextButton(
//                         onPressed: () async {
//                           setState(() {
//                             enableResend = false;
//                             secondsRemaining = 60;
//                           });
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return Dialog(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                   child: Container(
//                                     height: 100,
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.8,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         const CustomLoader(),
//                                         const SizedBox(
//                                           width: 20,
//                                         ),
//                                         const Text(
//                                           'Resending. Please Wait!',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               });
//                           var _code =
//                               await _verifyPhoneNumber(widget.phoneNumber);
//                           if (_code == 'success') {
//                             Navigator.of(context, rootNavigator: true).pop();
//                           } else {
//                             Navigator.of(context, rootNavigator: true).pop();
//                             // Utils.showSnackBar(context,
//                             //     "Something went wrong! Cannot resend the OTP.");
//                             Utils.showToast('Something went wrong!');
//                           }
//                         },
//                         child: const Text(
//                           'Resend OTP',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         )),
//                   ),
//                   SizedBox(
//                     height: ScreenUtil().setHeight(30),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
//                     child: GestureDetector(
//                       child: Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width,
//                         height: 50.0,
//                         decoration: BoxDecoration(
//                           color: validatedPincodeField
//                               ? const Color(0xFF222744)
//                               : const Color(0xFF222744).withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         child: Text(
//                           'Verify OTP',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineSmall!
//                               .copyWith(
//                                   color: validatedPincodeField
//                                       ? Colors.white
//                                       : const Color(0xFF222744),
//                                   fontSize: 18),
//                         ),
//                       ),
//                       onTap: () async {
//                         if (this.mounted)
//                           setState(() {
//                             isResponse = true;
//                           });
//                         try {
//                           _pin = _mpinController.text;
//                           print(_pin);
//                           //trying to login with credential gained from phone auth provider
//                           await FirebaseAuth.instance
//                               .signInWithCredential(
//                                   PhoneAuthProvider.credential(
//                                       verificationId: _verificationId,
//                                       smsCode: _pin))
//                               .then((value) async {
//                             var schoolUrl = await FirebaseAuth
//                                 .instance.currentUser!
//                                 .getIdTokenResult()
//                                 .then((value) => value.claims!['schoolUrl']);
//                             setState(() {
//                               AppConfig.domainName = schoolUrl;
//                             });
//                             //fetch the school url̦
//                             var uid = FirebaseAuth.instance.currentUser!.uid;
//                             var loginId = uid + '@schoolmanagement.co.za';
//                             print(loginId);

//                             if (FirebaseAuth.instance.currentUser != null) {
//                               var role = await FirebaseAuth
//                                   .instance.currentUser!
//                                   .getIdTokenResult()
//                                   .then((value) => value.claims!['role']);
//                               await Login(loginId, '123456', role)
//                                   .getData2(context)
//                                   .then((result) async {
//                                 print(result);
//                                 Utils.showLoginToast(result!);
//                               });
//                             }
//                           });
//                         } catch (e) {
//                           FocusScope.of(context).unfocus();
//                           if (this.mounted)
//                             setState(() {
//                               isResponse = false;
//                             });
//                           // _scaffoldKey.currentState!
//                           //     .showSnackBar(const SnackBar(
//                           //   content: Text('Invalid OTP / OTP Expired.'),
//                           //   backgroundColor: Color(0xFF222744),
//                           //   duration: Duration(seconds: 2),
//                           // ));
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Invalid OTP / OTP Expired.'),
//                               backgroundColor: Color(0xFF222744),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   Container(
//                     child: isResponse == true
//                         ? const LinearProgressIndicator(
//                             backgroundColor: Colors.transparent,
//                           )
//                         : Container(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // void startTimer() {
//   //   const onsec = Duration(seconds: 1);
//   //   Timer _timer = Timer.periodic(onsec, (timer) {
//   //     if (start == 0) {
//   //       setState(() {
//   //         timer.cancel();
//   //         wait = false;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         start--;
//   //       });
//   //     }
//   //   });
//   // }

//   _verifyPhone() async {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: this.widget.phoneNumber,
//         verificationCompleted: (AuthCredential credential) async {
//           await _auth.signInWithCredential(credential).then((value) {
//             setState(() {
//               isResponse = false;
//             });
//           }).catchError((error) {});
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print(e.message);
//           Utils.showErrorToast(e.message!);
//         },
//         codeSent: (String verificationId, forceResendingToken) {
//           if (this.mounted)
//             setState(() {
//               _verificationId = verificationId;
//             });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           if (this.mounted)
//             setState(() {
//               _verificationId = verificationId;
//             });
//         },
//         timeout: const Duration(seconds: 120),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//         // showAlert(context, 'No user found for that email');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//         // showAlert(context, 'wrong-password');
//       }
//     }
//     return false;
//   }
// }
