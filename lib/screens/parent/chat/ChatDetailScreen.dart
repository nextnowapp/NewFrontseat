import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/model/ChatListModel.dart';
import '../../student/studyMaterials/StudyMaterialViewer.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key, required this.data}) : super(key: key);
  final Chat data;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: widget.data.teacherName,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 8.h,
          decoration: BoxDecoration(color: HexColor('#f3f3f3')),
          child: const Center(
            child: TextWidget(
              txt: "You can't reply to this conversation",
              weight: FontWeight.w500,
              clr: Colors.grey,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe3Rkyxw4nW2d8YWY6bSL7Fek8LwCdELZZXvPXx6bdMw&s',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          color: HexColor('#e6eaef'),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 12.sp,
                            right: 12.sp,
                            left: 12.sp,
                            bottom: 6.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              txt: widget.data.chatMessage ?? '',
                              size: 10.sp,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 10.sp,
                                  color: Colors.grey,
                                ),
                                TextWidget(
                                  txt: widget.data.chatDate ?? '',
                                  size: 7.sp,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Container(
                                    height: 15,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Icon(
                                  Icons.watch_later_rounded,
                                  size: 10.sp,
                                  color: Colors.grey,
                                ),
                                TextWidget(
                                  txt: widget.data.time ?? '',
                                  size: 7.sp,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.data.chatImage != '' &&
                      widget.data.chatImage!.contains('.jpg') ||
                  widget.data.chatImage!.contains('.png') ||
                  widget.data.chatImage!.contains('.jpeg'),
              child: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe3Rkyxw4nW2d8YWY6bSL7Fek8LwCdELZZXvPXx6bdMw&s',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color: HexColor('#e6eaef'),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12.sp,
                              right: 12.sp,
                              left: 12.sp,
                              bottom: 6.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  viewImage();
                                },
                                child: Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            InfixApi().root +
                                                widget.data.chatImage!,
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 10.sp,
                                    color: Colors.grey,
                                  ),
                                  TextWidget(
                                    txt: widget.data.chatDate ?? '',
                                    size: 7.sp,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Container(
                                      height: 15,
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Icon(
                                    Icons.watch_later_rounded,
                                    size: 10.sp,
                                    color: Colors.grey,
                                  ),
                                  TextWidget(
                                    txt: widget.data.time ?? '',
                                    size: 7.sp,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
            filePath:  InfixApi().root + widget.data.chatImage!,
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
