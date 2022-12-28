// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/HomeworkEvaluation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

import '../FunctionsData.dart';
import '../Utils.dart';

class HomeWorkEvaluationDetailsRow extends StatefulWidget {
  HomeWorkEvaluationDetailsRow(this.studentHomeworkEvaluation);

  final StudentHomeworkEvaluation studentHomeworkEvaluation;

  @override
  _HomeWorkEvaluationDetailsRowState createState() =>
      _HomeWorkEvaluationDetailsRowState();
}

class _HomeWorkEvaluationDetailsRowState
    extends State<HomeWorkEvaluationDetailsRow> {
  var progress = 'Download';
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
    super.initState();
  }

  showDownloadAlertDialog(
      BuildContext context, String? title, String? fileUrl) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (fileUrl!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfView(
                path: InfixApi().root + fileUrl,
              ),
            ),
          );
        } else if (fileUrl.contains('.jpg') ||
            fileUrl.contains('.png') ||
            fileUrl.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Utils.fullScreenImageView(
                InfixApi().root + fileUrl,
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
        fileUrl != null
            ? downloadFile(fileUrl, context, title)
            : Utils.showToast('no file found');
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
      String url, BuildContext context, String? title) async {
    Dio dio = Dio();

    String dirloc = '';
    if (Platform.isAndroid) {
      dirloc = (await getExternalStorageDirectory())!.path;
    } else if (Platform.isIOS) {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    try {
      String downloadName = widget.studentHomeworkEvaluation.subjectName!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
      FileUtils.mkdir([fullPath]);
      Utils.showToast('Downloading...');

      await dio.download(
          InfixApi().root + url, fileSaved + AppFunction.getExtention(url),
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
                    builder: (context) => DownloadViewer(
                        title: title!, filePath: InfixApi().root + url)));
          } else {
            var file = await DefaultCacheManager()
                .getSingleFile(InfixApi().root + url);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Utils.fullScreenImageView(file.path),
              ),
            );
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.studentHomeworkEvaluation.subjectName!,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(14)),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    showDownloadAlertDialog(
                        context,
                        widget.studentHomeworkEvaluation.subjectName,
                        widget.studentHomeworkEvaluation.file);
                  },
                  child: const Icon(
                    FontAwesomeIcons.download,
                    size: 15,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Created',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.studentHomeworkEvaluation.homeworkDate == null
                          ? 'not assigned'
                          : widget.studentHomeworkEvaluation.homeworkDate!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Submission',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.studentHomeworkEvaluation.submissionDate == null
                          ? 'not assigned'
                          : widget.studentHomeworkEvaluation.submissionDate!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              /* Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Evaluation',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.studentHomeworkEvaluation.evaluationDate == null
                          ? 'N/A'
                          : widget.studentHomeworkEvaluation.evaluationDate,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Marks',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.studentHomeworkEvaluation.marks == null
                          ? 'not assigned'
                          : widget.studentHomeworkEvaluation.marks.toString(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
