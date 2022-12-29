// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stockview/screens/kyc/video_kyc_help_screen.dart';

// class DocumentSubmissionCompletedScreen extends StatelessWidget {
//   const DocumentSubmissionCompletedScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'Document Submitted',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               child: Text(
//                 'Your document has been submitted for review. We will notify you once it has been approved.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//                 style: TextButton.styleFrom(
//                     primary: Colors.white, backgroundColor: Colors.red),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => const VideoKycHelpScreen()));
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(''),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
