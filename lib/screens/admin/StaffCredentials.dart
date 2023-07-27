import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../controller/user_controller.dart';
import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../../utils/model/StaffCredentialsModel.dart';
import '../../utils/widget/customLoader.dart';
import '../../utils/widget/textwidget.dart';

class StaffCredentialScreen extends StatefulWidget {
  const StaffCredentialScreen({Key? key}) : super(key: key);

  @override
  State<StaffCredentialScreen> createState() => _StaffCredentialScreenState();
}

class _StaffCredentialScreenState extends State<StaffCredentialScreen> {
  Future<StaffCredentialsModel?>? credentials;
  String? image;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    credentials = getStaffs();
    super.initState();
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#e8e8e8'),
      appBar: CustomAppBarWidget(
        title: 'Staff Credentials',
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: HexColor('#3bb28d')),
                      alignment: Alignment.center,
                      width: 30.w,
                      height: 35.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/Export.svg'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Export data',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ).fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    final response = await http.get(
                        Uri.parse(InfixApi.exportStaffCredentials()),
                        headers: Utils.setHeader(
                            _userDetailsController.token.toString()));
                    if (response.statusCode == 200) {
                      //file bytes
                      var bytes = response.bodyBytes;
                      //file name
                      var fileName = 'StaffCredentials';
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      }
                      // the downloads folder path
                      String tempPath = '/storage/emulated/0/Download';
                      log(tempPath);
                      var filePath = tempPath + '/${fileName}.xlsx';
                      final buffer = bytes.buffer;
                      //save file
                      try {
                        await File(filePath).writeAsBytes(buffer.asUint8List(
                            bytes.offsetInBytes, bytes.lengthInBytes));

                        // view file using system default viewer
                        OpenFilex.open(filePath);
                        Utils.showToast('File Saved at $filePath');
                      } catch (e) {
                        Utils.showToast('Error in downloading file');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<StaffCredentialsModel?>(
                future: credentials,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CustomLoader());
                  } else {
                    if (snapshot.data == null) {
                      return Center(
                          child: TextWidget(
                        txt: 'No Data found',
                        size: 12.sp,
                        weight: FontWeight.bold,
                      ));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.data![index];
                          if (data.staffPhoto == null ||
                              data.staffPhoto == '') {
                            image =
                                'https://i.pinimg.com/736x/ec/e2/b0/ece2b0f541d47e4078aef33ffd22777e.jpg';
                          } else {
                            for (var i = 0;
                                i < snapshot.data!.data!.length;
                                i++) {}
                            image = InfixApi().root + data.staffPhoto!;
                          }

                          return Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.sp),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 17.w,
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(image!),
                                                fit: BoxFit.cover),
                                            color: index % 2 == 0
                                                ? HexColor('#feeaa3')
                                                : HexColor('#ffc8d5'),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 55.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Text(
                                                      'First Name : ${data.firstName}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 10.sp,
                                                        color:
                                                            HexColor('#787b8d'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Text(
                                                      'Last Name : ${data.lastName}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 10.sp,
                                                        color:
                                                            HexColor('#787b8d'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: data.className != null
                                                      ? HexColor('#4fbe9e')
                                                      : HexColor('#ff4860'),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 3,
                                                    right: 3),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Class\nAssigned',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 7.sp,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 1,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      data.className ?? 'NA',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 7.sp,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 3.6.h,
                                    decoration: BoxDecoration(
                                        color: HexColor('#f2f4f7'),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              size: 13.sp,
                                              color: HexColor('#5f6378'),
                                            ),
                                            const SizedBox(width: 3),
                                            TextWidget(
                                              txt: 'DOB : ${data.dateOfBirth}',
                                              size: 10.sp,
                                              clr: HexColor('#777c8e'),
                                              weight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          thickness: 2,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.lock,
                                              size: 13.sp,
                                              color: HexColor('#5f6378'),
                                            ),
                                            const SizedBox(width: 3),
                                            TextWidget(
                                              txt: data.isObscure == false
                                                  ? 'Passcode : ******'
                                                  : 'Passcode : ${data.password}',
                                              size: 10.sp,
                                              clr: HexColor('#777c8e'),
                                              weight: FontWeight.w500,
                                            ),
                                            const SizedBox(width: 3),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  data.isObscure =
                                                      !data.isObscure!;
                                                });
                                              },
                                              child: Icon(
                                                data.isObscure == false
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: HexColor('#777c8e'),
                                                size: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future<StaffCredentialsModel?>? getStaffs() async {
    final response = await http.get(
        Uri.parse(InfixApi.getAllStaffCredentials(_userDetailsController.id)),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffCredentialsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }
}
