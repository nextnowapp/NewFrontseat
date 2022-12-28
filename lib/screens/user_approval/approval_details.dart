import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/UserDetailModel.dart';
import 'package:nextschool/utils/widget/DetailFields.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';

class UserApprovalDetailScreen extends StatefulWidget {
  UserApprovalDetailScreen(
      {Key? key, required this.voucher, this.isApproved = false})
      : super(key: key);
  String voucher;
  bool isApproved;

  @override
  State<UserApprovalDetailScreen> createState() =>
      _UserApprovalDetailScreenState();
}

class _UserApprovalDetailScreenState extends State<UserApprovalDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _token;
  Future<UserApprovalDetails?>? data;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _token = _userDetailsController.token;
    data = fetchContent(widget.voucher);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Padding(
            padding: const EdgeInsets.only(right: 18.0, left: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.0,
                              color: Color(0xffaaabb7),
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        updateStatus(widget.voucher, 2);
                      },
                      child: const TextWidget(
                        txt: 'Reject Profile',
                        clr: Color(0xff8da2b6),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                this.widget.isApproved
                    ? Container()
                    : SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff8493af)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                              updateStatus(widget.voucher, 1);
                            },
                            child: const TextWidget(
                              txt: 'Approve Profile',
                            )),
                      )
              ],
            ),
          )),
      appBar: CustomAppBarWidget(
        title: 'Review Profile',
      ),
      body: FutureBuilder<UserApprovalDetails?>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 65.w,
                                child: TextWidget(
                                  txt:
                                      '${snapshot.data!.data!.first.lFirstName!} ${snapshot.data!.data!.first.lMiddleName!}  ${snapshot.data!.data!.first.lLastName!}'
                                          .titleCase,
                                  size: 19,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextWidget(
                                  txt:
                                      'Class : ${snapshot.data!.data!.first.lClass ?? ""}')
                            ],
                          ),
                        )
                      ],
                    ),
                    DetailFields(
                        title: 'Learner ID : ',
                        value: snapshot.data!.data!.first.learnerId ?? ''),
                    DetailFields(
                        title: 'Gender : ',
                        value: snapshot.data!.data!.first.lGender == '1'
                            ? 'Male'
                            : 'Female'),
                    DetailFields(
                        title: 'Date of Birth : ',
                        value: snapshot.data!.data!.first.lDob!),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: HexColor('#f1f5f9'),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: TabBar(
                        splashFactory: InkRipple.splashFactory,
                        splashBorderRadius: BorderRadius.circular(20.0),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontFamily:
                              GoogleFonts.inter(fontWeight: FontWeight.w700)
                                  .fontFamily,
                          color: HexColor('#8a96a0'),
                          fontSize: 10.sp,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontFamily:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)
                                  .fontFamily,
                          color: HexColor('#8a96a0'),
                          fontSize: 10.sp,
                        ),
                        unselectedLabelColor: HexColor('#8a96a0'),
                        indicator: BoxDecoration(
                          color: HexColor('#5374ff'),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        controller: _tabController,
                        isScrollable: false,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: <Widget>[
                          const Tab(text: 'Learner Details'),
                          const Tab(text: 'Parent Details'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  DetailFields(
                                    title: 'Date of Birth : ',
                                    value:
                                        snapshot.data!.data!.first.lDob ?? '',
                                  ),
                                  DetailFields(
                                    title: 'E-mail id : ',
                                    value:
                                        snapshot.data!.data!.first.lEmail ?? '',
                                  ),
                                  DetailFields(
                                    title: 'Admission Number : ',
                                    value: snapshot
                                            .data!.data!.first.admissionNo ??
                                        '',
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                        ListView(
                          children: [
                            const SizedBox(height: 10),
                            const TextWidget(
                              txt: 'Parent 1 Details',
                              size: 20,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DetailFields(
                                title: 'Relation : ',
                                value: snapshot.data!.data!.first.p1Relation ??
                                    ''),
                            DetailFields(
                                title: 'Name : ',
                                value: snapshot.data!.data!.first.p1FirstName ??
                                    ''),
                            DetailFields(
                                title: 'Phone Number : ',
                                value:
                                    snapshot.data!.data!.first.p1Mobile ?? ''),
                            DetailFields(
                                title: 'Date of Birth : ',
                                value: snapshot.data!.data!.first.p1Dob ?? ''),
                            DetailFields(
                                title: 'Address : ',
                                value:
                                    snapshot.data!.data!.first.p1Address ?? ''),
                            DetailFields(
                                title: 'E-mail id : ',
                                value:
                                    snapshot.data!.data!.first.p1Email ?? ''),
                            // DetailFields(
                            //     title: 'Nid : ',
                            //     value: snapshot.data!.data!.first.p1Nid ?? ''),
                            DetailFields(
                                title: 'Occupation : ',
                                value:
                                    snapshot.data!.data!.first.p1Occupation ??
                                        ''),
                            //p2
                            Visibility(
                              visible: snapshot.data!.data!.first.p2FirstName !=
                                  null,
                              child: Column(
                                children: [
                                  const TextWidget(
                                    txt: 'Parent 2 Details',
                                    size: 20,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DetailFields(
                                      title: 'Relation : ',
                                      value: snapshot
                                              .data!.data!.first.p2Relation ??
                                          ''),
                                  DetailFields(
                                      title: 'Name : ',
                                      value: snapshot
                                              .data!.data!.first.p2FirstName ??
                                          ''),
                                  DetailFields(
                                      title: 'Phone Number : ',
                                      value:
                                          snapshot.data!.data!.first.p2Mobile ??
                                              ''),
                                  DetailFields(
                                      title: 'Date of Birth : ',
                                      value: snapshot.data!.data!.first.p2Dob ??
                                          ''),
                                  DetailFields(
                                      title: 'Address : ',
                                      value: snapshot
                                              .data!.data!.first.p2Address ??
                                          ''),
                                  DetailFields(
                                      title: 'E-mail id : ',
                                      value:
                                          snapshot.data!.data!.first.p2Email ??
                                              ''),
                                  // DetailFields(
                                  //     title: 'Nid : ',
                                  //     value: snapshot.data!.data!.first.p2Nid ??
                                  //         ''),
                                  DetailFields(
                                      title: 'Occupation : ',
                                      value: snapshot
                                              .data!.data!.first.p2Occupation ??
                                          ''),
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: CustomLoader());
            }
          }),
    );
  }

  Future<UserApprovalDetails?>? fetchContent(String voucher) async {
    print('fetch content started');
    final response = await http.post(
        Uri.parse(InfixApi.getUserApprovalDetails()),
        body: jsonEncode({'id': '$voucher'}),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      print(response);
      var jsonData = jsonDecode(response.body);
      var data = UserApprovalDetails.fromJson(jsonData);
      return data;
    } else {
      var msg = jsonDecode(response.body)['message'];
      Utils.showErrorToast(msg);
      throw Exception('failed to load');
    }
    return null;
  }

  updateStatus(String voucher, int? status) async {
    final response = await http.post(Uri.parse(InfixApi.userStatusUpdate()),
        body: jsonEncode({'id': '$voucher', 'approval_status': status}),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Utils.showToast('Status Updated Successfully');
    } else {
      var msg = jsonDecode(response.body)['message'];
      Utils.showErrorToast(msg);
      throw Exception('failed to load');
    }
    return null;
  }
}
