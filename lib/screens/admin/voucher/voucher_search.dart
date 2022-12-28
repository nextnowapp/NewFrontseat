// import 'dart:convert';

// // Flutter imports:
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// // Package imports:
// import 'package:http/http.dart' as http;
// import 'package:nextschool/controller/grade_list_controller.dart';
// import 'package:nextschool/controller/user_controller.dart';
// import 'package:nextschool/screens/admin/voucher/voucher_list.dart';
// // Project imports:
// import 'package:nextschool/utils/CustomAppBarWidget.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/apis/Apis.dart';
// import 'package:nextschool/utils/model/Classes.dart';
// import 'package:nextschool/utils/model/Section.dart';
// import 'package:nextschool/utils/widget/customLoader.dart';
// import 'package:nextschool/utils/widget/txtbox.dart';
// import 'package:sizer/sizer.dart';

// class VoucherSearch extends StatefulWidget {
//   String? status;
//   VoucherSearch({this.status});

//   @override
//   _VoucherSearchState createState() => _VoucherSearchState(status: status);
// }

// class _VoucherSearchState extends State<VoucherSearch> {
//   String? _id;
//   int? classId;
//   int? sectionId;
//   String? _selectedClass;
//   Future<ClassList?>? classes;
//   Future<SectionListModel?>? sections;
//   DateTime? date;
//   String? day, year, month;
//   String _selectedDate = DateTime.now().toString().substring(0, 10);
//   DateTime? _dateTime;
//   String? maxDateTime;
//   String minDateTime = '2019-01-01';
//   TextEditingController nameController = TextEditingController();

//   String? url;
//   String? status;
//   String? _token;
//   bool isSectionSearch = false;
//   UserDetailsController _userDetailsController =
//       Get.put(UserDetailsController());
//   GradeListController _gradeListController = Get.put(GradeListController());

//   var _formKey = GlobalKey<FormState>();

//   _VoucherSearchState({this.status});

//   @override
//   void initState() {
//     _token = _userDetailsController.token;
//     _id = _userDetailsController.id.toString();

//     classes = getAllClass(int.parse(_id!));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(url);
//     return Scaffold(
//       appBar: CustomAppBarWidget(title: 'Voucher Search'),
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: new GestureDetector(
//           onTap: () {
//             // call this method here to hide soft keyboard
//             FocusScope.of(context).requestFocus(new FocusNode());
//           },
//           child: Container(
//             padding: EdgeInsets.all(12.sp),
//             child: Form(
//               key: _formKey,
//               child: FutureBuilder<ClassList?>(
//                 future: classes,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView(
//                       children: <Widget>[
//                         Obx(() => getClassNewDropdown(
//                             _gradeListController.gradeList)),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Visibility(
//                           visible: status == 'attendance' ? true : false,
//                           child: InkWell(
//                             onTap: () {
//                               _selectAssignDate(context);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10.0, vertical: 0),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0, vertical: 18),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.grey,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: Text(
//                                         _selectedDate == null
//                                             ? 'Attendance date: $day-$month-$year'
//                                             : 'Attendance date: ' +
//                                                 _selectedDate,
//                                         style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.black,
//                                           fontFamily: GoogleFonts.inter(
//                                             fontWeight: FontWeight.w500,
//                                           ).fontFamily,
//                                         ),
//                                       ),
//                                     ),
//                                     Icon(
//                                       Icons.calendar_today,
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .subtitle1!
//                                           .color,
//                                       size: 20.0,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFF222744)),
//                               child: const Text(
//                                 'OR',
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 2.h,
//                         ),
//                         TxtField(
//                           hint: 'Search by Name',
//                           controller: nameController,
//                           type: TextInputType.text,
//                           validator: (dynamic value) {
//                             if (value == null) {
//                               return 'Please enter the name';
//                             }
//                             return null;
//                           },
//                         ),
//                         Utils.sizedBoxHeight(12),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               right: 20, left: 20, top: 10, bottom: 10),
//                           child: Material(
//                             color: HexColor('#5374ff'),
//                             borderRadius: BorderRadius.circular(20.0),
//                             child: InkWell(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   width: MediaQuery.of(context).size.width,
//                                   height: 50.0,
//                                   child: Text(
//                                     'Search',
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.white,
//                                       fontFamily: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w600,
//                                       ).fontFamily,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               onTap: () {
//                                 String name = nameController.text;

//                                 if (name.isNotEmpty) {
//                                   url = InfixApi.VoucherListName(name);
//                                   // url = InfixApi.getStudentByName(name);
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               VoucherListScreen(
//                                                 url: url,
//                                                 status: status,
//                                                 token: _token,
//                                               )));
//                                 } else if (_formKey.currentState!.validate()) {
//                                   url = InfixApi.VoucherListClassId(classId);
//                                   // url = InfixApi.getStudentByClassAndSection(
//                                   //     classId, sectionId);
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               VoucherListScreen(
//                                                 classCode: classId,
//                                                 url: url,
//                                                 status: status,
//                                                 token: _token,
//                                               )));
//                                 }
//                                 // else {
//                                 //   Utils.showToast(
//                                 //       'Please select either Grade and Class OR enter name of student.');
//                                 //   // Utils.showToast('Please select Class.');
//                                 // }
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     );
//                   } else {
//                     return const Center(
//                       child: SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: CustomLoader(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           )),
//     );
//   }

//   Widget getClassNewDropdown(List<Classes> classes) {
//     //sort the grade from snapshot in order of _list

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Search by class',
//           style: TextStyle(
//             color: HexColor('#8e9aa6'),
//             fontSize: 10.sp,
//             fontFamily: GoogleFonts.inter(
//               fontWeight: FontWeight.w500,
//             ).fontFamily,
//           ),
//         ),
//         SizedBox(
//           height: 0.5.h,
//         ),
//         DropdownSearch<String>(
//             dropdownBuilder: (context, selectedItem) {
//               return Text(
//                 selectedItem ?? '',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.black,
//                   fontFamily: GoogleFonts.inter(
//                     fontWeight: FontWeight.w500,
//                   ).fontFamily,
//                 ),
//               );
//             },
//             items: classes.map((e) => e.name!).toList(),
//             popupProps: PopupProps.menu(
//               itemBuilder: (context, item, isSelected) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 20.sp, vertical: 10.sp),
//                       child: Text(
//                         item,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.black,
//                           fontFamily: GoogleFonts.inter(
//                             fontWeight: FontWeight.w500,
//                           ).fontFamily,
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       color: HexColor('#8e9aa6'),
//                       thickness: 0.5,
//                     )
//                   ],
//                 );
//               },
//               showSelectedItems: true,
//               constraints: BoxConstraints(
//                 maxHeight:
//                     (classes.length * 60) < 200 ? (classes.length * 60) : 200,
//               ),
//             ),
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 errorStyle: TextStyle(
//                   fontSize: 8.sp,
//                   color: HexColor('#de5151'),
//                   fontFamily: GoogleFonts.inter(
//                     fontWeight: FontWeight.w500,
//                   ).fontFamily,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide(
//                     color: HexColor('#d5dce0'),
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide(
//                     color: HexColor('#5374ff'),
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide(
//                     color: HexColor('#de5151'),
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide(
//                     color: HexColor('#de5151'),
//                   ),
//                 ),
//                 labelStyle: Theme.of(context).textTheme.headline5,
//               ),
//             ),
//             onChanged: (dynamic newValue) {
//               setState(() {
//                 _selectedClass = newValue;
//                 classId = getCode(classes, newValue);
//                 debugPrint('User select $classId');
//               });
//             },
//             validator: (dynamic value) {
//               if ((value == null) && (nameController.text.isEmpty)) {
//                 return 'Please select a grade';
//               }
//               return null;
//             },
//             selectedItem: _selectedClass),
//       ],
//     );
//   }

//   int? getCode<T>(T t, String? title) {
//     int? code;
//     for (var cls in t as Iterable) {
//       if (cls.name == title) {
//         code = cls.id;
//         break;
//       }
//     }
//     return code;
//   }

//   Future<ClassList?>? getAllClass(int id) async {
//     final response = await http.get(Uri.parse(InfixApi.getClassById()),
//         headers: Utils.setHeader(_token.toString()));
//     if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       return ClassList.fromJson(jsonData['data']['classes']);
//     } else {
//       throw Exception('Failed to load');
//     }
//     return null;
//   }

//   Future<void> _selectAssignDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF222744), // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: Color(0xFF4E88FF), // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xFF4E88FF), // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//       context: context,
//       initialDate: _dateTime != null ? _dateTime! : DateTime.now(),
//       firstDate: DateTime.parse(minDateTime),
//       lastDate: DateTime.now(),
//       confirmText: 'Confirm Date',
//       cancelText: 'Back',
//       helpText: 'Select Attendance Date',
//     );
//     if (pickedDate != null && pickedDate != _dateTime) {
//       setState(() {
//         _dateTime = pickedDate;
//         _selectedDate =
//             '${_dateTime!.year}-${getAbsoluteDate(_dateTime!.month)}-${getAbsoluteDate(_dateTime!.day)}';
//       });
//     }
//   }

//   String getAbsoluteDate(int date) {
//     return date < 10 ? '0$date' : '$date';
//   }

//   Future<SectionListModel> getAllSection(int id, int? classId) async {
//     final response = await http.get(
//         Uri.parse(InfixApi.getSectionById(id, classId)),
//         headers: Utils.setHeader(_token.toString()));
//     print('this is class id ${classId}');
//     print(InfixApi.getSectionById(id, classId));
//     if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       return SectionListModel.fromJson(jsonData['data']['teacher_sections']);
//     } else {
//       throw Exception('Failed to load');
//     }
//   }
// }
