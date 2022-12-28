// Flutter imports:

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/student/profile/profile.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
// Project imports:
import 'package:nextschool/utils/model/Staff.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class StaffDetailProfileScreen extends StatefulWidget {
  Staff staff;

  StaffDetailProfileScreen(this.staff);

  @override
  _StaffDetailProfileScreenState createState() =>
      _StaffDetailProfileScreenState();
}

class _StaffDetailProfileScreenState extends State<StaffDetailProfileScreen> {
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  Widget build(BuildContext context) {
    var user = widget.staff;
    var date = user.dob.split('/');
    var newDate = date[2] + '-' + date[1] + '-' + date[0];
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
                      CachedNetworkImage(
                        height: 20.h - 24.sp,
                        width: 95.sp,
                        imageUrl: InfixApi().root + (user.photo ?? ''),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(InfixApi().root +
                                  'public/uploads/staff/demo/staff.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ((user.fullName).toLowerCase()).titleCase,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600)
                                        .fontFamily,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Text(
                                  user.designation ?? '',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600)
                                        .fontFamily,
                                    fontSize: 10.sp,
                                    color: HexColor('#8a96a0'),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'username: ' + user.username,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400)
                                            .fontFamily,
                                        fontSize: 10.sp,
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
                                        Text(
                                          (user.className ?? ''),
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600)
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
                                        Text(
                                          (user.staffId.toString()),
                                          maxLines: 2,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600)
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
                                        Text(
                                          ((user.genderId == 1
                                                  ? 'Male'
                                                  : 'Female')
                                              .titleCase),
                                          maxLines: 2,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600)
                                                .fontFamily,
                                            fontSize: 10.sp,
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
                      title: 'First Name',
                      value: user.firstName,
                    ),
                    ProfileDetailsRow(
                      title: 'Middle Name',
                      value: user.middleName,
                    ),
                    ProfileDetailsRow(
                      title: 'Last Name',
                      value: user.lastName != null
                          ? (user.lastName).toLowerCase().titleCase
                          : '',
                    ),
                    ProfileDetailsRow(
                      title: 'Asigned Subjects',
                      valueList: user.subjectNames,
                    ),
                    ProfileDetailsRow(
                      title: 'Birthday',
                      value: user.dob != null
                          ? DateFormat('dd MMM').format(DateTime.parse(newDate))
                          : '',
                    ),
                    ProfileDetailsRow(
                      title: 'E-mail',
                      value: user.email,
                    ),
                    _userDetailsController.roleId == 3
                        ? Container()
                        : ProfileDetailsRow(
                            title: 'Phone',
                            value: user.phone,
                            hasBorder: false,
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
