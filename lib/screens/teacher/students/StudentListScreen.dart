// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/screens/student/crud/Add%20learners/add_learner.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/Student.dart';
import 'package:nextschool/utils/widget/StudentSearchRow.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/apis/Apis.dart';

// ignore: must_be_immutable
class StudentListScreen extends StatefulWidget {
  int? classCode;
  int? sectionCode;
  String? name;
  String? roll;
  String? url;
  String? status;
  String? token;
  String? date;

  StudentListScreen(
      {this.classCode,
      this.sectionCode,
      this.name,
      this.roll,
      this.url,
      this.status,
      this.token,
      this.date});

  @override
  _StudentListScreenState createState() => _StudentListScreenState(
        classCode: classCode,
        name: name,
        roll: roll,
        url: url,
        status: status,
        date: date,
        token: token,
      );
}

class _StudentListScreenState extends State<StudentListScreen> {
  int? classCode;
  String? name;
  String? roll;
  String? url;
  Future<StudentList?>? students;
  String? status;
  String? token;
  String? date;

  _StudentListScreenState(
      {this.classCode,
      this.name,
      this.roll,
      this.url,
      this.status,
      this.date,
      this.token});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      students = getAllStudent();
    });
  }

  var userDetailController = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: status == 'attendance' ? 'Attendance List' : 'Learner List'),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      floatingActionButton: status == 'attendance' || status == 'remark'
          ? null
          : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddLearner()),
                );
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: HexColor('#4e88ff')),
                  child: SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        SvgPicture.asset('assets/images/Add staff.svg'),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Add Learner',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      body: Column(
        children: [
          Visibility(
            visible: status == null,
            child: Column(
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
                              Uri.parse(InfixApi.exportLearners()),
                              headers: Utils.setHeader(
                                  userDetailController.token.toString()));
                          if (response.statusCode == 200) {
                            //file bytes
                            var bytes = response.bodyBytes;
                            //file name
                            var fileName =
                                classCode!.toString() + 'Learner List';
                            var status = await Permission.storage.status;
                            if (!status.isGranted) {
                              await Permission.storage.request();
                            }
                            // the downloads folder path
                            String tempPath = '/storage/emulated/0/Download';
                            var filePath = tempPath + '/${fileName}.xlsx';
                            final buffer = bytes.buffer;
                            //save file
                            try {
                              await File(filePath).writeAsBytes(
                                  buffer.asUint8List(bytes.offsetInBytes,
                                      bytes.lengthInBytes));

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
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<StudentList?>(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('STATUS::: $status');
                  if (snapshot.data!.students.length == 0) {
                    return Utils.noDataTextWidget();
                  } else
                    return ListView.builder(
                      itemCount: snapshot.data!.students.length,
                      itemBuilder: (context, index) {
                        return StudentRow(
                          snapshot.data!.students[index],
                          status: status,
                          token: token,
                        );
                      },
                    );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    direction: ShimmerDirection.ltr,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Skelton(
                                  height: 70,
                                  width: 70,
                                  radius: 70,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Skelton(
                                      height: 16.sp,
                                      width: 50.w,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Skelton(
                                          height: 12.sp,
                                          width: 30.w,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Utils.sizedBoxWidth(16),
                                        (status == 'attendance')
                                            ? Skelton(
                                                height: 12.sp,
                                                width: 30.w,
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<StudentList?>? getAllStudent() async {
    final response = await http.get(Uri.parse(url!),
        headers: Utils.setHeader(token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}

class Skelton extends StatelessWidget {
  const Skelton({
    Key? key,
    this.height,
    this.width,
    this.radius,
  }) : super(key: key);

  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 0,
      width: width ?? 0,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 16),
      ),
    );
  }
}
