// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/UploadedContent.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class StudyMaterialListRow extends StatefulWidget {
  UploadedContent uploadedContent;

  StudyMaterialListRow(this.uploadedContent);

  @override
  State<StudyMaterialListRow> createState() => _StudyMaterialListRowState();
}

class _StudyMaterialListRowState extends State<StudyMaterialListRow> {
  var progress = '';

  var received;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // border: Border.all(color: Color(0xFF222744),style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 2), blurRadius: 2, color: Color(0x50222744)),
          BoxShadow(
              offset: Offset(-2, -2), blurRadius: 2, color: Color(0x50222744))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            print('URL"" ${widget.uploadedContent.uploadFile}');
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 25, left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/book_title.png',
                            width: 20,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'Subject: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.uploadedContent.contentTitle!,
                        maxLines: 4,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/description.png',
                            width: 20,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'Description: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.uploadedContent.description!.toString(),
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/calendar.png',
                            width: 20,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'Uploaded on: ',
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.uploadedContent.uploadDate!,
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xFF222744),
                ),
                const SizedBox(
                  height: 3,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Attachment: ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              viewFile(
                                  widget.uploadedContent.uploadFile!,
                                  context,
                                  widget.uploadedContent.uploadFile!
                                      .split('/')
                                      .last);
                            },
                            child: Container(
                              height: 50,
                              width: 80,
                              // width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF222744),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              downloadFile(
                                  widget.uploadedContent.uploadFile!,
                                  context,
                                  widget.uploadedContent.uploadFile!
                                      .split('/')
                                      .last);
                            },
                            child: Container(
                              height: 50,
                              width: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFF222744),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Download',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(
      String url, BuildContext context, String? title) async {
    print('URL: $url');
    Dio dio = Dio();

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;
    Utils.showToast('Downloading in progress....');
    try {
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
          Utils.showToast('Files has been downloaded to $dirloc');

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
          } else if (url == null) {
            Utils.showToast('No file found');
          } else {
            Utils.showToast('File type not supported by this app.');
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> viewFile(String url, BuildContext context, String? title) async {
    print('URL: $url');
    Dio dio = Dio();

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;
    Utils.showToast('Just a second...');
    try {
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
}
