import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';

class PendingApprovalScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String schoolLogo;
  const PendingApprovalScreen(
      {Key? key, required this.data, required this.schoolLogo})
      : super(key: key);

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  //screenshot controller
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void didChangeDependencies() async {
    await screenshotController.captureAndSave('/storage/emulated/0/Download');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return WillPopScope(
      onWillPop: () async => false,
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(
                      height: 4.h,
                    ),
                    SvgPicture.asset(
                      'assets/svg/Approval Pending.svg',
                      height: 150,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          'Thank you ' +
                              widget.data['l_first_name'] +
                              ' for completing your\nschool data registration.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    const Text(
                      'Your approval is pending.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          'Approval is pending with class teacher.\n Please allow 24 hours for approval.\n Thereafter, you can contact your class teacher.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0, top: 5),
                      child: Text('Till then you can enjoy our free services.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                    ),
                    //card with login details
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 5)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Row(
                              children: [
                                const Spacer(),

                                const Text(
                                  'Login Details',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87),
                                ),
                                //share icon
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await screenshotController.captureAndSave(
                                        '/storage/emulated/0/Download',
                                        fileName: 'registration.jpg');
                                    Utils.showToast(
                                        'Screenshot saved in Download folder');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#00b88f'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.file_download_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Registration ID',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      widget.data['approval_request_id'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Use this ID to track your application status.',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ).fontFamily,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                Text(
                                  widget.data['p_dob'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Passcode',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                Text(
                                  widget.data['p_pass'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Username',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                Text(
                                  widget.data['p_username'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'E-mail',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                Text(
                                  widget.data['p_email'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '(Please take a screenshot for your reference)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          await screenshotController
                              .captureAndSave('/storage/emulated/0/Download');
                          Utils.saveBooleanValue('isLogged', false);
                          Utils.saveStringValue('rule', '6');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return AppFunction.getFunctions(context, '6', null);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: HexColor('#3db591'),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
