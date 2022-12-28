// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/student/homework/StudentHomeworkDetails.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class StudentHomeworkRow extends StatefulWidget {
  Homework homework;
  String type;

  StudentHomeworkRow(this.homework, this.type);

  @override
  _StudentHomeworkRowState createState() => _StudentHomeworkRowState();
}

class _StudentHomeworkRowState extends State<StudentHomeworkRow> {
  var progress = 'Download';

  var received;

  GlobalKey _globalKey = GlobalKey();
  String? _id;

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
    var url = InfixApi().root + (widget.homework.fileUrl ?? '');
    var fileName = url.split('/').last;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                StudentHomeworkDetailsScreen(widget.homework, widget.type)));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        // clipBehavior: Clip.antiAlias,
        child: Container(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          widget.homework.subjectName!,
                          maxLines: 4,
                          style: TextStyle(
                              color: HexColor('#3b405a'),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                      child: Text(
                        widget.homework.className!,
                        maxLines: 3,
                        style: TextStyle(
                            color: HexColor('#3b405a'),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        // Image.asset(
                        //   'assets/images/description.png',
                        //   width: 20,
                        // ),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        Text(
                          'Description: ',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: HexColor('#3b405a'),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(
                        widget.homework.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            color: HexColor('#4f536a'),
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/calendar-2852107 (2).svg',
                          width: 12,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Assign Date: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor('#3b405a'),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text(
                      widget.homework.homeworkDate!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: HexColor('#3b405a'),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/calendar-2852107 (2).svg',
                          width: 12,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Due Date: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor('#3b405a'),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text(
                      widget.homework.submissionDate!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: HexColor('#3b405a'),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                widget.homework.fileUrl != null &&
                        widget.homework.fileUrl!.isNotEmpty
                    ? Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/PDF Doc.svg',
                                  width: 14,
                                  height: 20,
                                  color: HexColor('#8395ae'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 260,
                                  child: Text(
                                    fileName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: HexColor('#3b405a'),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> viewFile(String url, BuildContext context, String? title) async {
    print('URL: $url');
    Dio dio = Dio();

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;
    Utils.showToast('Just a second...');
    try {
      FileUtils.mkdir([dirloc]);
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
          Utils.showToast('Opening file...');
          if (url.contains('.pdf')) {
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
            Utils.showToast('File type not supported by this app.');
          }
        }
      });
    } catch (e) {
      print(e);
    }
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
      String downloadName = widget.homework.subjectName!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
      FileUtils.mkdir([fullPath]);

      Utils.showToast('Downloading file Please wait...');

      await dio.download(
          InfixApi().root + url, fileSaved + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
        int value = (((receivedBytes / totalBytes) * 100).toInt());

        if (received == 100.0) {
          Utils.showToast('Files has been downloaded to $fileSaved');
          Navigator.of(context).pop();

          if (url.contains('.pdf')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfView(
                  path: InfixApi().root + url,
                ),
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
            var file = await DefaultCacheManager()
                .getSingleFile(InfixApi().root + url);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Utils.fullScreenImageView(file.path),
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
      Utils.showErrorToast('Download Failed. But file is ready to open');
      Navigator.of(context).pop();

      if (url.contains('.pdf')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfView(
              path: InfixApi().root + url,
            ),
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
        var file =
            await DefaultCacheManager().getSingleFile(InfixApi().root + url);
      }
    }
  }
}
