// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
// Package imports:
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:nextschool/utils/model/StudentLeave.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import '../../../utils/FunctionsData.dart';
import '../../../utils/exception/DioException.dart';
import '../studyMaterials/StudyMaterialViewer.dart';

// ignore: must_be_immutable
class LeaveListStudent extends StatefulWidget {
  String? id;

  LeaveListStudent({this.id});

  @override
  _LeaveListStudentState createState() => _LeaveListStudentState();
}

class _LeaveListStudentState extends State<LeaveListStudent>
    with SingleTickerProviderStateMixin {
  var id;
  late Response response;
  Dio dio = Dio();
  TabController? _tabController;
  String? _token;
  Future? myLeaves;
  String? _id;
  Future? pendingLeaves;
  Future? approvedLeaves;
  Future? rejectedLeaves;
  var progress = 'Download';
  var received;
  String? radioStr = 'Pending';
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  static List<Tab> _tabs = <Tab>[
    Tab(
      text: 'Pending'.toUpperCase(),
    ),
    Tab(
      text: 'Approved'.toUpperCase(),
    ),
    Tab(
      text: 'Denied'.toUpperCase(),
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _token = _userDetailsController.token;
    myLeaves = getMyLeaves(widget.id);
    pendingLeaves = getPendingLeaves(widget.id);
    approvedLeaves = getApprovedLeaves(widget.id);
    rejectedLeaves = getRejectedLeaves(widget.id);
  }

  var _titleStyle = const TextStyle(
      color: Color(0xFFb0b2b8), fontSize: 14, fontWeight: FontWeight.w600);

  String formatDate(DateTime date) => new DateFormat('E, d MMM y').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'My Leaves',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF222744),
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // isScrollable: true,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: const Color(0xFF4E88FF),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                tabs: _tabs,
              ),
            ),
          ),
          Expanded(
            child: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: DefaultTabController(
                length: _tabs.length,
                initialIndex: 0,
                child: Builder(
                  builder: (context) {
                    final TabController tabController =
                        DefaultTabController.of(context);
                    tabController.addListener(() {
                      if (tabController.indexIsChanging) {
                        print(tabController.index);
                      }
                    });
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  getLeaves(pendingLeaves),
                                  getLeaves(approvedLeaves),
                                  getLeaves(rejectedLeaves),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // buildPageView(),
        ],
      ),
    );
  }

  Widget getLeaves(Future? future) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<LeaveAdminList>(
        future: future!.then((value) => value as LeaveAdminList),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.leaves.length > 0) {
              var data = snapshot.data!.leaves;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    //reverse the list
                    var ref = data[data.length - index - 1];
                    return Card(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          // border: Border.all(
                          //   width: 1,
                          //   color: Color(0xFF222744),
                          // ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ref.type!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(
                              ((Utils.calculateLeaveDays(
                                              ref.leaveFrom!, ref.leaveTo!) +
                                          1)
                                      .toString()) +
                                  ' Day / ' +
                                  ref.leaveFrom! +
                                  ' - ' +
                                  ref.leaveTo!,
                              style: _titleStyle,
                            ),
                            const Divider(),
                            Utils.sizedBoxHeight(6),
                            Text(
                              'Applied On',
                              style: _titleStyle,
                            ),
                            Utils.sizedBoxHeight(6),
                            Text(
                              formatDate(DateTime.parse(ref.applyDate!)),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Text(
                              'Reason',
                              style: _titleStyle,
                            ),
                            Utils.sizedBoxHeight(6),
                            Text(
                              ref.reason!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Leave Status',
                                        style: _titleStyle,
                                      ),
                                      Utils.sizedBoxHeight(12),
                                      getStatus(context, ref.status),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 60, child: const VerticalDivider()),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Uploaded File',
                                        style: _titleStyle,
                                      ),
                                      Utils.sizedBoxHeight(6),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (ref.file!.contains('.pdf')) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        //     EbookPDFView(
                                                        //   url: AppConfig
                                                        //           .domainName! +
                                                        //       ref.file!,
                                                        // ),
                                                        PdfView(
                                                            path: InfixApi()
                                                                    .root +
                                                                ref.file!),
                                                  ),
                                                );
                                              } else if (ref.file!
                                                      .contains('.jpg') ||
                                                  ref.file!.contains('.png') ||
                                                  ref.file!.contains('.jpeg')) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Utils.documentViewer(
                                                            InfixApi().root +
                                                                ref.file!,
                                                            context),
                                                  ),
                                                );
                                              } else {
                                                // Utils.showSnackBar(context,
                                                //     "File type not supported by this app. Please use supported file viewer app.");
                                                Utils.showToast(
                                                    'File type not supported by this app. Please use supported file viewer app.');
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'assets/images/view.png',
                                                  width: 20,
                                                ),
                                                const Text(
                                                  'View',
                                                  style: TextStyle(
                                                      color: Color(0xFF222744),
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Utils.sizedBoxWidth(32),
                                          GestureDetector(
                                            onTap: () {
                                              downloadFile(ref.file!, context,
                                                  ref.file!.split('/').last);
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'assets/images/download.png',
                                                  width: 20,
                                                ),
                                                const Text(
                                                  'Download',
                                                  style: TextStyle(
                                                      color: Color(0xFF222744),
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Utils.noDataTextWidget();
            }
          } else {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CustomLoader(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget getStatus(BuildContext context, String? status) {
    if (status == 'P') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefc5),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Pending',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFc08b02),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else if (status == 'R') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefee),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Rejected',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFff8989),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else if (status == 'A') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFb7f6d3),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Approved',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFF449e58),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else if (status == 'C') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefee),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Denied',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFff8989),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  showAlertDialog(BuildContext context, {int? id}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Leave Status',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: ScreenUtil().setSp(14)),
                                maxLines: 1,
                              ),
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text('Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(14))),
                              value: 'Pending',
                              onChanged: (dynamic val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text('Approved',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(14))),
                              value: 'Approve',
                              onChanged: (dynamic val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text('Denied',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(14))),
                              value: 'Cancel',
                              onChanged: (dynamic val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.purple,
                                  ),
                                  child: Text(
                                    'Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14)),
                                  ),
                                ),
                              ),
                              onTap: () {
                                /* Utils.showToast(
                                    '${widget.leave.id}  $radioStr');*/
                                setState(() {
                                  addUpdateData(id, radioStr!.substring(0, 1))!
                                      .then((value) {
                                    if (value!) {
                                      Navigator.pop(context);
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<StudentMyLeavesList?>? getMyLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.studentApplyLeave(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentMyLeavesList.fromJson(jsonData['data']['my_leaves']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  Future<LeaveAdminList?>? getApprovedLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.approvedLeaves(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(
          jsonData['data']['approve_student_request']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
    Dio dio = Dio();

    String dirloc = '';
    if (Platform.isAndroid) {
      dirloc = '/sdcard/Download/';
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    try {
      
      Utils.showToast('Downloading...');

      await dio.download(
          InfixApi().root + url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        setState(() {
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
        });
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            // Utils.showSnackBar(context,
            //     "Download Completed. File is also available in your download folder.",
            //     color: Colors.green);
            Utils.showToast(
                'Download Completed. File is also available in your download folder.');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DownloadViewer(title: title, filePath: url)));
          } else {
            var file = await DefaultCacheManager()
                .getSingleFile(InfixApi().root + url);
            // OpenFile.open(file.path);

            // Utils.showSnackBar(context,
            //     "Download Completed. File is also available in your download folder.",
            //     color: Colors.green);
            Utils.showToast(
                'Download Completed. File is also available in your download folder.');
          }
        }
      });
    } catch (e) {
      print(e);
    }
    // progress = "Download Completed.Go to the download folder to find the file";
  }

  Future<LeaveAdminList?>? getPendingLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.pendingLeaves(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(
          jsonData['data']['pending_student_request']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  Future<bool?>? addUpdateData(int? id, String status) async {
    response = await dio
        .get(
      InfixApi.setLeaveStatus(id, status),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      // Utils.showSnackBar(context, 'Leave Updated', color: Colors.green);
      Utils.showToast('Leave Updated');
      return true;
    } else {
      return false;
    }
    return null;
  }

  Future<LeaveAdminList?>? getRejectedLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.rejectedLeaves(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data']['rejected_request']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
