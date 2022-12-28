import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/teacher/homework/edit_homework.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/view_download_bottomsheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/FunctionsData.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';

// ignore: must_be_immutable
class HomeworkDetailsScreen extends StatefulWidget {
  HomeworkDetailsScreen(this.homework, this._token);
  Homework homework;
  final _token;

  @override
  State<HomeworkDetailsScreen> createState() => _HomeworkDetailsScreenState();
}

class _HomeworkDetailsScreenState extends State<HomeworkDetailsScreen> {
  var progress = 'Download';
  String? _token;

  var received;
  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditHomeWork(
              homework: widget.homework,
            ),
          ),
        );
        break;
      case 'Delete':
        showDeleteAlertDialog(context);
        break;
    }
  }

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

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
    _token = _userDetailsController.token;
  }

  @override
  Widget build(BuildContext context) {
    var url = InfixApi().root + (widget.homework.fileUrl ?? '');
    var fileName = url.split('/').last;
    return Scaffold(
      backgroundColor: HexColor('#f5f7fb'),
      appBar: AppBar(
          title: Text(
            'Homework Details',
            style: TextStyle(
              fontFamily:
                  GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: HexColor('#f5f7fb'),
          actions: [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: Container(
            padding: EdgeInsets.all(12.sp),
            width: 95.w,
            decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: HexColor('#1E3377'),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.homework.subjectName!,
                          style: TextStyle(
                              fontFamily:
                                  GoogleFonts.inter(fontWeight: FontWeight.w600)
                                      .fontFamily,
                              fontSize: 18.sp,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: HexColor('#35b3ff'),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Text(
                            widget.homework.className!,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                space,
                Text(
                  'Description: ',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: HexColor('#3b405a'),
                      fontWeight: FontWeight.w700),
                ),
                space,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.homework.description!,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 30,
                        style: TextStyle(
                            color: HexColor('#4f536a'),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                space,
                Text(
                  'Attachments: ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                        .fontFamily,
                    fontSize: 14.sp,
                  ),
                ),
                space,
                Visibility(
                  visible: widget.homework.fileUrl != null &&
                      widget.homework.fileUrl!.isNotEmpty,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 70.w,
                            decoration: BoxDecoration(
                                color: HexColor('#E1E4ED'),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: HexColor('#BEC4D4'),
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SvgPicture.asset(
                                        'assets/svg/Attachment Icon.svg',
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: HexColor('#3b405a'),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          showDownloadAlertDialog(
                              context, widget.homework.subjectName);
                        },
                        child: Column(
                          children: [
                            Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: HexColor('#1e3377'),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    size: 25,
                                  ),
                                )),
                            Text(
                              'View',
                              style: TextStyle(
                                fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500)
                                    .fontFamily,
                                fontSize: 10.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                space,
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
                            Container(
                              decoration: BoxDecoration(
                                  color: HexColor('#ef3d3d'),
                                  borderRadius: BorderRadius.circular(7)),
                              child: const Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  'Due Date: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  final space = const SizedBox(
    height: 10,
  );

  showViewAlertDialog(BuildContext context, title) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context2) {
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
                      title: title,
                      filePath:
                           InfixApi().root + widget.homework.fileUrl!,
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
                         InfixApi().root + widget.homework.fileUrl!,
                        context),
                  ),
                );
              } else {
                Utils.showToast('File type not supported');
              }
            });
      },
    );
  }

  showDownloadAlertDialog(BuildContext context, title) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Utils.showProcessingToast();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (widget.homework.fileUrl!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadViewer(
                title: title,
                filePath:  InfixApi().root + widget.homework.fileUrl!,
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
          Utils.showToast('File type not supported');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        widget.homework.fileUrl != null
            ? downloadFile(widget.homework.fileUrl!, context, title)
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
    print('URL: $url');
    Dio dio = Dio();

    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    //   //add more permission to request here.
    // ].request();
    String dirloc = '';
    // dirloc = (await getExternalStorageDirectory())!.path ??
    //     "Downloads path doesn't exist";
    //user download directory
    if (Platform.isAndroid) {
      dirloc = (await getExternalStorageDirectory())!.path;
    } else if (Platform.isIOS) {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    print(dirloc);
    Utils.showToast('Downloading in progress....');
    try {
      String downloadName = widget.homework.subjectName!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
      FileUtils.mkdir([fullPath]);
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
          Utils.showToast('Files has been downloaded to $fileSaved');

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
            Utils.showToast('No file exists');
            // var file = await DefaultCacheManager()
            //     .getSingleFile(InfixApi().root + url);
            // // OpenFile.open(file.path);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Utils.fullScreenImageView(file.path),
            //   ),
            // );
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  showDeleteAlertDialog(BuildContext context) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            setState(() {
              deleteContent(widget.homework.id);
            });
          },
          title: 'Delete Homework',
        );
      },
    );
  }

  Future<void> deleteContent(int? id) async {
    final response = await http.get(Uri.parse(InfixApi.deletHomework(id)),
        headers: Utils.setHeader(widget._token!));
    if (response.statusCode == 200) {
      Utils.showToast('Homework deleted successfully');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      throw Exception('failed to load');
    }
  }
}
