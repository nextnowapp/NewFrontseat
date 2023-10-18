// Dart imports:
import 'dart:io';
import 'dart:math';

// Package imports:
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
// Project imports:
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Content.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ContentRow extends StatefulWidget {
  Content content;
  Animation animation;
  final VoidCallback? onPressed;
  String? token;
  int? index;

  ContentRow(this.content, this.animation,
      {this.onPressed, this.token, this.index});

  @override
  _ContentRowState createState() => _ContentRowState(token);
}

class _ContentRowState extends State<ContentRow> {
  var progress = 'Download';
  var received;
  var _token;

  _ContentRowState(this._token);

  Random random = Random();

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
    return SizeTransition(
      sizeFactor: widget.animation as Animation<double>,
      child: Container(
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
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
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 20.0, right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.content.title!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          widget.content.description == null
                                              ? ''
                                              : widget.content.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize:
                                                      ScreenUtil().setSp(12)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.content.title == null
                            ? 'NA'
                            : widget.content.title!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: ScreenUtil().setSp(12)),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          showDownloadAlertDialog(
                              context, widget.content.title);
                        },
                        child: Icon(
                          FontAwesomeIcons.download,
                          size: ScreenUtil().setSp(15),
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          showDeleteAlertDialog(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.trash,
                          size: ScreenUtil().setSp(15),
                          color: Colors.redAccent,
                        ),
                      ),
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
                              'Type',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.content.type == null
                                  ? 'not assigned'
                                  : widget.content.type!,
                              // : AppFunction.getContentType(content.type),
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.content.uploadDate == null
                                  ? 'N/A'
                                  : widget.content.uploadDate!,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Available for',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.content.availableFor == null
                                  ? 'N/A'
                                  : widget.content.availableFor!
                                      .replaceAll('classes', 'grades'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.purple, Colors.deepPurple]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('No'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Delete'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          deleteContent(widget.content.id);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Delete',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: const Text('Would you like to delete the file?'),
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

  showDownloadAlertDialog(BuildContext context, title) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (widget.content.uploadFile!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfView(
                path: InfixApi().root + widget.content.uploadFile!,
              ),
            ),
          );
        } else if (widget.content.uploadFile!.contains('.jpg') ||
            widget.content.uploadFile!.contains('.png') ||
            widget.content.uploadFile!.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Utils.fullScreenImageView(
                InfixApi().root + widget.content.uploadFile!,
              ),
            ),
          );
        } else {
          Utils.showToast('File type not supported');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        widget.content.uploadFile != null && widget.content.uploadFile != ''
            ? downloadFile(widget.content.uploadFile!, context, title)
            : Utils.showToast('no file found');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Download',
        style: Theme.of(context).textTheme.headlineSmall,
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

  Future<void> deleteContent(int? cid) async {
    final response = await http.get(Uri.parse(InfixApi.deleteContent(cid)),
        headers: Utils.setHeader(_token));

    if (response.statusCode == 200) {
      widget.onPressed!();
      Utils.showToast('Content deleted');
    } else {
      throw Exception('failed to load');
    }
  }

  Future<void> downloadFile(
      String url, BuildContext context, String? title) async {
    print('URL: $url');
    Dio dio = Dio();

    String dirloc = '';
    if (Platform.isAndroid) {
      dirloc = (await getExternalStorageDirectory())!.path;
    } else if (Platform.isIOS) {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }
    print(dirloc);

    try {
      String downloadName = widget.content.title!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
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
          Navigator.of(context, rootNavigator: true).pop('dialog');

          if (url.contains('.pdf')) {
            Utils.showToast(
                'Download Completed. File is also available in Nextschool folder.');
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
    }
  }
}
