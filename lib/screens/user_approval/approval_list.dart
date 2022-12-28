import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/user_approval/approval_details.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/UserApprovalStatus.dart';
import 'package:nextschool/utils/widget/ShimmerListWidget.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/DetailFields.dart';

class ApprovalListScreen extends StatefulWidget {
  const ApprovalListScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalListScreen> createState() => _ApprovalListScreenState();
}

class _ApprovalListScreenState extends State<ApprovalListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _token;
  Future<StatusList?>? data;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _token = _userDetailsController.token;
    data = fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    print(_token);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'User Approvals',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
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
                      GoogleFonts.inter(fontWeight: FontWeight.w700).fontFamily,
                  color: HexColor('#8a96a0'),
                  fontSize: 10.sp,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
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
                  const Tab(text: 'Pending'),
                  const Tab(text: 'Approved'),
                  const Tab(text: 'Declined'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                FutureBuilder<StatusList?>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(
                            child: TextWidget(
                          txt: 'No Data',
                          clr: Colors.black,
                          size: 14,
                        ));
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data!.contents.length,
                          itemBuilder: (context, index) {
                            if (snapshot
                                    .data!.contents[index].approvalStatus! ==
                                0) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 12.sp, 0, 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserApprovalDetailScreen(
                                                  voucher: snapshot
                                                      .data!.contents[index].id
                                                      .toString())),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    color: HexColor('#f1f5f9'),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          children: [
                                            DetailFields(
                                              title: 'Full Name :',
                                              value:
                                                  '${snapshot.data!.contents[index].lFirstName!} ${snapshot.data!.contents[index].lMiddleName!}  ${snapshot.data!.contents[index].lLastName!}'
                                                      .titleCase,
                                            ),
                                            DetailFields(
                                              title: 'Class :',
                                              value: snapshot.data!
                                                  .contents[index].lClass!,
                                            ),
                                            DetailFields(
                                              title: 'Voucher :',
                                              value: snapshot.data!
                                                  .contents[index].usedVoucher!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                    } else {
                      return ShimmerList();
                    }
                  },
                ),
                // Approved
                FutureBuilder<StatusList?>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(child: TextWidget(txt: 'No Data'));
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data!.contents.length,
                          itemBuilder: (context, index) {
                            if (snapshot
                                    .data!.contents[index].approvalStatus! ==
                                1) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 12.sp, 0, 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserApprovalDetailScreen(
                                                voucher: snapshot
                                                    .data!.contents[index].id
                                                    .toString(),
                                                isApproved: true,
                                              )),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    color: HexColor('#f1f5f9'),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          DetailFields(
                                            title: 'Full Name :',
                                            value:
                                                '${snapshot.data!.contents[index].lFirstName!} ${snapshot.data!.contents[index].lMiddleName!}  ${snapshot.data!.contents[index].lLastName!}',
                                          ),
                                          DetailFields(
                                            title: 'Class :',
                                            value: snapshot
                                                .data!.contents[index].lClass!,
                                          ),
                                          DetailFields(
                                            title: 'Voucher :',
                                            value: snapshot.data!
                                                .contents[index].usedVoucher!,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                    } else {
                      return ShimmerList();
                    }
                  },
                ),
                // Denied
                FutureBuilder<StatusList?>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(child: TextWidget(txt: 'No Data'));
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data!.contents.length,
                          itemBuilder: (context, index) {
                            if (snapshot
                                    .data!.contents[index].approvalStatus! ==
                                2) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 12.sp, 0, 0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  color: HexColor('#f1f5f9'),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        DetailFields(
                                          title: 'Full Name :',
                                          value:
                                              '${snapshot.data!.contents[index].lFirstName!} ${snapshot.data!.contents[index].lMiddleName!}  ${snapshot.data!.contents[index].lLastName!}',
                                        ),
                                        DetailFields(
                                          title: 'Class :',
                                          value: (snapshot.data!.contents[index]
                                                      .lClass !=
                                                  null)
                                              ? snapshot
                                                  .data!.contents[index].lClass!
                                              : 'no class',
                                        ),
                                        DetailFields(
                                          title: 'Voucher :',
                                          value: snapshot.data!.contents[index]
                                              .usedVoucher!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                    } else {
                      return ShimmerList();
                    }
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<StatusList?>? fetchContent() async {
    print('fetch content started');
    final response = await http.get(Uri.parse(InfixApi.getUserApprovalStatus()),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = StatusList.fromJson(jsonData['data']);
      print(response.body);
      return data;
    } else {
      throw Exception('failed to load');
    }
  }
}
