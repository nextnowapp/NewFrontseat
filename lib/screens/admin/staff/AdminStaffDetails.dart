// Flutter imports:
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/staff_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/staff/AddStaffScreen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
// Project imports:
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/edit_bottomsheet.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/designation_list_controller.dart';
import '../../../controller/subject_list_controller.dart';
import '../../../utils/model/Classes.dart';
import '../../../utils/model/designation_model.dart';
import '../../student/profile/profile.dart';

// ignore: must_be_immutable
class StaffDetailsScreen extends StatefulWidget {
  int index;

  StaffDetailsScreen(this.index);

  @override
  _StaffDetailsScreenState createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  String? _token;
  DateTime? date;
  var userRole;
  String? genderId;
  bool isResponse = false;
  int? roleId;
  String? _id;
  int? designationId;
  String? gender;
  String? role;
  var _staffPhoto;
  String? updatedProfilePic;

  String errorMsg = '';

  Future<TeacherSubjectList>? subjects;
  late TeacherSubjectList subjectList;

  String? _selectedSubjects;
  List<String> _selectedsubs = [];
  String? _selectedDesignation;

  int? classId;
  String? _selectedClass;
  Future<ClassList?>? classes;
  File? _image;
  FormData? formData;
  String? id;
  late Response response;
  String? profileImage;
  DateTime minDate = DateTime(DateTime.now().year - 150);
  DateTime? _dateOfBirth;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  TextEditingController nameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  UserDetailsController _userDetailsController = Get.put(
    UserDetailsController(),
  );

  GradeListController gradeListController = Get.put(GradeListController());
  DesignationListController designationListController =
      Get.put(DesignationListController());
  SubjectListController subjectListController =
      Get.put(SubjectListController());
  StaffListController staff = Get.put(StaffListController());
  List _genders = [
    {'id': '1', 'gender': 'Male'},
    {'id': '2', 'gender': 'Female'}
  ];

  @override
  void initState() {
    super.initState();
    _selectedsubs = staff.staffs[widget.index].subjectNames ?? [];
    _selectedClass = staff.staffs[widget.index].className ?? '';
    profileImage = InfixApi().root + (staff.staffs[widget.index].photo ?? '');
    _token = _userDetailsController.token;
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
      'id': staff.staffs[widget.index].userId,
      'staff_photo': image!.path == null
          ? ''
          : await MultipartFile.fromFile(image.path, filename: image.path),
    });

    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _token.toString()},
      contentType: 'application/json',
    ));
    response =
        await dio.post(InfixApi.staffPhoto(), data: formData).catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Navigator.of(context).pop();
    });
    if (response.statusCode == 200) {
      String imageFile = '';
      int? role;
      var user = response.data;
      role = user['data']['userDetails']['role_id'];
      imageFile = user['data']['userDetails']['staff_photo'].toString();
      //null while parent selected
      setState(() {
        profileImage = InfixApi().root + imageFile;
      });
      staff.fetchData(_userDetailsController.id);

      Utils.showToast('Upload Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Staff Details',
        showNotification: false,
      ),
      body: ListView(
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
                  height: 24.h,
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
                        child: Stack(
                          children: [
                            Obx(() {
                              return CachedNetworkImage(
                                height: 20.h - 24.sp,
                                width: 95.sp,
                                imageUrl: InfixApi().root +
                                    (staff.staffs[widget.index].photo ?? ''),
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
                              );
                            }),
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
                          ],
                        ),
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
                                Obx(() {
                                  return Text(
                                    ((staff.staffs[widget.index].fullName)
                                            .toLowerCase())
                                        .titleCase,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600)
                                          .fontFamily,
                                      fontSize: 14.sp,
                                    ),
                                  );
                                }),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        staff.staffs[widget.index].designation!,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600)
                                              .fontFamily,
                                          fontSize: 10.sp,
                                          color: HexColor('#8a96a0'),
                                        ),
                                      );
                                    }),
                                    InkWell(
                                      onTap: () {
                                        deleteProfile();
                                      },
                                      child: Container(
                                        height: 20.sp,
                                        width: 18.sp,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
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
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       'username: ' +
                                //           staff.staffs[widget.index].username,
                                //       maxLines: 2,
                                //       style: TextStyle(
                                //         fontFamily: GoogleFonts.inter(
                                //           fontWeight: FontWeight.w400,
                                //         ).fontFamily,
                                //         fontSize: 10.sp,
                                //         color: Colors.grey,
                                //       ),
                                //     ),
                                //   ],
                                // ),
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
                                                    fontWeight: FontWeight.w600)
                                                .fontFamily,
                                            fontSize: 6.sp,
                                            color: HexColor('#8a96a0'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Obx(() {
                                          return Text(
                                            staff.staffs[widget.index]
                                                    .className ??
                                                '',
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 12.sp,
                                            ),
                                          );
                                        }),
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
                                          ('Staff No'),
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600)
                                                .fontFamily,
                                            fontSize: 6.sp,
                                            color: HexColor('#8a96a0'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Obx(() {
                                          return Text(
                                            staff.staffs[widget.index].staffId
                                                .toString(),
                                            maxLines: 2,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 12.sp,
                                            ),
                                          );
                                        }),
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
                                                    fontWeight: FontWeight.w600)
                                                .fontFamily,
                                            fontSize: 6.sp,
                                            color: HexColor('#8a96a0'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Obx(() {
                                          return Text(
                                            ((staff.staffs[widget.index]
                                                            .genderId ==
                                                        1
                                                    ? 'Male'
                                                    : 'Female')
                                                .titleCase),
                                            maxLines: 2,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600)
                                                  .fontFamily,
                                              fontSize: 10.sp,
                                            ),
                                          );
                                        }),
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
                        Obx(() {
                          return ProfileDetailsRow(
                            title: 'First Name',
                            value: staff.staffs[widget.index].firstName,
                          );
                        }),
                        Obx(() {
                          return ProfileDetailsRow(
                            title: 'Middle Name',
                            value: staff.staffs[widget.index].middleName,
                          );
                        }),
                        Obx(() {
                          return ProfileDetailsRow(
                            title: 'Last Name',
                            value: staff.staffs[widget.index].lastName != null
                                ? (staff.staffs[widget.index].lastName)
                                    .toLowerCase()
                                    .titleCase
                                : '',
                          );
                        }),
                        Obx(() {
                          var date = staff.staffs[widget.index].dob.split('/');

                          var newDate = date[2] + '-' + date[1] + '-' + date[0];
                          print(newDate);
                          return ProfileDetailsRow(
                            title: 'Birthday',
                            value: staff.staffs[widget.index].dob != null
                                ? DateFormat('dd MMM').format(DateTime.parse(
                                    newDate,
                                  ))
                                : '',
                          );
                        }),
                        Obx(() {
                          return ProfileDetailsRow(
                            title: 'E-mail',
                            value: staff.staffs[widget.index].email,
                          );
                        }),
                        Obx(() {
                          return ProfileDetailsRow(
                            title: 'Phone',
                            value: staff.staffs[widget.index].phone,
                          );
                        }),
                        // Obx(() {
                        //   return ProfileDetailsRow(
                        //     title: 'RSA ID',
                        //     value: staff.staffs[widget.index].nid,
                        //     hasBorder: false,
                        //   );
                        // }),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      editNoticePromptDialog(
                        context,
                      );
                    },
                    child: Container(
                      height: 35.sp,
                      width: 35.sp,
                      decoration: BoxDecoration(
                        color: HexColor('#5374ff'),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14.sp,
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
                        Obx(() =>
                            getClassNewDropdown(gradeListController.gradeList)),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Obx(
                          () => getSubjectListDropDown(
                              subjectListController.subjectList, _selectedsubs),
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
        ],
      ),
    );
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
              InfixApi.deleteStaff(
                  staff.staffs[widget.index].userId.toString()),
            )
                .catchError((e) {
              var error = e.response.data['message'];

              Utils.showToast(error);

              return e;
            });

            if (response.statusCode == 200) {
              Utils.showToast('Staff Deleted Successfully');
              await staff.fetchData(_userDetailsController.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
          title: 'Delete Staff',
        );
      },
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
                'staff_id': staff.staffs[widget.index].userId,
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
                    staff.fetchData(_userDetailsController.id);
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
                'staff_id': staff.staffs[widget.index].userId,
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
                      'staff_id': staff.staffs[widget.index].userId,
                    })
                  : FormData.fromMap({
                      'class': classId,
                      'staff_id': staff.staffs[widget.index].userId,
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
                    staff.fetchData(_userDetailsController.id);
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

  Widget getDesignationDropDown(List<DesignationData> designations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: DropdownSearch<String>(
        validator: (value) {
          if (value == null) {
            return 'Please select a designation';
          }
          return null;
        },
        items: designations.map((e) => e.title!).toList(),
        popupProps: PopupProps.menu(
          showSelectedItems: true,
          constraints: BoxConstraints(
            maxHeight: (designations.length * 60) < 200
                ? (designations.length * 60)
                : 200,
          ),
        ),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            labelText: 'Designation*',
            alignLabelWithHint: true,
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFF343B67)),
            ),
          ),
        ),
        onChanged: (dynamic newValue) async {
          setState(() {
            errorMsg = '';
            _selectedDesignation = newValue;
            designationId =
                designations.singleWhere((e) => e.title == newValue).id;
            print(designationId);
          });
        },
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: _selectedDesignation,
      ),
    );
  }

  Widget getGenderDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: DropdownSearch<String>(
        // mode: Mode.MENU,
        validator: (value) {
          if (value == null) {
            return 'Please select a gender';
          }
          return null;
        },
        // showSelectedItems: true,
        items: ['Male', 'Female'],
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
          constraints: BoxConstraints(
            maxHeight: (2 * 60) < 200 ? (2 * 60) : 200,
          ),
        ),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            labelText: 'Gender*',
            alignLabelWithHint: true,
            labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFF343B67)),
            ),
          ),
        ),
        onChanged: (dynamic newValue) {
          setState(() {
            gender = newValue;
            genderId =
                _genders.singleWhere((e) => e['gender'] == newValue)['id'];
            print(_genders.singleWhere((e) => e['gender'] == newValue)['id']);
            debugPrint('User select $genderId');
          });
        },
        selectedItem: gender,
      ),
    );
  }

  editNoticePromptDialog(BuildContext context) async {
    return custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return EditBottomSheet(onEdit: () async {
          //close navigator
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddStaffScreen(
                    isEdit: true,
                    index: widget.index,
                  )));
        });
      },
    );
  }
}
