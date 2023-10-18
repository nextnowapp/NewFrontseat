// // Flutter imports:
// import 'package:flutter/material.dart';
// import 'package:nextschool/screens/admin/voucher/voucher_detail.dart';
// // Project imports:
// import 'package:nextschool/screens/student/StudentAttendance.dart';
// import 'package:nextschool/utils/apis/Apis.dart';
// import 'package:nextschool/utils/model/Student.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VoucherRow extends StatefulWidget {
//   int? AddmissionNo;
//   int? classCode;
//   int? sectionCode;
//   var student;
//   String? status;
//   String? token;
//   VoucherRow(this.student,
//       {this.status,
//       this.token,
//       this.classCode,
//       this.sectionCode,
//       this.AddmissionNo});

//   @override
//   _VoucherRowState createState() => _VoucherRowState(
//         student,
//         status: status,
//         token: token,
//         classCode: classCode,
//         sectionCode: sectionCode,
//       );
// }

// class _VoucherRowState extends State<VoucherRow> {
//   Student student;
//   String? status;
//   String? token;
//   int? classCode;
//   int? sectionCode;
//   int? AddmissionNo;

//   _VoucherRowState(this.student,
//       {this.status,
//       this.token,
//       this.classCode,
//       this.sectionCode,
//       this.AddmissionNo});
//   @override
//   Widget build(BuildContext context) {
//     String image = student.photo == null || student.photo == ''
//         ? 'http://saskolhmg.com/images/studentprofile.png'
//         : InfixApi().root + student.photo!;
//     return InkWell(
//       onTap: () async {
//         if (status == 'attendance') {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => StudentAttendanceScreen(
//                         id: student.uid,
//                         token: token,
//                       )));
//         } else {
//           // Navigator.push(
//           //     context,
//           //     ScaleRoute(
//           //         page: Profile(
//           //       id: student.uid.toString(),
//           //       image: image,
//           //     )));
//           //use material page route to navigate
//           // final SharedPreferences passcode =
//           //     await SharedPreferences.getInstance();

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => VoucherDetail(
//                         // sharedPrefInstance: passcode,
//                         id: student.uid.toString(),
//                         image: image,
//                       )));
//         }
//       },
//       splashColor: Colors.purple.shade200,
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25.0,
//               backgroundImage: NetworkImage(image),
//               backgroundColor: Colors.grey,
//             ),
//             title: Text(
//               student.name!,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             subtitle: Row(
//               children: [
//                 Text('Grade : ${student.}',
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         color: const Color(0xff415094),
//                         fontWeight: FontWeight.w400)),
//               ],
//             ),
//           ),
//           Container(
//             height: 0.5,
//             margin: const EdgeInsets.only(top: 10.0),
//             color: Colors.grey[300],
//           )
//         ],
//       ),
//     );
//   }
// }
