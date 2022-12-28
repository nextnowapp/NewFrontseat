// Flutter imports:
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
//
import 'package:nextschool/config/app_config.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import '../../../utils/CustomAppBarWidget.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';
import 'AdminNoticeModel.dart';

// ignore: must_be_immutable
class AdminNoticeDetails extends StatefulWidget {
  Datum noticeList;

  AdminNoticeDetails(this.noticeList);

  @override
  _AdminNoticeDetailsState createState() =>
      _AdminNoticeDetailsState(noticeList);
}

class _AdminNoticeDetailsState extends State<AdminNoticeDetails> {
  Datum noticeList;
  var progress = 'Download';
  var received;
  _AdminNoticeDetailsState(this.noticeList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Notice Details'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                noticeList.noticeTitle ?? '',
                maxLines: 3,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  // // Row(
                  // //   children: [
                  // //     Container(
                  // //       decoration: BoxDecoration(
                  // //           color: HexColor('#ddf2ff'),
                  // //           borderRadius: BorderRadius.circular(4)),
                  // //       child: const Icon(
                  // //         Icons.person,
                  // //         size: 25,
                  // //       ),
                  // //     ),
                  // //     TextWidget(
                  // //       txt: ' by ${noticeList.createdBy.toString()}',
                  // //       clr: Colors.grey,
                  // //       size: 14,
                  // //     )
                  // //   ],
                  // // ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: HexColor('#fcd883'),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Icon(
                          Icons.watch_later,
                          size: 23,
                        ),
                      ),
                      TextWidget(
                        txt: ' ${noticeList.publishOn.toString()}',
                        clr: Colors.grey,
                        size: 14,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(minHeight: 380.sp),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    color: HexColor('#ebf2ff')),
                child: Column(
                  children: [
                    Visibility(
                      visible: noticeList.noticeImage != '',
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          height: 22.h,
                          width: 200.w,
                          child: CachedNetworkImage(
                            imageUrl: InfixApi().root + noticeList.noticeImage!,
                            imageBuilder: (context, imageProvider) =>
                                GestureDetector(
                              onTap: (() {
                                print(noticeList.noticeImage);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Utils.documentViewer(
                                      '${InfixApi().root}${noticeList.noticeImage}',
                                      context);
                                }));
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                                GestureDetector(
                              onTap: () {
                                print(noticeList.noticeImage);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Utils.documentViewer(
                                      '${AppConfig.defaultNoticeImageUrl}',
                                      context);
                                }));
                              },
                              child: CachedNetworkImage(
                                imageUrl: AppConfig.defaultNoticeImageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    // borderRadius:
                                    //     const BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Html(
                      data: noticeList.noticeMessage ?? '',
                      style: {
                        '*': Style(
                          fontSize: FontSize(12.sp),
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          lineHeight: const LineHeight(1.5),
                        ),
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    color: HexColor('#ebf2ff')),
                child: Visibility(
                  visible: noticeList.noticeImage != '',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Attachment: ',
                          style: TextStyle(
                            fontFamily:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)
                                    .fontFamily,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70.w,
                                decoration: BoxDecoration(
                                    color: HexColor('#e1e4ed'),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: HexColor('#BEC4D4'),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10))),
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
                                            noticeList.noticeTitle ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: HexColor('#3b405a'),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              showDownloadAlertDialog(
                                  context, noticeList.noticeImage);
                            },
                            child: Column(
                              children: [
                                Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: HexColor('#3bb28d'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.download,
                                        size: 28,
                                      ),
                                    )),
                                Text(
                                  'Download',
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
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showDownloadAlertDialog(BuildContext context, title) {
    // set up the buttons
    log('${InfixApi().root}${noticeList.noticeImage}');
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (noticeList.noticeImage!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  // PdfView(
                  //   path: noticeList.noticeImage!,
                  // ),

                  DownloadViewer(
                title: title!,
                filePath: '${InfixApi().root}${noticeList.noticeImage}',
              ),
            ),
          );
        } else if (noticeList.noticeImage!.contains('.jpg') ||
            noticeList.noticeImage!.contains('.png') ||
            noticeList.noticeImage!.contains('.jpeg')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Utils.documentViewer(
                '${InfixApi().root}${noticeList.noticeImage}', context);
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Utils.documentViewer(
                '${InfixApi().root}${noticeList.noticeImage}', context);
          }));
          // Utils.showToast('File type not supported');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        noticeList.noticeImage != null && noticeList.noticeImage != ''
            ? downloadFile(noticeList.noticeImage!, context, title)
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
      String downloadName = noticeList.noticeTitle!;
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Utils.documentViewer(
                  '${InfixApi().root}${noticeList.noticeImage}', context);
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Utils.documentViewer(
                  '${InfixApi().root}${noticeList.noticeImage}', context);
            }));
            // Utils.showToast('No file exists');
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
}
