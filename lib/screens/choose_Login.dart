import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/choose_login_method.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/role_select_card.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseLoginType extends StatefulWidget {
  final String schoolName;
  final String schoolID;
  final String schoolUrl;
  final String schoolLogo;
  ChooseLoginType(
      {Key? key,
      required this.schoolID,
      required this.schoolUrl,
      required this.schoolName,
      required this.schoolLogo})
      : super(key: key);

  @override
  State<ChooseLoginType> createState() => _ChooseLoginTypeState();
}

class _ChooseLoginTypeState extends State<ChooseLoginType>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;
  late Animation<Offset> offset2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    //define offset for right to left animation
    offset = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(controller);

    offset2 = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //choose login type as Login as Parent or Login as Staff
    return Container(
      height: size.height,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10.0),
              child: Container(
                color: HexColor('#d5dce0'),
                height: 1.0,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: CachedNetworkImage(
              imageUrl: widget.schoolLogo,
              width: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Welcome to \n${this.widget.schoolName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                              ).fontFamily,
                            ),
                          ),
                          Utils.sizedBoxHeight(1.h),
                          InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(widget.schoolUrl));
                            },
                            child: Text(
                              '${(this.widget.schoolUrl.replaceAll('https://', 'www.')).replaceAll('/', '')}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 10.sp,
                                decoration: TextDecoration.underline,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ).fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          SlideTransition(
                            position: offset2,
                            child: RoleSelectCard(
                                btnText: 'Login',
                                image: 'assets/images/parent_teaching.svg',
                                message: 'Login as Parent',
                                bgGradient: const LinearGradient(
                                  colors: [
                                    Color(0xff5581f1),
                                    Color(0xFF1153fc),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ParentLoginScreen(
                                  //       schoolLogo: this.widget.schoolLogo,
                                  //       schoolId: this.widget.schoolID,
                                  //       schoolUrl: this.widget.schoolUrl,
                                  //       roleId: '3',
                                  //     ),
                                  //   ),
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseLoginMethodScreen(
                                              schoolName:
                                                  this.widget.schoolName,
                                              schoolLogo:
                                                  this.widget.schoolLogo,
                                              schoolID: this.widget.schoolID,
                                              schoolUrl: this.widget.schoolUrl,
                                              roleId: '3',
                                            )),
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SlideTransition(
                            position: offset,
                            child: RoleSelectCard(
                                reverse: true,
                                btnText: 'Login',
                                image: 'assets/images/teacher_teaching.svg',
                                message: 'Login as Staff',
                                bgGradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0B0742),
                                    Color(0xFF222744),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => StaffLoginScreen(
                                  //       schoolLogo: this.widget.schoolLogo,
                                  //       schoolUrl: this.widget.schoolUrl,
                                  //       schoolId: this.widget.schoolID,
                                  //     ),
                                  //   ),
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseLoginMethodScreen(
                                              schoolName:
                                                  this.widget.schoolName,
                                              schoolLogo:
                                                  this.widget.schoolLogo,
                                              schoolID: this.widget.schoolID,
                                              schoolUrl: this.widget.schoolUrl,
                                              roleId: '5',
                                            )),
                                  );
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => ChooseSchool(),
                      //           ),
                      //         );
                      //       },
                      //       child: const BackBtn(),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
