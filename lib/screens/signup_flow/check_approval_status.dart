import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class CheckApprovalStatusScreen extends StatefulWidget {
  const CheckApprovalStatusScreen({Key? key}) : super(key: key);

  @override
  State<CheckApprovalStatusScreen> createState() =>
      _CheckApprovalStatusScreenState();
}

class _CheckApprovalStatusScreenState extends State<CheckApprovalStatusScreen> {
  @override

  //controller
  final TextEditingController _idController = TextEditingController();
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  //focus node
  final FocusNode focusNode = FocusNode();

  initState() {
    focusNode.requestFocus();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Check Approval Status',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please find it on the screenshot you saved for reference.',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20.sp,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ).fontFamily,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Enter Registration ID',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10.sp,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ).fontFamily,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              focusNode: focusNode,
              inputFormatters: [
                FilteringTextInputFormatter(
                  RegExp('[A-Z0-9]'),
                  allow: true,
                ),
              ],
              textCapitalization: TextCapitalization.characters,
              keyboardType: TextInputType.text,
              controller: _idController,
              cursorColor: Colors.grey[400],
              cursorWidth: 1,
              maxLength: 6,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
                focusColor: Colors.white,
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
                  return 'Please enter registration id';
                } else if (value.length < 6) {
                  return 'Please enter 6 digit registration id';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedLoadingButton(
              controller: controller,
              onPressed: () async {
                //make an post request to check status using dio
                Dio dio = Dio();
                var response = await dio.post(
                  InfixApi.checkRegistrationStatus,
                  data: {
                    'registered_id': _idController.text,
                  },
                ).catchError((e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                'assets/svg/parent_onboarding/Wrong Credentials.svg'),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              e.response!.statusMessage.toString(),
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
                                (e.response!.data['message'] ??
                                        (e.response!.data ?? ''))
                                    .toString(),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                  e.response!.data['error'].toString() == 'null'
                                      ? ''
                                      : e.response!.data['error'].toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });

                //if response is 200 then navigate to success screen
                if (response.statusCode == 200) {
                  var msg = response.data['message'];
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                'assets/svg/parent_onboarding/Wrong Credentials.svg'),
                          ],
                        ),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                controller.success();
              },
              color: HexColor('#40b08f'),
              child: Text(
                'Check Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
              resetAfterDuration: true,
              resetDuration: const Duration(seconds: 3),
              successColor: const Color(0xFF222744),
            ),
          ],
        ),
      ),
    );
  }
}
