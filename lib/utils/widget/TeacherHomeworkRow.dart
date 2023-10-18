// Dart imports:
import 'dart:io';
import 'dart:math';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
// Project imports:
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/screens/teacher/homework/HomeworkDetailsScreen.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:nextschool/utils/widget/view_download_bottomsheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class TeacherHomeworkRow extends StatefulWidget {
  Homework homework;
  final _token;
  TeacherHomeworkRow(this.homework, this._token);

  @override
  _TeacherHomeworkRowState createState() => _TeacherHomeworkRowState();
}

class _TeacherHomeworkRowState extends State<TeacherHomeworkRow> {
  var progress = 'Download';
  var received;

  Random random = Random();

  GlobalKey _globalKey = GlobalKey();
  String? id;

  String? directory;

  late SimulatedDownloadController downloadController;

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _localPath(),
      builder: ((context, snapshot) {
        if (widget.homework.fileUrl != null &&
            widget.homework.fileUrl!.isNotEmpty) {
          var url = InfixApi().root + widget.homework.fileUrl!;
          var fileName = url.split('/').last;
          var filePath = '${snapshot.data.toString()}/$fileName';
          var fileExists;
          //check if file exists
          var file = File(filePath);
          if (file.existsSync()) {
            fileExists = true;
          } else {
            fileExists = false;
          }

          downloadController = SimulatedDownloadController(
              path: 'teacher/homework',
              url: InfixApi().root + widget.homework.fileUrl!,
              downloadStatus: fileExists
                  ? DownloadStatus.downloaded
                  : DownloadStatus.notDownloaded,
              onOpenDownload: () {
                _openDownload(filePath);
              });
        }
        var url = InfixApi().root + (widget.homework.fileUrl ?? '');
        var fileName = url.split('/').last;
        return Card(
          margin: EdgeInsets.all(12.sp),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                key: _globalKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                    ),
                                    child: Text(
                                      widget.homework.subjectName!,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: HexColor('#16275a'),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Description : ',
                        maxLines: 1,
                        style: TextStyle(
                            color: HexColor('#3b405a'),
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.homework.description!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                  color: HexColor('#4f536a'),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: HexColor('#E1E4ED'),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: HexColor('#1E3377'),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: SvgPicture.asset(
                                  'assets/svg/Calander Icon.svg',
                                  // width: 12,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Assigned Date: ',
                                    style: TextStyle(
                                        color: HexColor('#3b405a'),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.homework.homeworkDate!,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#3b405a'),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 45,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Due Date: ',
                                    style: TextStyle(
                                        color: HexColor('#3b405a'),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    widget.homework.submissionDate!,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#3b405a'),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 35,
                          child: Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: HexColor('#4AC19E')),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          HomeworkDetailsScreen(
                                              widget.homework, widget._token)));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/arrow-right.svg',
                                      color: Colors.white,
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // widget.homework.fileUrl != null &&
                      //         widget.homework.fileUrl!.isNotEmpty
                      //     ? Container(
                      //         decoration: BoxDecoration(
                      //             color: HexColor('#E1E4ED'),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Row(
                      //           children: [
                      //             Expanded(
                      //               child: Row(
                      //                 children: [
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                         color: HexColor('#BEC4D4'),
                      //                         borderRadius:
                      //                             const BorderRadius.only(
                      //                                 bottomLeft:
                      //                                     Radius.circular(10),
                      //                                 topLeft:
                      //                                     Radius.circular(
                      //                                         10))),
                      //                     child: Center(
                      //                       child: Padding(
                      //                         padding:
                      //                             const EdgeInsets.all(8),
                      //                         child: SvgPicture.asset(
                      //                           'assets/svg/Attachment Icon.svg',
                      //                           width: 15,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 10,
                      //                   ),
                      //                   Expanded(
                      //                     child: Text(
                      //                       fileName,
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                           fontSize: 12,
                      //                           color: HexColor('#3b405a'),
                      //                           fontWeight: FontWeight.w500),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                width: 70,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      widget.homework.className!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openDownload(String path) {
    if (path.contains('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(
            path: InfixApi().root + path,
          ),
        ),
      );
    } else if (path.contains('.jpg') ||
        path.contains('.png') ||
        path.contains('.jpeg')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Utils.documentViewer(path, context),
        ),
      );
    } else {
      // Utils.showSnackBar(context,
      //     "File type not supported by this app. Please use supported file viewer app.");
      Utils.showToast('File type not supported by this app.');
    }
  }

  Future<String> _localPath() async {
    Directory? directory;
    String path;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    path = directory!.path + '/Nextschool/teacher/homework';
    return path;
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.homework.subjectName!,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Text(
                            'Marks: ' + widget.homework.marks!,
                            style: Theme.of(context).textTheme.headlineSmall,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
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
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    widget.homework.homeworkDate!,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
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
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    widget.homework.submissionDate!,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Evaluation',
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    widget.homework.evaluationDate == null
                                        ? 'not assigned'
                                        : widget.homework.evaluationDate!,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                widget.homework.description == null
                                    ? ''
                                    : widget.homework.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.homework.fileUrl == null ||
                                    widget.homework.fileUrl == ''
                                ? Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 145,
                                      height: 40.0,
                                    ),
                                  )
                                : InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 145,
                                      height: 40.0,
                                      decoration: Utils.BtnDecoration,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(Icons.cloud_download),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            progress,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      // showDownloadAlertDialog(
                                      //     context, widget.homework.subjectName);
                                    },
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == 'I') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Incomplete',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      );
    } else if (status == 'C') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          child: Text(
            'Completed',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  showViewAlertDialog(BuildContext context, title) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DownloadBottomSheet(
            view: true,
            onpress: () async {
              Utils.showProcessingToast();
              // Navigator.of(context, rootNavigator: true).pop('dialog');
              if (widget.homework.fileUrl!.contains('.pdf')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadViewer(
                      title: title!,
                      filePath: InfixApi().root + widget.homework.fileUrl!,
                    ),
                    // Utils.documentViewer(widget.homework.fileUrl!, context),
                  ),
                );
              } else if (widget.homework.fileUrl!.contains('.jpg') ||
                  widget.homework.fileUrl!.contains('.png') ||
                  widget.homework.fileUrl!.contains('.jpeg')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Utils.documentViewer(
                        InfixApi().root + widget.homework.fileUrl!, context),
                  ),
                );
              } else {
                Utils.showToast('File type not supported');
              }
            });
      },
    );
  }

  showDownloadAlertDialog(BuildContext context, String? title) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DownloadBottomSheet(
            view: false,
            onpress: () async {
              widget.homework.fileUrl != null
                  ? downloadFile(widget.homework.fileUrl!, context, title)
                  : Utils.showToast('no file found');
            });
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

    String downloadName = widget.homework.subjectName!;
    String fullPath = '$dirloc/$downloadName.pdf';
    String fileSaved = '$dirloc/$downloadName.pdf/';
    //

    Utils.showToast('Downloading file Please wait...');

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
          Utils.showToast(
              'Download Completed. File is also available in your download folder.');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadViewer(
                title: title!,
                filePath: InfixApi().root + url,
              ),
            ),
          );
          Navigator.pop(context);
        } else if (url.contains('.jpg') ||
            url.contains('.png') ||
            url.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Utils.documentViewer(InfixApi().root + url, context),
            ),
          );
        } else {
          var file =
              await DefaultCacheManager().getSingleFile(InfixApi().root + url);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Utils.fullScreenImageView(InfixApi().root + url),
            ),
          );
          Navigator.pop(context);

          Utils.showToast(
              'Download Completed. File is also available in your download folder.');
        }
      }
    }).catchError((error) {
      var msg = error.response!.data['message'];
      Utils.showErrorToast(msg);
    });
    if (received == 100.0) {
      Utils.showToast(
          'Download Completed. File is also available in your download folder.');
      if (url.contains('.pdf')) {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DownloadViewer(
              title: title!,
              filePath: InfixApi().root + url,
            ),
          ),
        );
      } else if (url.contains('.jpg') ||
          url.contains('.png') ||
          url.contains('.jpeg')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Utils.documentViewer(InfixApi().root + url, context),
          ),
        );
      } else {
        var file =
            await DefaultCacheManager().getSingleFile(InfixApi().root + url);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Utils.fullScreenImageView(InfixApi().root + url),
          ),
        );
        Navigator.pop(context);

        Utils.showToast(
            'Download Completed. File is also available in your download folder.');
      }
    }
  }
}
// showDeleteAlertDialog(BuildContext context) {
//   custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topRight: Radius.circular(100), topLeft: Radius.circular(100))),
//     isDismissible: false,
//     enableDrag: false,
//     context: context,
//     builder: (context) {
//       return DeleteBottomSheet(onDelete: () async {
//         Utils.showProcessingToast();
//         setState(() {
//           deleteContent(widget.homework.id);
//         });
//       });
//     },
//   );
// }
//
// Future<void> deleteContent(int? id) async {
//   final response = await http.get(Uri.parse(InfixApi.deletHomework(id)),
//       headers: Utils.setHeader(widget._token!));
//   if (response.statusCode == 200) {
//     Utils.showToast('Homework deleted successfully');
//     Navigator.pop(context);
//     Navigator.pop(context);
//     Navigator.pop(context);
//   } else {
//     throw Exception('failed to load');
//   }
// }
