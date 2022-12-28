// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nextschool/utils/CardItem.dart';
// import 'package:nextschool/utils/CustomAppBarWidget.dart';
// import 'package:nextschool/utils/FunctionsData.dart';

// class VoucherHomeScreen extends StatefulWidget {
//   var _titles;
//   var _images;

//   VoucherHomeScreen(this._titles, this._images);

//   @override
//   _VoucherHomeScreenState createState() =>
//       _VoucherHomeScreenState(_titles, _images);
// }

// class _VoucherHomeScreenState extends State<VoucherHomeScreen> {
//   bool? isTapped;
//   int? currentSelectedIndex;
//   var _titles;
//   var _images;

//   _VoucherHomeScreenState(this._titles, this._images);
//   @override
//   void initState() {
//     super.initState();
//     isTapped = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         title: 'Vouchers Search',
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: GridView.builder(
//           itemCount: _titles.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3),
//           itemBuilder: (context, index) {
//             return CustomWidget(
//               index: index,
//               isSelected: currentSelectedIndex == index,
//               onSelect: () {
//                 setState(() {
//                   currentSelectedIndex = index;
//                 });
//               },
//               element: AppFunction.getVoucherDashboard(context, _titles[index]),
//               headline: _titles[index],
//               icon: _images[index],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

///remove this