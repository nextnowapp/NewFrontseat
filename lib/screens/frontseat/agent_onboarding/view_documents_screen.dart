// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// import 'package:stockview/models/user_detail_model.dart';
// import 'package:stockview/utils/theme.dart';
// import 'package:stockview/utils/utils.dart';
// import 'package:stockview/widget/textwidget.dart';
// import '../config/app_config.dart';

// class ViewDocumentsScreen extends StatefulWidget {
//   const ViewDocumentsScreen({this.data, Key? key}) : super(key: key);
// final UserDetailModel? data;
//   @override
//   State<ViewDocumentsScreen> createState() => _ViewDocumentsScreenState();
// }

// class _ViewDocumentsScreenState extends State<ViewDocumentsScreen> {
//   var progress = 'Download';
//   var received;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const TextWidget(txt: "View Documents"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Container(
//               width: double.infinity,
//               height: 75,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black,
//                   blurRadius: 1.0,
//                 ),
//               ], color: white, borderRadius: BorderRadius.circular(10)),
//               child: ViewDocumentCard(
//                 asset: 'assets/images/pdf.png',
//                 title: widget.data!.data!.userDocs![4].name!,
//                 view: ()async{},
//                 download: ()async{},
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> downloadFile(
//       String url, BuildContext context, String? title) async {
//     print('URL: $url');
//     Dio dio = Dio();

//     String dirloc = '';
//     dirloc = (await getApplicationDocumentsDirectory()).path;
//     // Utils.showToast('Downloading in progress....');
//     try {
//       // FileUtils.mkdir([dirloc]);
//       await dio.download(
//           AppConfig.baseUrl + url, dirloc + Utils.getExtention(url),
//           options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
//           onReceiveProgress: (receivedBytes, totalBytes) async {
//         received = ((receivedBytes / totalBytes) * 100);
//         setState(() {
//           progress =
//               ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
//         });

//         if (received == 100.0) {
//           // Utils.showToast('Files has been downloaded to $dirloc');

//           if (url.contains('.pdf')) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PdfView(path: AppConfig.baseUrl + url),
//               ),
//             );
//           } else {
//             var file = await DefaultCacheManager()
//                 .getSingleFile(AppConfig.baseUrl + url);
//           }
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// class ViewDocumentCard extends StatelessWidget {
//    ViewDocumentCard({Key? key, required this.title, required this.asset,
//   required this.view,required this.download})
//       : super(key: key);
//   String title;
//   String asset;
//   AsyncCallback view;
//   AsyncCallback download;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Image.asset(
//           asset,
//         ),
//         TextWidget(
//           txt: title,
//           weight: FontWeight.w500,
//           size: 18,
//         ),
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               InkWell(
//                 onTap: view,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 35,
//                       width: 35,
//                       child: Image.asset(
//                         'assets/images/view.png',
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     const TextWidget(
//                       txt: 'View',
//                       size: 12,
//                     )
//                   ],
//                 ),
//               ),
//               Utils.sizedBoxWidth(25),
//               InkWell(
//                 onTap: download,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 35,
//                       width: 35,
//                       child: Image.asset(
//                         'assets/images/download.png',
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     const TextWidget(
//                       txt: 'Download',
//                       size: 12,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
