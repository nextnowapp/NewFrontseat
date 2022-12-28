import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/parent/editParentProfile.dart';
import 'package:nextschool/screens/student/profile/profile.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ProfileModel.dart';
import 'package:recase/recase.dart';
// Project imports:
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ParentProfileScreen extends StatefulWidget {
  int? id;
  String? image;
  String? name;
  String? rule;
  String? token;

  ParentProfileScreen({
    this.id,
    this.image,
    this.rule,
    this.token,
    this.name,
  });

  @override
  _ParentProfileScreenState createState() => _ParentProfileScreenState(
      id: id, profileImage: image, rule: rule, token: token);
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  String? profileImage;
  late Future<ProfileModel> _parentApi;
  int? id;
  String? token;
  String? rule;
  File? _image;
  late Response response;
  FormData? formData;
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  _ParentProfileScreenState(
      {this.id, this.profileImage, this.token, this.rule});

  @override
  void initState() {
    //fethcing dynamic data from respective api for different user roles
    _parentApi = InfixApi.getParentInfo(
        userDetailsController.id.toString(), userDetailsController.token);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController.dispose();
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
    formData = FormData.fromMap(<String, dynamic>{
      'id': userDetailsController.id,
      'parent_photo': image!.path == null
          ? ''
          : await MultipartFile.fromFile(image.path, filename: image.path),
    });
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': userDetailsController.token},
      contentType: 'application/json',
    ));
    response = await dio
        .post(InfixApi.uploadParentProfilePicture, data: formData)
        .catchError((e) {
      final errorMessage = e.response!.data['message'].toString();
      Utils.showErrorToast(errorMessage);
    });
    if (response.statusCode == 200) {
      String imageFile = '';
      int? role;
      var user = response.data;
      imageFile = user['data']['parent_photo'].toString();
      //null while parent selected
      setState(() {
        profileImage = InfixApi().root + imageFile;
      });
      Utils.saveStringValue('photo', '$imageFile');
      userDetailsController.photo = imageFile;
      // Utils.showSnackBar(_scaffoldKey.currentContext, "Upload Successful",
      //     color: Colors.green);
      Utils.showToast('Upload Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Profile',
        showNotification: false,
      ),
      body: FutureBuilder<ProfileModel>(
          future: _parentApi,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.all(12.sp),
                children: [
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
                                  buildShowImagePickerModalBottomSheet(context);
                                },
                                child: Stack(children: [
                                  CachedNetworkImage(
                                    height: 20.h - 24.sp,
                                    width: 95.sp,
                                    imageUrl: profileImage ??
                                        (InfixApi().root +
                                            (widget.image.toString())),
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
                                              'assets/images/principal.png'),
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
                                              'assets/images/principal.png'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (userDetailsController.fullName
                                                  .toString()
                                                  .toLowerCase())
                                              .titleCase,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600)
                                                .fontFamily,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'username: ' +
                                                  snapshot.data!.data!
                                                      .userDetails!.username,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400)
                                                    .fontFamily,
                                                fontSize: 8.sp,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
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
                                            MainAxisAlignment.center,
                                        direction: Axis.horizontal,
                                        children: [
                                          // Flexible(
                                          //   flex: 1,
                                          //   child: Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     children: [
                                          //       Text(
                                          //         ('Gender'),
                                          //         maxLines: 3,
                                          //         style: TextStyle(
                                          //           fontFamily:
                                          //               GoogleFonts.inter(
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w600)
                                          //                   .fontFamily,
                                          //           fontSize: 6.5.sp,
                                          //           color: HexColor('#8a96a0'),
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 0.5.h,
                                          //       ),
                                          //       Text(
                                          //         ((snapshot
                                          //                 .data!
                                          //                 .data!
                                          //                 .userDetails!
                                          //                 .gender ??
                                          //             '')),
                                          //         maxLines: 2,
                                          //         style: TextStyle(
                                          //           fontFamily:
                                          //               GoogleFonts.inter(
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w600)
                                          //                   .fontFamily,
                                          //           fontSize: 9.5.sp,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ('Relation'),
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)
                                                            .fontFamily,
                                                    fontSize: 6.5.sp,
                                                    color: HexColor('#8a96a0'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 0.5.h,
                                                ),
                                                Text(
                                                  '${((snapshot.data!.data!.userDetails!.relation ?? '').toString().toLowerCase()).titleCase}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)
                                                            .fontFamily,
                                                    fontSize: 9.5.sp,
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
                      SizedBox(height: 2.h),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.sp),
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: HexColor('#f1f5f9'),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                ProfileDetailsRow(
                                  title: 'Full Name',
                                  value: (userDetailsController.fullName
                                          .toString()
                                          .toLowerCase())
                                      .titleCase,
                                ),
                                ProfileDetailsRow(
                                  title: 'Date of Birth',
                                  value: (snapshot
                                      .data!.data!.userDetails!.dateOfBirth),
                                ),
                                ProfileDetailsRow(
                                  title: 'Password',
                                  value: (snapshot
                                      .data!.data!.userDetails!.password),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch('mailto:' +
                                        '${snapshot.data!.data!.userDetails!.email}');
                                  },
                                  child: ProfileDetailsRow(
                                    title: 'E-mail',
                                    value:
                                        snapshot.data!.data!.userDetails!.email,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch('tel:' +
                                        '${snapshot.data!.data!.userDetails!.mobile}');
                                  },
                                  child: ProfileDetailsRow(
                                    title: 'Phone No',
                                    value:
                                        '${snapshot.data!.data!.userDetails!.mobile ?? ''}',
                                    hasBorder: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30.sp,
                            width: 40.sp,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: HexColor('#5374ff'),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: IconButton(
                              splashColor: Colors.blue,
                              onPressed: () {
                                var userDetails =
                                    snapshot.data!.data!.userDetails!;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditParentProfile(
                                              id: userDetails.userId,
                                              firstName: userDetails.firstName,
                                              middleName:
                                                  userDetails.middleName,
                                              lastName: userDetails.lastName,
                                              dob: userDetails.dateOfBirth,
                                              relation: userDetails.relation,
                                              email: userDetails.email,
                                              mobile: userDetails.mobile,
                                            )));
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 14.sp,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
