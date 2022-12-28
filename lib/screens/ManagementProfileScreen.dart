import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/subject_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/profile/edit_management_profile.dart';
import 'package:nextschool/screens/student/profile/profile.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/Classes.dart';
import 'package:nextschool/utils/model/ProfileModel.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  String? profileImage;
  late Future<ProfileModel> _future;
  late int id;
  late String token;
  File? _image;
  late Response response;
  FormData? formData;
  String errorMsg = '';
  String? _selectedClass = 'Select Class';
  int? _selectedClassId;
  int? classId;
  String? _selectedSubjects;
  GradeListController _gradeListController = Get.put(GradeListController());
  UserDetailsController _userDetailsController = Get.put(
    UserDetailsController(),
  );
  SubjectListController subjectListController =
      Get.put(SubjectListController());

  _ManagementScreenState();

  @override
  void initState() {
    id = _userDetailsController.id;
    token = _userDetailsController.token;
    _future = InfixApi.getPrincipalInfo(id.toString(), token.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                          ),
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
      'id': _userDetailsController.id,
      'staff_photo': image!.path == null
          ? ''
          : await MultipartFile.fromFile(image.path, filename: image.path),
    });
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': token.toString()},
      contentType: 'application/json',
    ));
    response = await dio
        .post(InfixApi.uploadProfilePicture, data: formData)
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Navigator.of(context).pop();
    });
    if (response.statusCode == 200) {
      String imageFile = '';

      var user = response.data;
      imageFile = user['data']['userDetails']['staff_photo'].toString();
      //null while parent selected
      setState(() {
        profileImage = InfixApi().root + imageFile;
      });
      UserDetailsController userDetailsController =
          Get.put(UserDetailsController());
      Utils.saveStringValue('photo', '$imageFile');
      userDetailsController.photo = imageFile;
      Utils.showToast('Upload Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Profile',
        showNotification: false,
      ),
      body: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
          if (snapshot.hasData) {
            _selectedClass = snapshot.data!.data!.userDetails!.className ?? '';
            _selectedClassId = snapshot.data!.data!.userDetails!.classId ?? 0;
            var dobL = snapshot.data!.data!.userDetails!.dateOfBirth;
            var date = dobL.split('/');
            var dob = date[2] + '-' + date[1] + '-' + date[0];
            return ListView(
              padding: EdgeInsets.all(12.sp),
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
                                      (snapshot
                                              .data!.data!.userDetails!.photo ??
                                          '')),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.data!.userDetails!.fullName
                                        .capitalize!,
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
                                        snapshot.data!.data!.userDetails!
                                            .designation!,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600)
                                              .fontFamily,
                                          fontSize: 10.sp,
                                          color: HexColor('#8a96a0'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'username: ' +
                                            snapshot.data!.data!.userDetails!
                                                .username,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400)
                                              .fontFamily,
                                          fontSize: 10.sp,
                                          color: Colors.grey,
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
                                  borderRadius: BorderRadius.circular(10.sp),
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
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 6.5.sp,
                                              color: HexColor('#8a96a0'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                            (snapshot.data == null
                                                ? 'Loading...'
                                                : snapshot
                                                        .data!
                                                        .data!
                                                        .userDetails!
                                                        .className ??
                                                    ''
                                            //     snapshot.data==null?" ":snapshot.data!.data!.userDetails!
                                            //     .className
                                            ),
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 9.5.sp,
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
                                            ('Staff No'),
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 6.5.sp,
                                              color: HexColor('#8a96a0'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                            snapshot.data!.data!.userDetails!
                                                .staffNo
                                                .toString(),
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 9.5.sp,
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
                                            ('Gender'),
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 6.5.sp,
                                              color: HexColor('#8a96a0'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                            (snapshot.data!.data!.userDetails!
                                                        .genderId ==
                                                    1
                                                ? 'Male'
                                                : 'Female'),
                                            maxLines: 2,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
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
                SizedBox(
                  height: 2.h,
                ),
                Column(
                  children: [
                    Stack(
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
                                value: snapshot.data!.data!.userDetails!
                                    .fullName.capitalize,
                              ),
                              ProfileDetailsRow(
                                title: 'Gender',
                                value: (snapshot.data!.data!.userDetails!
                                            .genderId ==
                                        1
                                    ? 'Male'
                                    : 'Female'),
                              ),
                              ProfileDetailsRow(
                                title: 'My Subjects',
                                valueList: snapshot
                                    .data!.data!.userDetails!.subjectNames,
                              ),
                              ProfileDetailsRow(
                                title: 'Birthday',
                                value: DateFormat('dd MMM')
                                    .format(DateTime.parse(dob)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data!.data!.userDetails!.email !=
                                          null &&
                                      snapshot.data!.data!.userDetails!.email!
                                          .isNotEmpty) {
                                    launch(
                                        'mailto:${snapshot.data!.data!.userDetails!.email}');
                                  }
                                },
                                child: ProfileDetailsRow(
                                  title: 'E-mail',
                                  value: snapshot.data == null
                                      ? 'Loading...'
                                      : snapshot.data!.data!.userDetails!.email,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data!.data!.userDetails!
                                              .mobile !=
                                          null &&
                                      snapshot.data!.data!.userDetails!.mobile!
                                          .isNotEmpty) {
                                    launch(
                                        "tel://${(snapshot.data!.data!.userDetails!.mobile!).replaceFirst('0', '+27')}");
                                  }
                                },
                                child: ProfileDetailsRow(
                                  title: 'Mobile',
                                  value: snapshot.data == null
                                      ? 'Loading...'
                                      : snapshot.data!.data!.userDetails!
                                              .mobile ??
                                          '',
                                  hasBorder: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 30.sp,
                            alignment: Alignment.center,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditManagementProfileScreen(
                                      staff: snapshot.data,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 14.sp,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    const NewSection(
                      icon: CupertinoIcons.slider_horizontal_3,
                      title: 'Responsibilities',
                      subtitle: 'Update Class and Subjects',
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => getClassNewDropdown(
                                  _gradeListController.gradeList)),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Obx(
                                () => getSubjectListDropDown(
                                    subjectListController.subjectList,
                                    snapshot.data!.data!.userDetails!
                                            .subjectNames ??
                                        null),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
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
    );
  }

  Widget getSubjectListDropDown(
      List<TeacherSubject>? subjectList, List<String>? selectedSubject) {
    List<String> items = selectedSubject == null ? [] : selectedSubject;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Subjects*',
          style: TextStyle(
            color: HexColor('#8e9aa6'),
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>.multiSelection(
          autoValidateMode: AutovalidateMode.onUserInteraction,
          items: subjectList!.map((e) => e.subjectName!).toList(),
          enabled: true,
          filterFn: (item, filter) {
            return item.toLowerCase().contains(filter.toLowerCase());
          },
          dropdownBuilder: (context, selectedItem) {
            return Wrap(
              children: selectedItem
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: HexColor('#5374ff'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            dropdownSearchDecoration: InputDecoration(
              focusColor: HexColor('#5374ff'),
              isCollapsed: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 6.sp,
                vertical: 6.sp,
              ),
              constraints: BoxConstraints(
                maxHeight: 30.h,
                maxWidth: 100.w,
                minWidth: 90.w,
              ),
              fillColor: Colors.white,
              filled: true,
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#d5dce0'),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#5374ff'),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
            ),
          ),
          selectedItems: items,
          onChanged: (newValue) {
            setState(() {
              //find the id of all selected items and store it in a string with comma separated
              _selectedSubjects = newValue
                  .map((e) => subjectList
                      .firstWhere((element) => element.subjectName == e)
                      .subjectId)
                  .join(',');
            });

            try {
              FormData form = FormData.fromMap({
                'selected_ids': _selectedSubjects,
                'staff_id': _userDetailsController.id.toString()
              });
              Dio()
                  .post(InfixApi.staffSubjectUpdate(),
                      data: form,
                      options: Options(
                        headers: Utils.setHeader(
                            _userDetailsController.token.toString()),
                      ))
                  .then((response) {
                if (response.statusCode == 200) {
                  var jsonData = response.data;
                  if (jsonData['success'] == true) {
                    Utils.showThemeToast(
                      jsonData['message'],
                    );
                  }
                } else {
                  errorMsg = '';
                  throw Exception('Failed to load');
                }
              });
            } catch (e) {
              print(e);
            }
          },
          onSaved: (newValue) {
            setState(() {
              //find the id of all selected items and store it in a string with comma separated
              _selectedSubjects = newValue!
                  .map((e) => subjectList
                      .firstWhere((element) => element.subjectName == e)
                      .subjectId)
                  .join(',');
            });

            try {
              FormData form = FormData.fromMap({
                'selected_ids': _selectedSubjects,
                'staff_id': _userDetailsController.id.toString()
              });
              Dio()
                  .post(InfixApi.staffSubjectUpdate(),
                      data: form,
                      options: Options(
                        headers: Utils.setHeader(
                            _userDetailsController.token.toString()),
                      ))
                  .then((response) {
                if (response.statusCode == 200) {
                  var jsonData = response.data;
                  if (jsonData['success'] == true) {
                    Utils.showThemeToast(
                      jsonData['message'],
                    );
                  }
                } else {
                  errorMsg = '';
                  throw Exception('Failed to load');
                }
              });
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Class:',
          style: TextStyle(
            color: HexColor('#8e9aa6'),
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          items: classes.map((e) => e.name!).toList(),
          dropdownButtonProps: const DropdownButtonProps(
            icon: Icon(Icons.arrow_drop_down),
          ),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight:
                  (classes.length * 60) < 200 ? (classes.length * 60) : 200,
            ),
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
          ),
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },
          clearButtonProps: const ClearButtonProps(
            isVisible: true,
            icon: Icon(Icons.clear),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            dropdownSearchDecoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#d5dce0'),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#5374ff'),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value != null && errorMsg != '') {
              return errorMsg;
            }
            return null;
          },
          onChanged: (dynamic newValue) async {
            setState(() {
              errorMsg = '';
              _selectedClass = newValue;

              classId = getCode(classes, newValue);
            });

            //http request to know the whom class is assigned
            try {
              FormData form = newValue == null
                  ? FormData.fromMap({
                      'class': '',
                      'staff_id': _userDetailsController.id,
                    })
                  : FormData.fromMap({
                      'class': classId,
                      'staff_id': _userDetailsController.id,
                    });
              Dio()
                  .post(InfixApi.staffClassUpdate(),
                      data: form,
                      options: Options(
                        headers: Utils.setHeader(
                            _userDetailsController.token.toString()),
                      ))
                  .then((response) {
                if (response.statusCode == 200) {
                  var jsonData = response.data;
                  if (jsonData['success'] == true) {
                    Utils.showThemeToast(
                      jsonData['message'],
                    );
                  }
                } else {
                  errorMsg = '';
                  throw Exception('Failed to load');
                }
              }).catchError((error) {
                switch (error.response.statusCode) {
                  case 400:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                    break;
                  case 401:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                    break;
                  case 403:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                    break;
                  case 404:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                    break;
                  case 500:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                    break;
                  default:
                    setState(() {
                      errorMsg = error.response.data['message'];
                    });
                }
              });
            } catch (e) {
              Utils.showErrorToast(e.toString());
            }
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedClass,
        ),
      ],
    );
  }

  int? getCode<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }
}
