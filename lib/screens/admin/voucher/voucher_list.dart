// // Flutter imports:
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:nextschool/screens/admin/voucher/detail_voucher.dart';
// // Project imports:
// import 'package:nextschool/utils/CustomAppBarWidget.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/exception/DioException.dart';
// import 'package:nextschool/utils/model/voucher_list.dart';
// import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
// import 'package:recase/recase.dart';

// class VoucherListScreen extends StatefulWidget {
//   int? AddmissionNo;
//   int? classCode;

//   String? name;
//   String? roll;
//   String? url;
//   String? status;
//   String? token;
//   String? date;
//   VoucherListScreen(
//       {this.AddmissionNo,
//       this.classCode,
//       this.name,
//       this.roll,
//       this.url,
//       this.status,
//       this.token,
//       this.date});

//   @override
//   _VoucherListScreenState createState() => _VoucherListScreenState(
//         classCode: classCode,
//         name: name,
//         roll: roll,
//         url: url,
//         status: status,
//         date: date,
//         token: token,
//       );
// }

// class _VoucherListScreenState extends State<VoucherListScreen> {
//   int? classCode;

//   String? name;
//   String? roll;
//   String? url;
//   Future<VoucherListCode?>? students;
//   String? status;
//   String? token;
//   String? date;
//   _VoucherListScreenState(
//       {this.classCode,
//       this.name,
//       this.roll,
//       this.url,
//       this.status,
//       this.date,
//       this.token});
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(url);
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         title: 'Learners voucher List',
//         appBarColor: HexColor('#dbe7ff'),
//       ),
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: FutureBuilder<VoucherListCode?>(
//         future: postVouchers(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             print('STATUS::: $status');
//             if (snapshot.data!.data!.length == 0) {
//               return Utils.noDataTextWidget();
//             } else
//               return ListView.builder(
//                 itemCount: snapshot.data!.data!.length,
//                 itemBuilder: (context, index) {
//                   var data = snapshot.data!.data![index];
//                   // return VoucherRow(
//                   //   snapshot.data!.data?[index],
//                   //   status: status,
//                   //   token: token,
//                   // );
//                   return Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => DetailVoucher(
//                                         addmissionNo: data.admissionNo,
//                                         passcode1: data.tP1Pass,
//                                         passcode2: data.tP2Pass,
//                                         // sharedPrefInstance: passcode,
//                                       )));
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 10, right: 10, top: 14),
//                           child: Card(
//                             elevation: 3, // Change this
//                             shadowColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),

//                             child: ListTile(
//                               title: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: 150,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           (data.firstName! +
//                                                   ' ' +
//                                                   data.lastName!)
//                                               .titleCase,
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: HexColor('#28293d'),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           'Class - ' +
//                                               data.className.toString(),
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold,
//                                             color: HexColor('#28293d'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           (data.tP1Pass == null &&
//                                                   data.tP2Pass == null)
//                                               ? Text('No Voucher',
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .headline5!
//                                                       .copyWith(
//                                                           color: HexColor(
//                                                               '#8692b2'),
//                                                           fontWeight:
//                                                               FontWeight.w600))
//                                               : (data.tP1Pass != null)
//                                                   ? Text(data.tP1Pass!,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .headline5!
//                                                           .copyWith(
//                                                               color: HexColor(
//                                                                   '#8692b2'),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600))
//                                                   : Text(data.tP1Pass!,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .headline5!
//                                                           .copyWith(
//                                                               color:
//                                                                   HexColor('#8692b2'),
//                                                               fontWeight: FontWeight.w600)),
//                                           const SizedBox(
//                                             width: 20,
//                                           ),
//                                           (data.tP2Pass != null)
//                                               ? InkWell(
//                                                   onTap: () {
//                                                     Utils.showToast(
//                                                         'Copied to clipboard');
//                                                     Clipboard.setData(
//                                                         ClipboardData(
//                                                             text:
//                                                                 data.tP2Pass!));
//                                                   },
//                                                   child: SvgPicture.asset(
//                                                       'assets/images/copy.svg'))
//                                               : InkWell(
//                                                   onTap: () {
//                                                     Utils.showToast(
//                                                         'Copied to clipboard');
//                                                     Clipboard.setData(
//                                                         ClipboardData(
//                                                             text:
//                                                                 data.tP1Pass!));
//                                                   },
//                                                   child: SvgPicture.asset(
//                                                       'assets/images/copy.svg')),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Row(
//                                         children: [
//                                           (data.tP1Pass == null &&
//                                                   data.tP2Pass == null)
//                                               ? Text('No Voucher',
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .headline5!
//                                                       .copyWith(
//                                                           color: HexColor(
//                                                               '#8692b2'),
//                                                           fontWeight:
//                                                               FontWeight.w600))
//                                               : (data.tP2Pass != null)
//                                                   ? Text(data.tP2Pass!,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .headline5!
//                                                           .copyWith(
//                                                               color: HexColor(
//                                                                   '#8692b2'),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600))
//                                                   : Container(),
//                                           const SizedBox(
//                                             width: 20,
//                                           ),
//                                           (data.tP2Pass != null)
//                                               ? InkWell(
//                                                   onTap: () {
//                                                     Utils.showToast(
//                                                         'Copied to clipboard');
//                                                     Clipboard.setData(
//                                                         ClipboardData(
//                                                             text:
//                                                                 data.tP2Pass!));
//                                                   },
//                                                   child: SvgPicture.asset(
//                                                       'assets/images/copy.svg'))
//                                               : Container(),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//           } else {
//             return ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return ShimmerList(
//                   itemCount: 1,
//                   height: 80,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<VoucherListCode?> postVouchers() async {
//     Dio dio = new Dio();

//     var response = await dio
//         .get(
//       url!,
//       options: Options(
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': token.toString(),
//         },
//       ),
//     )
//         // print('==============${response.data}====================');
//         .catchError((e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       print(errorMessage);
//       Utils.showToast(errorMessage);
//       Navigator.of(context).pop();
//       Navigator.of(context).pop();
//     });
//     if (response.statusCode == 200) {
//       return VoucherListCode.fromJson(response.data);

//       // print(response.statusCode);
//       // print(response.data['data']);
//       // List<dynamic>? data = response.data['data'];
//       // return data;

//     } else {
//       print(response.statusCode);
//       return null;
//     }
//   }
// }
