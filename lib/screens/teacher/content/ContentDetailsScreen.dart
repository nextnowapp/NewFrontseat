import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/FunctionsData.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/model/Content.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';

class ContentDetailsScreen extends StatefulWidget {
  ContentDetailsScreen({Key? key, required this.content}) : super(key: key);
  Content content;

  @override
  State<ContentDetailsScreen> createState() => _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends State<ContentDetailsScreen> {
  late List<DownloadController> _downloadControllers;
  var progress = 'Download';
  String? _token;

  var received;
  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        print('edit');
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            widget.content.type!,
            style: TextStyle(
              fontFamily:
                  GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0XFFfeeecc),
          actions: [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  // 'Edit',
                  'Delete'
                }.map((String choice) {
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: 95.w,
          height: 90.h,
          decoration: BoxDecoration(
              color: HexColor('#f1f5f9'),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.content.title!.capitalizeFirst!,
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                  fontSize: 22.sp,
                ),
              ),
              space,
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.content.uploadDate!,
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
              space,
              Row(
                children: [
                  Text(
                    'Created by : ',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                          .fontFamily,
                      fontSize: 15.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.content.createdBy!,
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.inter(fontWeight: FontWeight.w500)
                                .fontFamily,
                        fontSize: 13.sp,
                      ),
                    ),
                  )
                ],
              ),
              space,
              Text(
                'Tasks assigned to : ',
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                  fontSize: 15.sp,
                ),
              ),
              space,
              (widget.content.availableFor == null)
                  ? const SizedBox()
                  : Text(
                      (widget.content.availableFor!).titleCase,
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.inter(fontWeight: FontWeight.w500)
                                .fontFamily,
                        fontSize: 13.sp,
                      ),
                    ),
              space,
              Row(
                children: [
                  Text(
                    'Due Date : ',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                          .fontFamily,
                      fontSize: 15.sp,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    widget.content.uploadDate!,
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500)
                          .fontFamily,
                      fontSize: 13.sp,
                    ),
                  )
                ],
              ),
              space,
              Text(
                'Description : ',
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                  fontSize: 15.sp,
                ),
              ),
              space,
              Text(
                widget.content.description!,
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
                  fontSize: 13.sp,
                ),
              ),
              space,
              Text(
                'Attachments : ',
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                  fontSize: 15.sp,
                ),
              ),
              space,
              Visibility(
                visible: widget.content.uploadFile != null,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Image.asset('assets/images/pdf.png'),
                      title: Text(
                        widget.content.title!,
                        style: TextStyle(
                          fontFamily:
                              GoogleFonts.inter(fontWeight: FontWeight.w500)
                                  .fontFamily,
                          fontSize: 15.sp,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          showDownloadAlertDialog(
                              context, widget.content.title);
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
                                'Download',
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
    );
  }

  final space = const SizedBox(
    height: 20,
  );

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
              builder: (context) =>
                  // PdfView(
                  //   path: widget.content.uploadFile!,
                  // ),
                  DownloadViewer(
                title: title!,
                filePath: InfixApi().root + widget.content.uploadFile!,
              ),
            ),
          );
        } else if (widget.content.uploadFile!.contains('.jpg') ||
            widget.content.uploadFile!.contains('.png') ||
            widget.content.uploadFile!.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Utils.documentViewer(
                  InfixApi().root + widget.content.uploadFile!, context),
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
      String downloadName = widget.content.title!;
      String fullPath = '$dirloc/$downloadName.pdf';
      String fileSaved = '$dirloc/$downloadName.pdf/';
      //
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
    return custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
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
              deleteContent(widget.content.id);
            },
            title: 'Delete ' + widget.content.type!);
      },
    );
  }

  Future<void> deleteContent(int? cid) async {
    final response = await http.get(Uri.parse(InfixApi.deleteContent(cid)),
        headers: Utils.setHeader(_token!));

    if (response.statusCode == 200) {
      Utils.showToast('Content deleted');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      throw Exception('failed to load');
    }
  }

  // Future<void> downloadFile(
  //     String url, BuildContext context, String title) async {
  //   Dio dio = Dio();

  //   String dirloc = '';
  //   if (Platform.isAndroid) {
  //     dirloc = '/sdcard/Download/';
  //   } else {
  //     dirloc = (await getApplicationDocumentsDirectory()).path;
  //   }
  //   // Utils.showToast(dirloc);

  //   try {
  //

  //     Utils.showToast('Downloading file Please wait...');

  //     await dio.download(
  //         InfixApi().root + url, dirloc + AppFunction.getExtention(url),
  //         options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
  //         onReceiveProgress: (receivedBytes, totalBytes) async {
  //       received = ((receivedBytes / totalBytes) * 100);
  //       progress =
  //           ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
  //       int value = (((receivedBytes / totalBytes) * 100).toInt());

  //       if (received == 100.0) {
  //         Utils.showToast('Files has been downloaded to $dirloc');
  //         Navigator.of(context).pop();

  //         if (url.contains('.pdf')) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PdfView(
  //                 path: InfixApi().root + url,
  //               ),
  //             ),
  //           );
  //         } else {
  //           var file = await DefaultCacheManager()
  //               .getSingleFile(InfixApi().root + url);
  //           OpenFile.open(file.path);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //     Utils.showErrorToast('Download Failed. But file is ready to open');
  //     Navigator.of(context).pop();

  //     if (url.contains('.pdf')) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PdfView(
  //             path: InfixApi().root + url,
  //           ),
  //         ),
  //       );
  //     } else {
  //       var file =
  //           await DefaultCacheManager().getSingleFile(InfixApi().root + url);
  //     }
  //     // Navigator.of(context, rootNavigator: true).pop('dialog');
  //   }
  //   // progress = "Download Completed.Go to the download folder to find the file";
  // }
}
