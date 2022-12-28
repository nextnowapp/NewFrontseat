// import 'dart:math';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:nextschool/config/app_config.dart';
// import 'package:nextschool/controller/user_controller.dart';
// import 'package:nextschool/screens/signup_flow/welcome_screen.dart';
// import 'package:nextschool/utils/model/School.dart';
// import 'package:nextschool/utils/widget/next_button.dart';
// import 'package:nextschool/utils/widget/textwidget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../utils/Utils.dart';

// class ChooseSchool extends StatefulWidget {
//   ChooseSchool({Key? key}) : super(key: key);

//   @override
//   _ChooseSchoolState createState() => _ChooseSchoolState();
// }

// class _ChooseSchoolState extends State<ChooseSchool> {
//   List<School> schoolList = [];
//   String? selectedValue;
//   String? selectedSchoolUrl;
//   String? selectedSchoolName = 'Type School Name';
//   bool dropdownClicked = false;
//   String? schoolLogo;
//   bool isInfoClicked = false;
//   Dio dio = Dio();
//   List<String?> _searchList = [];
//   TextEditingController _searchController = TextEditingController();
//   UserDetailsController userDetailsController =
//       Get.put(UserDetailsController());

//   @override
//   void initState() {
//     //fetch data using dio from
//     dio
//         .get('https://schoolmanagement.co.za/signup/api/next_school_list')
//         .then((value) {
//       if (value.statusCode == 200) {
//         var data = value.data['data'];
//         var sList = SchoolList.fromJson(data);
//         schoolList = sList.schools;
//         schoolList.sort((a, b) {
//           return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
//         });
//       }
//     }).catchError((e) {
//       var msg = e.response.data['message'];
//       Utils.showErrorToast(msg);
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarBrightness: Brightness.light,
//     ));
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Stack(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width,
//                   color: Colors.white,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     color: HexColor('#9fcaff'),
//                     child: SvgPicture.asset(
//                       'assets/images/Welcome Screen bg.svg',
//                       fit: BoxFit.cover,
//                       alignment: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.35,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               'Welcome to a digitally\ntransforming school!!',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 28,
//                                   fontFamily: GoogleFonts.inter(
//                                     fontWeight: FontWeight.w700,
//                                   ).fontFamily,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 1.h,
//                             ),
//                             Text('App Version: ' + AppConfig.appVersion),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Visibility(
//                               visible: isInfoClicked,
//                               child: CustomPaint(
//                                 //define a chat bubble printer
//                                 painter: ChatBubblePainter(
//                                   color: HexColor('#ebf2ff'),
//                                   radius: 15,
//                                   arrowHeight: 10,
//                                   arrowWidth: 10,
//                                 ),

//                                 child: Container(
//                                   padding: const EdgeInsets.all(10.0),
//                                   width: 85.w,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Icon(
//                                         Icons.info,
//                                         size: 17,
//                                         color: Colors.black,
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       Expanded(
//                                         child: Column(
//                                           children: [
//                                             TextWidget(
//                                               txt:
//                                                   'If you cannot find your school, please contact us to assist you  with onboarding your school.',
//                                               clr: Colors.black87,
//                                               size: 10.sp,
//                                             ),
//                                             const SizedBox(
//                                               height: 10,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 TextWidget(
//                                                   txt:
//                                                       'Whatsapp or call us on :',
//                                                   clr: Colors.black87,
//                                                   size: 10.sp,
//                                                 ),
//                                                 const SizedBox(height: 5),
//                                                 InkWell(
//                                                     onTap: () {
//                                                       launchUrl(Uri.parse(
//                                                           'tel:0734072854'));
//                                                     },
//                                                     child: TextWidget(
//                                                         txt: '\t0734072854',
//                                                         weight: FontWeight.w700,
//                                                         size: 10.sp,
//                                                         clr: Colors.black87)),
//                                                 TextWidget(
//                                                   txt: ' or',
//                                                   clr: Colors.black54,
//                                                   size: 10.sp,
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 TextWidget(
//                                                   txt: 'visit :',
//                                                   clr: Colors.black54,
//                                                   size: 10.sp,
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     launchUrl(Uri.parse(
//                                                         'mailto:www.nextschool.group'));
//                                                   },
//                                                   child: TextWidget(
//                                                     weight: FontWeight.w700,
//                                                     txt:
//                                                         ' www.nextschool.group',
//                                                     clr: Colors.black87,
//                                                     size: 10.sp,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'Select School',
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                     color: Colors.black87,
//                                     fontSize: 10.sp,
//                                     fontFamily: GoogleFonts.inter(
//                                       fontWeight: FontWeight.w600,
//                                     ).fontFamily,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 InkWell(
//                                   onTap: () async {
//                                     setState(() {
//                                       isInfoClicked = true;
//                                     });
//                                     await Future.delayed(
//                                         const Duration(seconds: 5));
//                                     setState(() {
//                                       isInfoClicked = false;
//                                     });
//                                   },
//                                   child: Icon(
//                                     Icons.info,
//                                     size: 16.sp,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 1.h,
//                             ),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       dropdownClicked = !dropdownClicked;
//                                     });
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.blue),
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         dropdownClicked
//                                             ? Flexible(
//                                                 child: TextField(
//                                                     style: TextStyle(
//                                                       color: Colors.black87,
//                                                       fontSize: 12.sp,
//                                                       fontFamily:
//                                                           GoogleFonts.inter(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ).fontFamily,
//                                                     ),
//                                                     controller:
//                                                         _searchController,
//                                                     decoration: InputDecoration(
//                                                       icon: Icon(
//                                                         Icons.search,
//                                                         color: Colors.grey,
//                                                         size: 18.sp,
//                                                       ),
//                                                       border: InputBorder.none,
//                                                       hintText: 'School Name',
//                                                       hintStyle: TextStyle(
//                                                         color: Colors.grey[300],
//                                                         fontSize: 12.sp,
//                                                         fontFamily:
//                                                             GoogleFonts.inter(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ).fontFamily,
//                                                       ),
//                                                     ),
//                                                     onChanged: (value) {
//                                                       if (value.isNotEmpty) {
//                                                         setState(() {
//                                                           findSpecificSchool(
//                                                               value);
//                                                         });
//                                                       }
//                                                     }),
//                                               )
//                                             : Expanded(
//                                                 child: Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons.search,
//                                                       color: Colors.grey,
//                                                       size: 18.sp,
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 10,
//                                                     ),
//                                                     Text(
//                                                       selectedSchoolName!,
//                                                       style: TextStyle(
//                                                         color: selectedValue !=
//                                                                 null
//                                                             ? Colors.black87
//                                                             : Colors.grey,
//                                                         fontSize: 12.sp,
//                                                         fontFamily:
//                                                             GoogleFonts.inter(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ).fontFamily,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                         IconButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               dropdownClicked =
//                                                   !dropdownClicked;
//                                             });
//                                           },
//                                           icon: Icon(
//                                               dropdownClicked
//                                                   ? Icons.arrow_drop_up
//                                                   : Icons.arrow_drop_down,
//                                               color: Colors.black54),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Visibility(
//                                   visible: dropdownClicked,
//                                   child: _searchController.text.isNotEmpty
//                                       ? (Container(
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.black
//                                                       .withOpacity(0.1),
//                                                   spreadRadius: 1,
//                                                   blurRadius: 7,
//                                                   offset: const Offset(0,
//                                                       5), // changes position of shadow
//                                                 ),
//                                               ]),
//                                           height: min(
//                                               200.0, _searchList.length * 60.0),
//                                           child: _searchList.isNotEmpty
//                                               ? ListView.separated(
//                                                   separatorBuilder:
//                                                       (context, index) =>
//                                                           const Divider(
//                                                     height: 2,
//                                                     thickness: 1,
//                                                     color: Colors.grey,
//                                                   ),
//                                                   physics:
//                                                       const BouncingScrollPhysics(),
//                                                   itemCount: _searchList.length,
//                                                   itemBuilder:
//                                                       (context, index) {
//                                                     return InkWell(
//                                                       onTap: () {
//                                                         setState(() {
//                                                           var query =
//                                                               _searchList[
//                                                                   index];
//                                                           schoolList.forEach(
//                                                               (element) {
//                                                             if (element.name!
//                                                                 .toLowerCase()
//                                                                 .contains(query!
//                                                                     .toLowerCase())) {
//                                                               selectedSchoolUrl =
//                                                                   element
//                                                                       .schoolUrl;
//                                                               selectedValue =
//                                                                   element
//                                                                       .schoolId;

//                                                               userDetailsController
//                                                                       .schoolId =
//                                                                   element
//                                                                       .schoolId;
//                                                               selectedSchoolName =
//                                                                   element.name;
//                                                               schoolLogo = element
//                                                                   .schoolLogo;
//                                                             }
//                                                           });
//                                                           _searchController
//                                                               .clear();
//                                                           dropdownClicked =
//                                                               false;
//                                                         });
//                                                       },
//                                                       child: SizedBox(
//                                                         height: 50,
//                                                         width: double.infinity,
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   horizontal:
//                                                                       18.0),
//                                                           child: Center(
//                                                             child: Text(
//                                                                 _searchList[
//                                                                     index]!),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 )
//                                               : Container(
//                                                   height: 30,
//                                                   child: const Text(
//                                                       'No results found'),
//                                                 ),
//                                         ))
//                                       : Container(
//                                           height: 200,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.black
//                                                       .withOpacity(0.1),
//                                                   spreadRadius: 1,
//                                                   blurRadius: 7,
//                                                   offset: const Offset(0,
//                                                       5), // changes position of shadow
//                                                 ),
//                                               ]),
//                                           padding: const EdgeInsets.all(0),
//                                           child: Scrollbar(
//                                             child: ListView.separated(
//                                                 separatorBuilder:
//                                                     (context, index) =>
//                                                         const Divider(
//                                                           color: Colors.grey,
//                                                           height: 2,
//                                                           thickness: 1,
//                                                         ),
//                                                 physics:
//                                                     const BouncingScrollPhysics(),
//                                                 itemCount: schoolList.length,
//                                                 itemBuilder: (context, index) {
//                                                   return InkWell(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         selectedValue =
//                                                             schoolList[index]
//                                                                 .schoolId;
//                                                         selectedSchoolUrl =
//                                                             schoolList[index]
//                                                                 .schoolUrl;

//                                                         selectedSchoolName =
//                                                             schoolList[index]
//                                                                 .name;
//                                                         schoolLogo =
//                                                             schoolList[index]
//                                                                 .schoolLogo;
//                                                         dropdownClicked = false;
//                                                       });
//                                                       userDetailsController
//                                                               .schoolId =
//                                                           selectedValue;
//                                                       userDetailsController
//                                                               .schoolUrl =
//                                                           selectedSchoolUrl!;
//                                                     },
//                                                     child: SizedBox(
//                                                       height: 50,
//                                                       width: double.infinity,
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 horizontal:
//                                                                     18.0),
//                                                         child: Center(
//                                                           child: Text(
//                                                               schoolList[index]
//                                                                   .name!),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }),
//                                           ),
//                                         ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const SizedBox(
//                                   width: 90,
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       'Step 1 of 4',
//                                       style: TextStyle(
//                                         color: Colors.black87,
//                                         fontSize: 9.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Row(
//                                       children: [
//                                         ...List.generate(
//                                           4,
//                                           (index) => Container(
//                                             margin: const EdgeInsets.symmetric(
//                                                 horizontal: 2),
//                                             height: 4,
//                                             width: 20,
//                                             decoration: BoxDecoration(
//                                               color: index == 0
//                                                   ? const Color(0xFF00b58b)
//                                                   : Colors.grey[300],
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 selectedValue != null
//                                     ? InkWell(
//                                         onTap: () {
//                                           print(selectedValue);
//                                           //save school id in shared preferences
//                                           SharedPreferences.getInstance()
//                                               .then((prefs) {
//                                             prefs.setString(
//                                                 'schoolId', selectedValue!);
//                                           });
//                                           userDetailsController.schoolId =
//                                               selectedValue!;
//                                           userDetailsController.schoolUrl =
//                                               selectedSchoolUrl!;

//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   WelcomeScreen(
//                                                 schoolLogo: schoolLogo!,
//                                                 schoolName: selectedSchoolName!,
//                                                 schoolID: selectedValue!,
//                                                 schoolUrl: selectedSchoolUrl!,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: const NextButton())
//                                     : InkWell(
//                                         onTap: () {
//                                           Utils.showToast(
//                                               'Please select the school from the list.');
//                                         },
//                                         child: const NextButton())
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   int findSpecificSchool(String query) {
//     _searchList.clear();
//     schoolList.forEach((element) {
//       if (element.name!.toLowerCase().contains(query.toLowerCase())) {
//         print('matched');
//         _searchList.add(element.name);
//       }
//     });
//     return _searchList == null ? 0 : _searchList.length;
//   }
// }

// //define a custom chat bubble painter
// class ChatBubblePainter extends CustomPainter {
//   final Color color;
//   final double radius;
//   final double arrowHeight;
//   final double arrowWidth;

//   ChatBubblePainter({
//     required this.color,
//     required this.radius,
//     required this.arrowHeight,
//     required this.arrowWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;

//     final path = Path();

//     //add fill color
//     paint.style = PaintingStyle.fill;

//     path.moveTo(0, radius);
//     path.lineTo(0, size.height - radius);
//     path.quadraticBezierTo(0, size.height, radius, size.height);
//     path.lineTo(size.width - arrowHeight * 3, size.height);
//     path.lineTo(size.width - arrowHeight, size.height + arrowHeight * 3);
//     path.lineTo(size.width - arrowWidth, size.height - arrowHeight * 3);
//     path.lineTo(size.width - arrowWidth, radius);
//     path.quadraticBezierTo(
//         size.width - arrowWidth, 0, size.width - arrowWidth - radius, 0);
//     path.lineTo(radius, 0);
//     path.quadraticBezierTo(0, 0, 0, radius);

//     //draw the path on the canvas

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(ChatBubblePainter oldDelegate) => false;

//   @override
//   bool shouldRebuildSemantics(ChatBubblePainter oldDelegate) => false;
// }
