import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/ChatListModel.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../../../utils/widget/addn_deleteButton.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';

class TeacherChatDetailScreen extends StatefulWidget {
  const TeacherChatDetailScreen({Key? key, required this.data})
      : super(key: key);
  final Chat data;
  @override
  State<TeacherChatDetailScreen> createState() =>
      _TeacherChatDetailScreenState();
}

class _TeacherChatDetailScreenState extends State<TeacherChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Chat Details',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: HexColor('#7cd4ae'),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send to :',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            widget.data.informTo == '3'
                                ? 'All Parents of your Class'
                                : widget.data.informTo == '3'
                                    ? 'All Staffs of your Class'
                                    : 'All Management of your Class',
                            style: TextStyle(
                              color: HexColor('#222744'),
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                        ]))),
            SizedBox(
              height: 1.5.h,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: HexColor('#e7edf5'),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Message :',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            widget.data.chatMessage ?? '',
                            style: TextStyle(
                              color: HexColor('#222744'),
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ).fontFamily,
                            ),
                          ),
                        ]))),
            SizedBox(
              height: 1.5.h,
            ),
            Container(
              decoration: BoxDecoration(
                  color: HexColor('#e7edf5'),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attachment',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10.sp,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#e8e9ec'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.attach_file_rounded),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.data.chatImage == ''
                                        ? 'No attachment found'
                                        : widget.data.chatImage!
                                                .contains('.pdf')
                                            ? 'Pdf'
                                            : 'Image',
                                    // 'No attachment found',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () {
                                      viewImage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: HexColor('#4e88ff'),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'View',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 7.sp,
                                      fontFamily: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: AddnDeleteButton(
            borderColor: '#4e88ff',
            bgColor: '#4e88ff',
            textColor: '#ffffff',
            title: 'Go Back',
          ),
        ),
      ),
    );
  }

  viewImage() {
    if (widget.data.chatImage!.contains('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              // PdfView(
              //   path:  InfixApi().root + widget.data.chatImage!,
              // ),
              DownloadViewer(
            title: widget.data.chatImage!,
            filePath: InfixApi().root + widget.data.chatImage!,
          ),
        ),
      );
    } else if (widget.data.chatImage!.contains('.jpg') ||
        widget.data.chatImage!.contains('.png') ||
        widget.data.chatImage!.contains('.jpeg')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Utils.documentViewer(
              InfixApi().root + widget.data.chatImage!, context),
        ),
      );
    } else {
      Utils.showToast('File type not supported');
    }
  }
}
