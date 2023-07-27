import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Leave.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class LeaveDetailScreen extends StatefulWidget {
  Leave leave;

  LeaveDetailScreen(this.leave, {Key? key}) : super(key: key);

  @override
  _LeaveDetailScreenState createState() => _LeaveDetailScreenState();
}

var _titleStyle = const TextStyle(
    color: Color(0xFFb0b2b8), fontSize: 12, fontWeight: FontWeight.w600);

class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  String formatDate(DateTime date) => new DateFormat('E, d MMM y').format(date);
  var progress = 'Download';
  var received;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'Leave Details'),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Leave Type',
                    style: _titleStyle,
                  ),
                  Utils.sizedBoxHeight(6),
                  Text(
                    widget.leave.type ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Duration',
                    style: _titleStyle,
                  ),
                  Utils.sizedBoxHeight(6),
                  Text(
                    formatDate(DateTime.parse(widget.leave.from!)) +
                        ' - ' +
                        formatDate(DateTime.parse(widget.leave.to!)),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Applied On',
                    style: _titleStyle,
                  ),
                  Utils.sizedBoxHeight(6),
                  Text(
                    formatDate(DateTime.parse(widget.leave.apply!)),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Total Leave',
                    style: _titleStyle,
                  ),
                  Utils.sizedBoxHeight(6),
                  Text(
                    (Utils.calculateLeaveDays(
                                    widget.leave.from!, widget.leave.to!) +
                                1)
                            .toString() +
                        ' Days',
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
                    widget.leave.reason!,
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
                            getStatus(context, widget.leave.status),
                          ],
                        ),
                      ),
                      Container(height: 60, child: const VerticalDivider()),
                      Visibility(
                        visible: widget.leave.file != null &&
                            widget.leave.file != '',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (widget.leave.file!.contains('.pdf')) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PdfView(
                                                  path: InfixApi().root +
                                                      widget.leave.file!)),
                                        );
                                      } else if (widget.leave.file!
                                              .contains('.jpg') ||
                                          widget.leave.file!.contains('.png') ||
                                          widget.leave.file!
                                              .contains('.jpeg')) {
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
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
    Dio dio = Dio();

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;

    try {
      //
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
                        )));
          } else {
            var file = await DefaultCacheManager()
                .getSingleFile(InfixApi().root + url);
            // OpenFile.open(file.path);
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
}
