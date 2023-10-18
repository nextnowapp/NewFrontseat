import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/school/edit_school_management.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/widget/edit_button.dart';
import 'package:sizer/sizer.dart';

class SchoolManagementScreen extends StatefulWidget {
  const SchoolManagementScreen({Key? key}) : super(key: key);

  @override
  State<SchoolManagementScreen> createState() => _SchoolManagementScreenState();
}

class _SchoolManagementScreenState extends State<SchoolManagementScreen> {
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'School Management',
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Principal\'s\n',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.blueAccent,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Welcome Message',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ).fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'As the school principal you can edit and update this content (Welcome Message) and it will also be updated here and your school website.\n\nPlease take your best photo shot and check it on your school website.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    height: 1.5,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          //full width image with name above image
          Container(
            height: 100.w,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: 100.w,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://schoolmanagement.co.za/wp-content/uploads/DefaultPrincipal.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    height: 30.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(1),
                          Colors.black.withOpacity(0.0),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Abresh Abiba',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                            ).fontFamily,
                          ),
                        ),
                        Text(
                          'School Principal',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white54,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 5,
                          width: 10.w,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          //horizontal image with description slider with indicator,
          Container(
            height: 55.h,
            width: 100.w,
            child: ListView(
              padding: const EdgeInsets.only(left: 30.0),
              scrollDirection: Axis.horizontal,
              children: [
                const LatestHappeningsCard(
                  imageUrl:
                      'https://schoolmanagement.co.za/wp-content/uploads/SGBDefault.jpeg',
                  title: 'SMT Group Photo',
                  desc:
                      'As the school SGB chairperson you can edit and update this content (SGB Message) and it will be updated here and your school website.\n\nPlease take your best photo shot and check it on your school website.',
                ),
                const LatestHappeningsCard(
                  imageUrl:
                      'https://schoolmanagement.co.za/wp-content/uploads/WhatsApp-Image-2022-12-03-at-11.52.47-AM.jpeg',
                  title: 'School Prefects (Leaders)',
                  desc:
                      'Please update your Learner\'s school prefects (leaders) group photo here by changing the photo.\n\nClick camera to update photo.',
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 30, bottom: 30),
            color: HexColor('#eaeaea'),
            height: 35.h,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AuthoritiesCard(
                  imageUrl:
                      'https://schoolmanagement.co.za/wp-content/uploads/SGBChairpersonDefault.jpeg',
                  name: 'Abresh Abiba',
                  designation: 'SGB Chairperson',
                ),
                AuthoritiesCard(
                  imageUrl:
                      'https://schoolmanagement.co.za/wp-content/uploads/DefaultCM.jpeg',
                  name: 'Takalani Thi..',
                  designation: 'Circuit Manager',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _userDetailsController.roleId != 5
          ? Container()
          : Container(
              width: 80,
              child: EditButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditSchoolManagementScreen(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class LatestHappeningsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String desc;
  const LatestHappeningsCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      width: 75.w,
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ).fontFamily,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black,
              height: 1.5,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
              ).fontFamily,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}

class AuthoritiesCard extends StatelessWidget {
  final String name;
  final String designation;
  final String imageUrl;
  const AuthoritiesCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 43.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 20.h,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  designation,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black54,
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
    );
  }
}
