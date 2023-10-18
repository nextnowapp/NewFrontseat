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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/profile/editOthersProfile.dart';
import 'package:nextschool/screens/admin/profile/editParent1Profile.dart';
import 'package:nextschool/screens/admin/profile/editParent2Profile.dart';
import 'package:nextschool/screens/admin/profile/editPersonalProfile.dart';
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/learner_profile.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/edit_bottomsheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/exception/DioException.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String id;

  Profile({Key? key, required this.id}) : super(key: key);

  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController? controller;
  String section = 'personal';
  String? image;
  String? schoolId;
  String? _token;
  String? genderId;
  String? gender;
  int? classId;
  String errorMsg = '';
  Future<ClassList?>? classes;
  DateTime? date;
  TextEditingController dateOfBirthController = TextEditingController();
  String? profileImage;
  File? _image;
  // UserDetails? userDetails;
  var progress = '';
  var received;

  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());
  GradeListController gradeListController = Get.put(GradeListController());
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];
  Future<LearnerProfile?>? profile;
  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);

    _token = userDetailsController.token;
    profile = getAllStudent();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profile = getAllStudent();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  Future<LearnerProfile?> getAllStudent() async {
    final response = await http.get(Uri.parse(InfixApi.getChildren(widget.id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LearnerProfile.fromJson(jsonData);
    } else {
      var jsonData = jsonDecode(response.body);
      var message = jsonData['message'];
      Utils.showErrorToast(message);
    }
    return null;
  }

  Future buildShowImagePickerModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 0.3 * MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Utils.sizedBoxHeight(24),
                const Text(
                  'Upload From!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImagefromGallery();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/gallery.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImagefromcamera();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Future getImagefromcamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
      if (_image != null) {
        uploadImage(_image);
      }
    });
  }

  Future getImagefromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
      if (_image != null) {
        uploadImage(_image);
      }
    });
  }

  Future<void> uploadImage(File? image) async {
    var formData = FormData.fromMap(<String, dynamic>{
      'id': this.widget.id,
      'student_photo': image!.path == null
          ? ''
          : await MultipartFile.fromFile(image.path, filename: image.path),
    });
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _token.toString()},
      contentType: 'application/json',
    ));
    var response =
        await dio.post(InfixApi.learnerPhoto(), data: formData).catchError((e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
    });
    if (response.statusCode == 200) {
      String imageFile = '';
      int? role;
      var user = response.data;
      imageFile = user['data']['userDetails']['student_photo'].toString();
      //null while parent selected
      setState(() {
        profileImage = InfixApi().root + imageFile;
      });
      Utils.showToast('Upload Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWidget(
          title: 'Learner Profile',
          showNotification: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(12.sp),
          child: FutureBuilder<LearnerProfile?>(
            future: profile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data!.data!.userDetails!;
                var login = snapshot.data!.data!.parentLoginDetails;
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
                                GestureDetector(
                                  onTap: () {
                                    buildShowImagePickerModalBottomSheet(
                                        context);
                                  },
                                  child: Stack(children: [
                                    CachedNetworkImage(
                                      height: 20.h - 24.sp,
                                      width: 95.sp,
                                      imageUrl: profileImage ??
                                          InfixApi().root +
                                              (snapshot.data!.data!.userDetails!
                                                      .studentPhoto ??
                                                  ''),
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
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/parent.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/parent.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      width: 30.sp,
                                      right: 0,
                                      child: Container(
                                        height: 20.sp,
                                        decoration: BoxDecoration(
                                          color: HexColor('#5374ff'),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ]),
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
                                            snapshot.data!.data!.userDetails!
                                                .fullName.capitalize!,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Container(
                                            width: 50.w,
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
                                                    color: HexColor('#8a96a0'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 28.w,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    deleteProfile();
                                                  },
                                                  child: Container(
                                                    height: 20.sp,
                                                    width: 18.sp,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xFFF3F3F3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 18.sp,
                                                      // color: Color(0xFFb0b2b8),
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.sp, vertical: 10.sp),
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
                                                    (user.className.toString()),
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
                          color: HexColor('#f3f8ff'),
                          child: TabBar(
                            splashFactory: InkRipple.splashFactory,
                            splashBorderRadius: BorderRadius.circular(15.0),
                            automaticIndicatorColorAdjustment: true,
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            unselectedLabelColor: Colors.black87,
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
                              Tab(text: 'Personal'),
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
            },
          ),
        ),
      ),
    );
  }

  Widget getOtherDetails(UserDetails? data) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          width: 30.sp,
          right: 0,
          child: Container(
            height: 28.sp,
            decoration: BoxDecoration(
              color: HexColor('#5374ff'),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(10),
              ),
            ),
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100))),
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return EditBottomSheet(onEdit: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOthersProfile(
                            id: widget.id,
                            height: data!.height,
                            weight: data.weight,
                            learnerdob: data.dateOfBirth,
                            parent1dob: data.parent1Dob,
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EditableProfileDetailRow(
                title: 'Height',
                value: data!.height,
              ),
              EditableProfileDetailRow(
                title: 'Weight',
                value: data.weight,
              ),
              data.documentTitle1 != null && data.documentTitle1 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle1, data.documentFile1);
                      },
                      child: EditableProfileDetailRow(
                        title: data.documentTitle1!,
                      ),
                    )
                  : Container(),
              data.documentTitle2 != null && data.documentTitle2 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle2, data.documentFile2);
                      },
                      child: EditableProfileDetailRow(
                        title: data.documentTitle2!,
                      ),
                    )
                  : Container(),
              data.documentTitle3 != null && data.documentTitle3 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle3, data.documentFile3);
                      },
                      child: EditableProfileDetailRow(
                        title: data.documentTitle3!,
                      ),
                    )
                  : Container(),
              data.documentTitle4 != null && data.documentTitle4 != ''
                  ? InkWell(
                      onTap: () {
                        showDownloadAlertDialog(
                            context, data.documentTitle4, data.documentFile4);
                      },
                      child: EditableProfileDetailRow(
                        title: data.documentTitle4!,
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
    var date = data!.dateOfBirth.split('/');
    var learnerDob = date[2] + '-' + date[1] + '-' + date[0];
    date = login!.parent1Dob.split('/');
    var parentDob = date[2] + '-' + date[1] + '-' + date[0];
    return Stack(
      children: [
        Positioned(
          top: 0,
          width: 30.sp,
          right: 0,
          child: Container(
            height: 28.sp,
            decoration: BoxDecoration(
              color: HexColor('#5374ff'),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(10),
              ),
            ),
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100))),
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return EditBottomSheet(onEdit: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditParent1Profile(
                            id: widget.id.toString(),
                            firstName: data.parent1Name,
                            middleName: data.parent1MiddleName,
                            lastName: data.parent1LastName,
                            email: data.parent1Email,
                            learnerdob: learnerDob,
                            mobile: data.parent1Phone,
                            nid: data.parent1Nid,
                            occupation: data.parent1Occupation,
                            dob: parentDob,
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EditableProfileDetailRow(
                title: 'Full Name',
                value:
                    '${data.parent1Name} ${data.parent1MiddleName ?? ''} ${data.parent1LastName}'
                        .toLowerCase()
                        .titleCase,
              ),
              EditableProfileDetailRow(
                title: 'Date of Birth',
                value: data.parent1Dob != null
                    ? DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(parentDob))
                    : '',
              ),
              EditableProfileDetailRow(
                title: 'Passcode',
                value: login.p1Pass,
              ),
              EditableProfileDetailRow(
                title: 'Occupation',
                value: data.parent1Occupation,
              ),
              EditableProfileDetailRow(
                title: 'Phone',
                value: data.parent1Phone,
              ),
              EditableProfileDetailRow(
                title: 'E-mail',
                value: data.parent1Email,
              ),
              // EditableProfileDetailRow(
              //   title: 'RSA ID',
              //   value: data.parent1Nid,
              //   hasBorder: false,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getParent2Details(UserDetails? data, ParentLoginDetails? login) {
    //to convert dd/mm/yyyy to yyyy-mm-dd to print in date format
    var date;
    var parentDob;
    if (login!.parent2Dob != null) {
      date = login.parent2Dob!.split('/');
      parentDob = date[2] + '-' + date[1] + '-' + date[0];
    }
    return Stack(
      children: [
        Positioned(
          top: 0,
          width: 30.sp,
          right: 0,
          child: Container(
            height: 28.sp,
            decoration: BoxDecoration(
              color: HexColor('#5374ff'),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(10),
              ),
            ),
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100))),
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return EditBottomSheet(onEdit: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditParent2Profile(
                                  dob: data!.parent2Dob,
                                  email: data.parent2Email,
                                  firstName: data.parent2Name,
                                  lastName: data.parent2LastName,
                                  middleName: data.parent2MiddleName,
                                  mobile: data.parent2Phone,
                                  nid: data.parent2Nid,
                                  occupation: data.parent2Occupation,
                                  id: widget.id.toString(),
                                )),
                      );
                    });
                  },
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EditableProfileDetailRow(
                title: 'Full Name',
                value:
                    '${data!.parent2Name ?? ''} ${data.parent2MiddleName ?? ''} ${data.parent2LastName ?? ''}'
                        .toLowerCase()
                        .titleCase,
              ),
              EditableProfileDetailRow(
                title: 'Date of Birth',
                value: login.parent2Dob != null && login.parent2Dob != ''
                    ? DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(parentDob))
                    : '',
              ),
              EditableProfileDetailRow(
                title: 'Passcode',
                value: login.p2Pass,
              ),
              EditableProfileDetailRow(
                title: 'Occupation',
                value: data.parent2Occupation,
              ),
              EditableProfileDetailRow(
                title: 'Phone',
                value: data.parent2Phone,
              ),
              EditableProfileDetailRow(
                title: 'E-mail',
                value: data.parent2Email,
              ),
              // EditableProfileDetailRow(
              //   title: 'RSA ID',
              //   value: data.parent2Nid,
              //   hasBorder: false,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getProfileList(UserDetails data) {
    var date = data.dateOfBirth.split('/');
    var learnerDob = date[2] + '-' + date[1] + '-' + date[0];
    date = data.parent1Dob.split('/');
    var parentDob = date[2] + '-' + date[1] + '-' + date[0];

    return Stack(
      children: [
        Positioned(
          top: 0,
          width: 30.sp,
          right: 0,
          child: Container(
            height: 28.sp,
            decoration: BoxDecoration(
              color: HexColor('#5374ff'),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(10),
              ),
            ),
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100))),
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return EditBottomSheet(onEdit: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPersonalProfile(
                            id: widget.id,
                            genderId: data.genderId!,
                            classId: data.classId,
                            firstName: data.firstName,
                            gender: data.genderId == 1 ? 'Male' : 'Female',
                            className: data.className,
                            middleName: data.middleName,
                            lastName: data.lastName,
                            dob: learnerDob,
                            email: data.email,
                            phone: data.mobile,
                            nid: data.nationalIdNo,
                            parent1dob: parentDob,
                          ),
                        ),
                      );
                    });
                  },
                );

                setState(() {});
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EditableProfileDetailRow(
                title: 'First Name',
                value: data.firstName,
              ),
              EditableProfileDetailRow(
                title: 'Middle Name',
                value: data.middleName,
              ),
              EditableProfileDetailRow(
                title: 'Last Name',
                value: data.lastName != null
                    ? (data.lastName).toLowerCase().titleCase
                    : '',
              ),
              EditableProfileDetailRow(
                title: 'Date of Birth',
                value: data.dateOfBirth != null
                    ? DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(learnerDob))
                    : '',
              ),
              EditableProfileDetailRow(
                title: 'E-mail',
                value: data.email,
              ),
              EditableProfileDetailRow(
                title: 'Phone',
                value: data.mobile,
              ),
              // EditableProfileDetailRow(
              //   title: 'RSA ID',
              //   value: data.nationalIdNo,
              //   hasBorder: false,
              // ),
            ],
          ),
        ),
      ],
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

  deleteProfile() {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      animationCurve: Curves.fastOutSlowIn,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(200), topLeft: Radius.circular(200))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            Dio dio = Dio(BaseOptions(
              headers: {'Authorization': _token.toString()},
              contentType: 'application/json',
            ));
            // var studId = UserDetails.fromJson(
            //         jsonDecode(snapshot.data![6].value!))
            //     .studId;
            var response = await dio
                .get(
              InfixApi.deleteLearner(widget.id.toString()),
            )
                .catchError((e) {
              final errorMessage = DioExceptions.fromDioException(e).toString();

              Utils.showToast(errorMessage);
            });

            if (response.statusCode == 200) {
              Utils.showToast('Successfully deleted learner');
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Utils.showToast('Failed to delete learner');
            }
          },
          title: 'Delete Learner',
        );
      },
    );
  }
}

class EditableProfileDetailRow extends StatelessWidget {
  EditableProfileDetailRow(
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
                            SizedBox(
                              height: 0.5.h,
                            ),
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
