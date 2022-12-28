// Flutter imports:
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/staff_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/screens/admin/Bloc/StaffListBloc.dart';
import 'package:nextschool/screens/admin/staff/AddStaffScreen.dart';
import 'package:nextschool/screens/admin/staff/AdminStaffDetails.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../utils/Utils.dart';

// ignore: must_be_immutable
class StaffListScreen extends StatefulWidget {
  int? id;
  bool? viewOnly;

  StaffListScreen(this.id, {this.viewOnly});

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  late StaffListBloc listBloc;
  var indicator = new GlobalKey<RefreshIndicatorState>();
  
  var _staffListController = Get.put(StaffListController());
  var userDetailController = Get.put(UserDetailsController());
  @override
  void initState() {
    super.initState();
    //blocStuff.getStaffList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Staff List',
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: widget.viewOnly == false || widget.viewOnly == null,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: HexColor('#3bb28d')),
                            alignment: Alignment.center,
                            width: 30.w,
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/svg/Export.svg'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Export data',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ).fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                           final response = await http.get(
                          Uri.parse(InfixApi.exportStaffs()),
                          headers: Utils.setHeader(
                              userDetailController.token.toString()));
                      if (response.statusCode == 200) {
                        //file bytes
                        var bytes = response.bodyBytes;
                        //file name
                        var fileName = 'Staff List';
                         var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      }
                      // the downloads folder path         
                      String tempPath = '/storage/emulated/0/Download';
                      var filePath = tempPath + '/${fileName}.xlsx';
                      final buffer = bytes.buffer;

                      //save file
                      try {
                        await File(filePath).writeAsBytes(buffer.asUint8List(
                            bytes.offsetInBytes, bytes.lengthInBytes));

                        // view file using system default viewer
                        OpenFile.open(filePath);
                        Utils.showToast('File Saved at $filePath');
                        } catch (e) {
                          Utils.showToast('Error in downloading file');
                        }
                      }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _staffListController.fetchData(userDetailController.id),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.error != null) {
                        return _buildErrorWidget(snap.error.toString());
                      }
                      return _buildStaffListWidget();
                    } else if (snap.hasError) {
                      return _buildErrorWidget(snap.error.toString());
                    } else {
                      return _buildLoadingWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: widget.id == null
            ? null
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStaffScreen()),
                  );
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: HexColor('#4e88ff')),
                    child: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          SvgPicture.asset('assets/images/Add staff.svg'),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Add staffs',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CustomLoader());
  }

  Widget _buildErrorWidget(String? error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error occured: $error'),
      ],
    ));
  }

  Widget _buildStaffListWidget() {
    var data = Get.put(StaffListController());
    return Container(
      height: MediaQuery.of(context).size.height ,
      color: HexColor('#eaeaea'),
      child: Obx(
        () => GridView.builder(
          itemCount: data.totalCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.85),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (this.widget.viewOnly != null &&
                    this.widget.viewOnly == true) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         StaffDetailProfileScreen(data.staffs[index]),
                  //   ),
                  // );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffDetailsScreen(index),
                    ),
                  );
                }
              },
              child: Obx(
                () => Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            scale: 2,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            image: data.staffs[index].photo == null ||
                                    data.staffs[index].photo == ''
                                ? NetworkImage(InfixApi().root +
                                    'public/uploads/staff/demo/staff.jpg')
                                : NetworkImage(InfixApi().root +
                                    data.staffs[index].photo!),
                          ),
                        ),
                      ),
                      //add blac overlay at the bottom of the image
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                      ),
                      Positioned(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ((data.staffs[index].fullName).toLowerCase())
                                    .titleCase,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700)
                                      .fontFamily,
                                ),
                              ),
                              Text(
                                (data.staffs[index].designation ?? '')
                                    .toLowerCase()
                                    .titleCase,
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 9.sp,
                                  fontFamily: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500)
                                      .fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottom: 10,
                        left: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
