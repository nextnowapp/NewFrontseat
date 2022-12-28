import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/login_new.dart';
import 'package:nextschool/screens/parentLogin.dart';
import 'package:nextschool/screens/staffLoginScreen.dart';
import 'package:sizer/sizer.dart';

class ChooseLoginMethodScreen extends StatefulWidget {
  final String schoolName;
  final String schoolID;
  final String schoolUrl;
  final String schoolLogo;
  final String roleId;
  const ChooseLoginMethodScreen({
    Key? key,
    required this.schoolID,
    required this.schoolUrl,
    required this.schoolName,
    required this.schoolLogo,
    required this.roleId,
  }) : super(key: key);

  @override
  State<ChooseLoginMethodScreen> createState() =>
      _ChooseLoginMethodScreenState();
}

class _ChooseLoginMethodScreenState extends State<ChooseLoginMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.schoolLogo,
            width: 60.w,
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.sp,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(6.sp),
                    tileColor: HexColor('#fafcff'),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    style: ListTileStyle.list,
                    onTap: () {
                      if (widget.roleId == '3') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentLoginScreen(
                              schoolLogo: widget.schoolLogo,
                              schoolId: widget.schoolID,
                              schoolUrl: widget.schoolUrl,
                              roleId: widget.roleId,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffLoginScreen(
                              schoolLogo: widget.schoolLogo,
                              schoolId: widget.schoolID,
                              schoolUrl: widget.schoolUrl,
                            ),
                          ),
                        );
                      }
                    },
                    leading: SvgPicture.asset('assets/images/Login by DOB.svg'),
                    title: Text(
                      'Login by Date of birth',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Login with leaner\'s, Parent\'s date of birth and Passcode',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 9.sp,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                          ).fontFamily,
                        ),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#f0f2f6'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(6.sp),
                    tileColor: HexColor('#fafcff'),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    style: ListTileStyle.list,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewLoginScreen(
                            schoolLogo: widget.schoolLogo,
                            roleId: widget.roleId,
                          ),
                        ),
                      );
                    },
                    leading:
                        SvgPicture.asset('assets/images/Login by email.svg'),
                    title: Text(
                      'Login by Username/E-mail',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Login with E-mail ID/ Username and Passcode',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 9.sp,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                          ).fontFamily,
                        ),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#f0f2f6'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
