// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class LeaveRowLayout extends StatefulWidget {
  LeaveAdmin leave;
  bool? isStaff;

  LeaveRowLayout(this.leave, {this.isStaff});

  @override
  _LeaveRowLayoutState createState() => _LeaveRowLayoutState();
}

class _LeaveRowLayoutState extends State<LeaveRowLayout> {
  late Response response;
  Dio dio = Dio();
  String? radioStr = 'Pending';
  String? _token;
  var progress = 'Download';
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  var received;

  void getPermission() async {
    print('getPermission');
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.manageExternalStorage
    ].request();
    print(permissions[Permission.storage]);
  }

  @override
  void initState() {
    getPermission();
    _token = _userDetailsController.token;
    super.initState();
  }

  var _titleStyle = const TextStyle(
      color: Color(0xFFb0b2b8), fontSize: 14, fontWeight: FontWeight.w600);

  String formatDate(DateTime date) => new DateFormat('dd-MM-yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(width: 1, color: const Color(0xFF222744))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.leave.type!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: const Icon(
                      Icons.navigate_next,
                      color: Color(0xFFb0b2b8),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              (Utils.calculateLeaveDays(
                              widget.leave.leaveFrom!, widget.leave.leaveTo!) +
                          1)
                      .toString() +
                  ' Day / ' +
                  formatDate(DateTime.parse(widget.leave.leaveFrom!)) +
                  ' - ' +
                  formatDate(DateTime.parse(widget.leave.leaveTo!)),
              style: _titleStyle,
            ),
            const Divider(),
            Utils.sizedBoxHeight(6),
            Row(
              children: [
                CircleAvatar(
                  radius: ScreenUtil().setSp(30),
                  child: CachedNetworkImage(
                    imageUrl: InfixApi().root + widget.leave.student_photo!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: InfixApi().root +
                          'public/uploads/staff/demo/staff.jpg',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Utils.sizedBoxWidth(16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.leave.fullName!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                      visible: widget.leave.class_name != null &&
                          widget.leave.section_name != '',
                      child: Text(
                        'Class ' +
                            widget.leave.class_name! +
                            widget.leave.section_name! +
                            ' | Roll no.' +
                            widget.leave.roll_no!,
                        style: _titleStyle,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Utils.sizedBoxHeight(6),
            const Divider(),
            Text(
              'Applied On',
              style: _titleStyle,
            ),
            Utils.sizedBoxHeight(6),
            Text(
              formatDate(DateTime.parse(widget.leave.applyDate!)),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              'Reason',
              style: _titleStyle,
            ),
            Utils.sizedBoxHeight(6),
            Text(
              widget.leave.reason!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      getStatus(context, widget.leave.status),
                    ],
                  ),
                ),
                Container(height: 60, child: const VerticalDivider()),
                Visibility(
                  visible: widget.leave.file != null && widget.leave.file != '',
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Uploaded File',
                          style: _titleStyle,
                        ),
                        Utils.sizedBoxHeight(6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.leave.file!.contains('.pdf')) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfView(
                                        path:  InfixApi().root +
                                            widget.leave.file!,
                                      ),
                                    ),
                                  );
                                } else if (widget.leave.file!
                                        .contains('.jpg') ||
                                    widget.leave.file!.contains('.png') ||
                                    widget.leave.file!.contains('.jpeg')) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Utils.documentViewer(
                                               InfixApi().root +
                                                  widget.leave.file!,
                                              context),
                                    ),
                                  );
                                } else {
                                  // Utils.showSnackBar(context,
                                  //     "File type not supported by this app. Please use supported file viewer app.");
                                  Utils.showToast(
                                      'File type not supported by this app.');
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
                                        color: Color(0xFF222744), fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Utils.sizedBoxWidth(32),
                            GestureDetector(
                              onTap: () {
                                downloadFile(widget.leave.file!, context,
                                    widget.leave.file!.split('/').last);
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
                                        color: Color(0xFF222744), fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
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
                                    .headline4!
                                    .copyWith(fontSize: ScreenUtil().setSp(14)),
                                maxLines: 1,
                              ),
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text('Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
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
                                      .headline4!
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
                                      .headline4!
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
                                        .headline4!
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
                                  addUpdateData(widget.leave.id,
                                          radioStr!.substring(0, 1))!
                                      .then((value) {
                                    if (value!) {
                                      Navigator.of(context).pop();
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

  showDownloadAlertDialog(BuildContext context, String title) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (widget.leave.file!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfView(
                path:  InfixApi().root + widget.leave.file!,
              ),
            ),
          );
        } else if (widget.leave.file!.contains('.jpg') ||
            widget.leave.file!.contains('.png') ||
            widget.leave.file!.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Utils.fullScreenImageView(
                 InfixApi().root + widget.leave.file!,
              ),
            ),
          );
        } else {
          // Utils.showSnackBar(context,
          //     "File type not supported by this app. Please use supported file viewer app.");
          Utils.showToast(
              'File type not supported by this app. Please use supported file viewer app.');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        widget.leave.file != null
            ? downloadFile(widget.leave.file!, context, title)
            : Utils.showToast('no file found');
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Download',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: const Text('Would you like to download the file?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
    Dio dio = Dio();

    String dirloc = '';
    if (Platform.isAndroid) {
      dirloc = (await getExternalStorageDirectory())!.path;
    } else if (Platform.isIOS) {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }
    try {
      String downloadName = widget.leave.fullName!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
      FileUtils.mkdir([fullPath]);
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
            Utils.showToast(
                'Download Completed. File is also available in your download folder.');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DownloadViewer(
                  title: title,
                  filePath: InfixApi().root + url,
                ),
              ),
            );
          } else {
            var file = await DefaultCacheManager()
                .getSingleFile(InfixApi().root + url);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Utils.fullScreenImageView(file.path),
              ),
            );
            Utils.showToast(
                'Download Completed. File is also available in your download folder.');
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool?>? addUpdateData(int? id, String status) async {
    String url;
    print(widget.isStaff);
    if (widget.isStaff == true) {
      final body = {
        'user_id': widget.leave.staffId,
        'id': id,
        'approve_status': status
      };
      final response = await http.post(
          Uri.parse(InfixApi.setAdminLeaveStatus()),
          body: jsonEncode(body),
          headers: Utils.setHeader(_token.toString()));
      if (response.statusCode == 200) {
        Utils.showToast('Leave Updated');
        return true;
      } else {
        throw Exception('Failed to load');
      }
    } else {
      url = InfixApi.setLeaveStatus(id, status);
      response = await dio
          .get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': _token.toString(),
          },
        ),
      )
          .catchError((e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        print(errorMessage);
        Utils.showToast(errorMessage);
      });
      if (response.statusCode == 200) {
        Utils.showToast('Leave Updated');
        return true;
      } else {
        return false;
      }
    }
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
            style: Theme.of(context).textTheme.headline4!.copyWith(
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
            style: Theme.of(context).textTheme.headline4!.copyWith(
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
            style: Theme.of(context).textTheme.headline4!.copyWith(
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
            style: Theme.of(context).textTheme.headline4!.copyWith(
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
}
