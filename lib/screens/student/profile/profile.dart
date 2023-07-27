// Dart imports:
import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
import 'dart:io';

// Flutter imports:
// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/learner_profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LearnerProfileScreen extends StatefulWidget {
  String? id;
  String? image;
  String? rule;

  LearnerProfileScreen({Key? key, this.id, this.image}) : super(key: key);

  State<LearnerProfileScreen> createState() => _LearnerProfileScreenState();
}

class _LearnerProfileScreenState extends State<LearnerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  Future<LearnerProfile?>? profile;
  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    profile = getAllStudent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<LearnerProfile?> getAllStudent() async {
    final response = await http.get(
        Uri.parse(InfixApi.getChildren(widget.id.toString())),
        headers: Utils.setHeader(_userDetailsController.token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LearnerProfile.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWidget(
          showNotification: false,
          title: 'Profile',
        ),
        body: Padding(
          padding: EdgeInsets.all(12.sp),
          child: FutureBuilder<LearnerProfile?>(
              future: profile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!.data!.userDetails!;
                  var login = snapshot.data!.data!.parentLoginDetails!;
                  return ListView(
                    children: [
                      SizedBox(
                        height: 1.0.h,
                      ),
                      Column(
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shadowColor: HexColor('#dbdfe5'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              height: 22.h,
                              padding: EdgeInsets.all(12.sp),
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    height: 20.h - 24.sp,
                                    width: 95.sp,
                                    imageUrl: snapshot.data!.data!.userDetails!
                                            .studentPhoto ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: NetworkImage(InfixApi().root +
                                              'public/uploads/staff/demo/staff.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: NetworkImage(InfixApi().root +
                                              'public/uploads/staff/demo/staff.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.sp,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ((user.fullName).toLowerCase())
                                                  .titleCase,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600)
                                                    .fontFamily,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    (user.genderId == 1
                                                            ? 'Male'
                                                            : 'Female')
                                                        .titleCase,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)
                                                              .fontFamily,
                                                      fontSize: 10.sp,
                                                      color:
                                                          HexColor('#8a96a0'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.sp,
                                              vertical: 10.sp),
                                          decoration: BoxDecoration(
                                            color: HexColor('#f1f5f9'),
                                            borderRadius:
                                                BorderRadius.circular(10.sp),
                                          ),
                                          child: Flex(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            direction: Axis.horizontal,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ('Class'),
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 6.sp,
                                                        color:
                                                            HexColor('#8a96a0'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    Text(
                                                      (user.className
                                                          .toString()),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ('Roll No'),
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 6.sp,
                                                        color:
                                                            HexColor('#8a96a0'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    Text(
                                                      (user.rollNo.toString()),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ('Adm No'),
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 6.sp,
                                                        color:
                                                            HexColor('#8a96a0'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    Text(
                                                      ((user.admissionNo)
                                                          .toString()),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)
                                                                .fontFamily,
                                                        fontSize: 12.sp,
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
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor('#f1f5f9'),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: TabBar(
                              splashFactory: InkRipple.splashFactory,
                              splashBorderRadius: BorderRadius.circular(20.0),
                              labelColor: Colors.white,
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700)
                                    .fontFamily,
                                color: HexColor('#8a96a0'),
                                fontSize: 10.sp,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600)
                                    .fontFamily,
                                color: HexColor('#8a96a0'),
                                fontSize: 10.sp,
                              ),
                              unselectedLabelColor: HexColor('#8a96a0'),
                              indicator: BoxDecoration(
                                color: HexColor('#5374ff'),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              controller: controller,
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: const <Widget>[
                                Tab(
                                  text: 'Personal',
                                ),
                                Tab(text: 'Parent 1'),
                                Tab(text: 'Parent 2'),
                                Tab(text: 'Others'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        width: 100.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: HexColor('#f1f5f9'),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: TabBarView(
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            getProfileList(user),
                            getParentDetails(user, login),
                            getParent2Details(user, login),
                            getOtherDetails(user),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  Widget getOtherDetails(UserDetails? data) {
    return Stack(
      children: [
        // Positioned(
        //   top: 0,
        //   width: 30.sp,
        //   right: 0,
        //   child: Container(
        //     height: 28.sp,
        //     decoration: BoxDecoration(
        //       color: HexColor('#5374ff'),
        //       borderRadius: const BorderRadius.only(
        //         topRight: Radius.circular(15),
        //         bottomLeft: Radius.circular(10),
        //       ),
        //     ),
        //     alignment: Alignment.topRight,
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.edit,
        //         color: Colors.white,
        //         size: 18.sp,
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileDetailsRow(
                title: 'Height',
                value: data!.height,
              ),
              ProfileDetailsRow(
                title: 'Weight',
                value: data.weight,
              ),
              data.documentFile1 != null && data.documentFile1 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle1, data.documentFile1);
                      },
                      child: ProfileDetailsRow(
                        title: data.documentTitle1!,
                        isFile: data.documentFile1 != null &&
                            data.documentFile1 != '',
                      ),
                    )
                  : Container(),
              data.documentFile2 != null && data.documentFile2 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle2, data.documentFile2);
                      },
                      child: ProfileDetailsRow(
                        title: data.documentTitle2!,
                        isFile: data.documentFile2 != null &&
                            data.documentFile2 != '',
                      ),
                    )
                  : Container(),
              data.documentFile3 != null && data.documentFile3 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle3, data.documentFile3);
                      },
                      child: ProfileDetailsRow(
                        title: data.documentTitle3!,
                        isFile: data.documentFile3 != null &&
                            data.documentFile3 != '',
                      ),
                    )
                  : Container(),
              data.documentFile4 != null && data.documentFile4 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle4, data.documentFile4);
                      },
                      child: ProfileDetailsRow(
                        title: data.documentTitle4!,
                        isFile: data.documentFile4 != null &&
                            data.documentFile4 != '',
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget getParentDetails(UserDetails? data, ParentLoginDetails? login) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileDetailsRow(
            title: 'Full Name',
            value:
                '${data!.parent1Name} ${data.parent1MiddleName ?? ''} ${data.parent1LastName}'
                    .toLowerCase()
                    .titleCase,
          ),
          ProfileDetailsRow(
            title: 'Date of Birth',
            value: data.parent1Dob,
          ),
          ProfileDetailsRow(
            title: 'Passcode',
            value: login!.p1Pass,
          ),
          GestureDetector(
            onTap: () {
              launch('mailto:${data.parent1Email}');
            },
            child: ProfileDetailsRow(
              title: 'E-mail',
              value: data.parent1Email,
            ),
          ),
          //phone
          GestureDetector(
            onTap: () {
              launch('tel:${data.parent1Phone}');
            },
            child: ProfileDetailsRow(
              title: 'Phone',
              value: data.parent1Phone,
            ),
          ),
          // ProfileDetailsRow(
          //   title: 'RSA ID',
          //   value: data.parent1Nid,
          //   hasBorder: false,
          // ),
        ],
      ),
    );
  }

  Widget getParent2Details(UserDetails? data, ParentLoginDetails? login) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileDetailsRow(
            title: 'Full Name',
            value:
                '${data!.parent2Name ?? ''} ${data.parent2MiddleName ?? ''} ${data.parent2LastName ?? ''}'
                    .toLowerCase()
                    .titleCase,
          ),
          ProfileDetailsRow(
            title: 'Date of Birth',
            value: data.parent2Dob,
          ),
          ProfileDetailsRow(
            title: 'Passcode',
            value: login!.p2Pass,
          ),
          GestureDetector(
            onTap: () {
              launch('mailto:${data.parent2Email}');
            },
            child: ProfileDetailsRow(
              title: 'E-mail',
              value: data.parent2Email,
            ),
          ),
          //phone
          GestureDetector(
            onTap: () {
              launch('tel:${data.parent2Phone}');
            },
            child: ProfileDetailsRow(
              title: 'Phone',
              value: data.parent2Phone,
            ),
          ),
          // ProfileDetailsRow(
          //   title: 'RSA ID',
          //   value: data.parent2Nid,
          //   hasBorder: false,
          // ),
        ],
      ),
    );
  }

  Widget getProfileList(UserDetails data) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileDetailsRow(
            title: 'First Name',
            value: data.firstName,
          ),
          ProfileDetailsRow(
            title: 'Middle Name',
            value: data.middleName,
          ),
          ProfileDetailsRow(
            title: 'Last Name',
            value: data.lastName != null
                ? (data.lastName).toLowerCase().titleCase
                : '',
          ),
          ProfileDetailsRow(
            title: 'Date of Birth',
            value: data.dateOfBirth,
          ),
          //email
          GestureDetector(
            onTap: () {
              launch('mailto:${data.email}');
            },
            child: ProfileDetailsRow(
              title: 'E-mail',
              value: data.email,
            ),
          ),
          //phone
          GestureDetector(
            onTap: () {
              launch('tel:${data.mobile}');
            },
            child: ProfileDetailsRow(
              title: 'Phone',
              value: data.mobile,
            ),
          ),
          // ProfileDetailsRow(
          //   title: 'Learner\'s Id',
          //   value: data.nationalIdNo,
          //   hasBorder: false,
          // ),
        ],
      ),
    );
  }

  showDownloadAlertDialog(
      BuildContext context, String? title, String? fileUrl) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () async {
        // Navigator.pop(context, true);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (fileUrl!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadViewer(
                title: title!,
                filePath: InfixApi().root + fileUrl,
              ),
            ),
          );
        } else if (fileUrl.contains('.jpg') ||
            fileUrl.contains('.png') ||
            fileUrl.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Utils.documentViewer(InfixApi().root + fileUrl, context),
            ),
          );
        } else {
          // Utils.showSnackBar(context,
          //     "File type not supported by this app. Please use supported file viewer app.");
          Utils.showToast(
              'File type not supported by this app. Please use supported file viewer app.');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        downloadFile(fileUrl!, context, title);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Download',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text('Would you like to download the $title file?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(
      String url, BuildContext context, String? title) async {
    Dio dio = Dio();
    var received;
    var progress;

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;

    try {
      Utils.showToast('Downloading...');
      await dio.download(
          InfixApi().root + url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
        int value = (((receivedBytes / totalBytes) * 100).toInt());
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DownloadViewer(
                  title: title!,
                  filePath: InfixApi().root + url,
                ),
              ),
            );
          } else {
            await canLaunch(InfixApi().root + url)
                ? await launch(InfixApi().root + url)
                : throw 'Could not launch ${InfixApi().root + url}';
          }
        }
      });
    } catch (e) {
      print(e);
    }
    progress = 'Download Completed.Go to the download folder to find the file';
  }
}

class NewSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const NewSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Container(
          padding: EdgeInsets.only(
              left: 10.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
          decoration: BoxDecoration(
            color: HexColor('#5374ff'),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
        SizedBox(
          width: 12.sp,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (title),
              maxLines: 3,
              style: TextStyle(
                fontFamily:
                    GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              (subtitle),
              maxLines: 2,
              style: TextStyle(
                fontFamily:
                    GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                color: HexColor('#8a96a0'),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class ProfileDetailsRow extends StatelessWidget {
  ProfileDetailsRow(
      {required this.title,
      this.value,
      this.hasBorder = true,
      this.hasIcon = false,
      this.valueList,
      this.isFile = false});

  final String title;
  final bool hasIcon;
  final String? value;
  final List<String>? valueList;
  final bool hasBorder;
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 6.sp,
      ),
      width: 100.w,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: HexColor('#8e9aa6'),
                      fontSize: 8.sp,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ).fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  value != null
                      ? Text(
                          value ?? '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ).fontFamily,
                          ),
                        )
                      : valueList != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: valueList!
                                  .map(
                                    (e) => Text(
                                      '- ' + e,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Text(
                              '',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ).fontFamily,
                              ),
                            ),
                  isFile
                      ? Column(
                          children: [
                            Icon(
                              Icons.file_download_sharp,
                              size: 18.sp,
                              color: HexColor('#8e9aa6'),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              hasIcon
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: HexColor('#8e9aa6'),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 0.5.h,
          ),
          hasBorder
              ? Divider(
                  color: HexColor('#8e9aa6'),
                  thickness: 0.5,
                )
              : Container(),
        ],
      ),
    );
  }
}

bool isNullOrEmpty(Object? o) => o == null || o == '';
