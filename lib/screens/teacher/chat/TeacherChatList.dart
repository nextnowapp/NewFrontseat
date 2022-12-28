import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/screens/teacher/chat/TeacherChatDetails.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/ChatListModel.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';

class TeacherChatListScreen extends StatefulWidget {
  const TeacherChatListScreen({Key? key}) : super(key: key);

  @override
  State<TeacherChatListScreen> createState() => _TeacherChatListScreenState();
}

class _TeacherChatListScreenState extends State<TeacherChatListScreen> {
  Future<ChatListModel?>? chats;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    chats = getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#e8e8e8'),
      appBar: CustomAppBarWidget(
        title: 'Chat List',
      ),
      body: FutureBuilder<ChatListModel?>(
          future: chats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoader());
            } else {
              if (snapshot.data == null) {
                return Center(
                    child: TextWidget(
                  txt: 'No Data found',
                  size: 12.sp,
                  weight: FontWeight.bold,
                ));
              } else {
                return ListView.builder(
                  itemCount:
                      snapshot.data != null ? snapshot.data!.data!.length : 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeacherChatDetailScreen(
                                  data: snapshot.data!.data![index],
                                ),
                              ));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.sp),
                                child: TextWidget(
                                  txt: snapshot.data!.data![index].chatMessage
                                          .toString()
                                          .capitalizeFirst ??
                                      '',
                                  size: 12.sp,
                                ),
                              ),
                              Visibility(
                                visible:
                                    snapshot.data!.data![index].chatImage !=
                                            "",
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.sp),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HexColor('#e7edf5'),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.attach_file_outlined,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                      txt: snapshot
                                              .data!.data![index].chatImage!
                                              .contains('.pdf')
                                          ? 'Pdf'
                                          : 'Image',
                                      size: 8.sp,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 3.6.h,
                                decoration: BoxDecoration(
                                    color: HexColor('#f2f4f7'),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextWidget(
                                      txt: snapshot.data!.data![index]
                                                  .informTo ==
                                              '3'
                                          ? 'All Parents of your Class'
                                          : snapshot.data!.data![index]
                                                      .informTo ==
                                                  '3'
                                              ? 'All Staffs of your Class'
                                              : 'All Management of your Class',
                                      size: 7.sp,
                                      clr: HexColor('#777c8e'),
                                      weight: FontWeight.w500,
                                    ),
                                    const VerticalDivider(
                                      thickness: 2,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 12.sp,
                                          color: HexColor('#5f6378'),
                                        ),
                                        const SizedBox(width: 3),
                                        TextWidget(
                                          txt: snapshot.data!.data![index]
                                                  .chatDate ??
                                              '',
                                          size: 7.sp,
                                          clr: HexColor('#777c8e'),
                                          weight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      thickness: 2,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 12.sp,
                                          color: HexColor('#5f6378'),
                                        ),
                                        const SizedBox(width: 3),
                                        TextWidget(
                                          txt: snapshot
                                                  .data!.data![index].time ??
                                              '',
                                          size: 7.sp,
                                          clr: HexColor('#777c8e'),
                                          weight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
          }),
    );
  }

  Future<ChatListModel?>? getChats() async {
    final response = await http.get(Uri.parse(InfixApi.teacherChatlist),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ChatListModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
