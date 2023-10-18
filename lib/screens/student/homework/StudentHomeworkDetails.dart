import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';
import 'package:nextschool/utils/widget/view_download_bottomsheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/FunctionsData.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';

// ignore: must_be_immutable
class StudentHomeworkDetailsScreen extends StatefulWidget {
  StudentHomeworkDetailsScreen(this.homework, this.type);
  Homework homework;
  String type;

  @override
  State<StudentHomeworkDetailsScreen> createState() =>
      _StudentHomeworkDetailsScreenState();
}

class _StudentHomeworkDetailsScreenState
    extends State<StudentHomeworkDetailsScreen> {
  var progress = 'Download';
  String? _token;

  GlobalKey _globalKey = GlobalKey();

  var received;
  // void handleClick(String value) {
  //   switch (value) {
  //     case 'Edit':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               EditHomeWork(
  //                 homework:
  //                 widget.homework,
  //               ),
  //         ),
  //       );
  //       break;
  //     case 'Delete':
  //       showDeleteAlertDialog(context);
  //       break;
  //   }
  // }

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
      key: _globalKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Detail Homework',
          style: TextStyle(
            fontFamily:
                GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0XFFfeeecc),
        // actions: [
        //   // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        //   PopupMenuButton<String>(
        //     onSelected: handleClick,
        //     itemBuilder: (BuildContext context) {
        //       return {'Edit', 'Delete'}.map((String choice) {
        //         return PopupMenuItem<String>(
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     },
        //   ),
        // ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: Container(
            padding: EdgeInsets.all(12.sp),
            width: 95.w,
            // height: 65.h,
            decoration: BoxDecoration(
                color: HexColor('#f1f5f9'),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: [
                Text(
                  widget.homework.subjectName!,
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                        .fontFamily,
                    fontSize: 22.sp,
                  ),
                ),
                space,
                Text(
                  widget.homework.className!,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: HexColor('#3b405a'),
                      fontWeight: FontWeight.w700),
                ),
                space,
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/calendar-2852107 (2).svg',
                            width: 14,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Row(
                            children: [
                              Text(
                                'Assigned Date: ',
                                style: TextStyle(
                                    color: HexColor('#3b405a'),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                widget.homework.homeworkDate!,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: HexColor('#3b405a'),
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/calendar-2852107 (2).svg',
                            width: 14,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Row(
                            children: [
                              Text(
                                'Due Date: ',
                                style: TextStyle(
                                    color: HexColor('#3b405a'),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                widget.homework.submissionDate!,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: HexColor('#3b405a'),
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Description : ',
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
                space,
                Text(
                  'Attachments : ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                        .fontFamily,
                    fontSize: 15.sp,
                  ),
                ),
                space,
                Visibility(
                  visible: widget.homework.fileUrl != null &&
                      widget.homework.fileUrl!.isNotEmpty,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/images/pdf.png',
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                          fileName,
                          style: TextStyle(
                            fontFamily:
                                GoogleFonts.inter(fontWeight: FontWeight.w500)
                                    .fontFamily,
                            fontSize: 12.sp,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            showDownloadAlertDialog(
                                context, widget.homework.subjectName);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: Image.asset(
                                  'assets/images/Download1.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500)
                                        .fontFamily,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final space = const SizedBox(
    height: 20,
  );

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
                      title: title,
                      filePath: InfixApi().root + widget.homework.fileUrl!,
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
                filePath: InfixApi().root + widget.homework.fileUrl!,
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
}
