import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditSchoolManagementScreen extends StatefulWidget {
  const EditSchoolManagementScreen({Key? key}) : super(key: key);

  @override
  State<EditSchoolManagementScreen> createState() =>
      _EditSchoolManagementScreenState();
}

class _EditSchoolManagementScreenState
    extends State<EditSchoolManagementScreen> {
  //form key
  var _formKey = GlobalKey<FormState>();

  //controllers
  late TextEditingController _principalMessageController;
  late TextEditingController _principalNameController;
  late TextEditingController _deputyPrincipalNameController;

  @override
  initState() {
    super.initState();
    _principalMessageController = TextEditingController();
    _principalNameController = TextEditingController();
    _deputyPrincipalNameController = TextEditingController();
  }

  @override
  dispose() {
    super.dispose();
    _principalMessageController.dispose();
    _principalNameController.dispose();
    _deputyPrincipalNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Edit School Management',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TxtField(
                labelIcon: Container(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/images/School Name.svg',
                  ),
                ),
                // focusNode: _prioncipalMessageFocusNode,
                hint: 'Principal\'s Welcome Message',
                controller: _principalMessageController,
                lines: 7,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter principal message';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 3.h,
              ),
              //image and field
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://thispersondoesnotexist.com/image',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            //bprder radius
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        width: 20.sp,
                        right: 0,
                        child: Container(
                          height: 15.sp,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TxtField(
                      hint: 'Principal Name',
                      controller: _principalNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://thispersondoesnotexist.com/image',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            //bprder radius
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        width: 20.sp,
                        right: 0,
                        child: Container(
                          height: 15.sp,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TxtField(
                      hint: 'Deputy Principal Name',
                      controller: _deputyPrincipalNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              //SMT Group photo
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMT Group Photo',
                      style: TextStyle(
                        color: HexColor('#8e9aa6'),
                        fontSize: 10.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            height: 70,
                            decoration: BoxDecoration(
                              color: HexColor('#e2e4ed'),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      'https://thispersondoesnotexist.com/image',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      //bprder radius
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Browse Image',
                                      style: TextStyle(
                                        color: HexColor('#8e9aa6'),
                                        fontSize: 12.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                    Text(
                                      'Supports JPGs or PNGs',
                                      style: TextStyle(
                                        color: HexColor('#8e9aa6'),
                                        fontSize: 10.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //icon
                              const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),

                              //text
                              Text(
                                'Browse',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TxtField(
                      hint: '',
                      lines: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              //Perfect Group photo
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMT Group Photo',
                      style: TextStyle(
                        color: HexColor('#8e9aa6'),
                        fontSize: 10.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            height: 70,
                            decoration: BoxDecoration(
                              color: HexColor('#e2e4ed'),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      'https://thispersondoesnotexist.com/image',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      //bprder radius
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Browse Image',
                                      style: TextStyle(
                                        color: HexColor('#8e9aa6'),
                                        fontSize: 12.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ).fontFamily,
                                      ),
                                    ),
                                    Text(
                                      'Supports JPGs or PNGs',
                                      style: TextStyle(
                                        color: HexColor('#8e9aa6'),
                                        fontSize: 10.sp,
                                        fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ).fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //icon
                              const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),

                              //text
                              Text(
                                'Browse',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TxtField(
                      hint: '',
                      lines: 4,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 3.h,
              ),

              //SGB
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://thispersondoesnotexist.com/image',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            //bprder radius
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        width: 20.sp,
                        right: 0,
                        child: Container(
                          height: 15.sp,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TxtField(
                      hint: 'SGB Chair Person',
                      controller: _principalNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              //Circuit Manager
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://thispersondoesnotexist.com/image',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            //bprder radius
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        width: 20.sp,
                        right: 0,
                        child: Container(
                          height: 15.sp,
                          decoration: BoxDecoration(
                            color: HexColor('#3ab28d'),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TxtField(
                      hint: 'Circuit Manager',
                      controller: _deputyPrincipalNameController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
