import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/screens/parent/chat/ChatDetailScreen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/Apis.dart';
import '../../../utils/model/ChatListModel.dart';
import '../../../utils/widget/customLoader.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
        title: 'Chat',
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
                        snapshot.hasData ? snapshot.data!.data!.length : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                       ChatDetailScreen(
                                        data:  snapshot.data!.data![index],
                                      ),
                                ));
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe3Rkyxw4nW2d8YWY6bSL7Fek8LwCdELZZXvPXx6bdMw&s',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.sp),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                TextWidget(
                                                  txt: snapshot
                                                          .data!
                                                          .data![index]
                                                          .teacherName ??
                                                      '',
                                                  size: 12.sp,
                                                  weight: FontWeight.w500,
                                                ),
                                                // SizedBox(
                                                //   width: 118.sp,
                                                // ),
                                                // Container(
                                                //   height: 2.h,
                                                //   width: 8.w,
                                                //   decoration: BoxDecoration(
                                                //       color:
                                                //           HexColor('#4fbe9e'),
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               10)),
                                                //   child: Center(
                                                //       child: Padding(
                                                //     padding:
                                                //         const EdgeInsets.all(2),
                                                //     child: TextWidget(
                                                //       txt: '12',
                                                //       size: 8.sp,
                                                //       clr: Colors.white,
                                                //     ),
                                                //   )),
                                                // )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextWidget(
                                              txt: snapshot.data!.data![index]
                                                          .chatMessage!.length >
                                                      20
                                                  ? snapshot.data!.data![index]
                                                          .chatMessage!
                                                          .substring(0, 20) +
                                                      '...'
                                                  : snapshot.data!.data![index]
                                                      .chatMessage!,
                                              size: 12.sp,
                                            )
                                          ],
                                        ),
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
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 30.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              size: 13.sp,
                                              color: HexColor('#5f6378'),
                                            ),
                                            const SizedBox(width: 3),
                                            TextWidget(
                                              txt: snapshot.data!.data![index]
                                                      .chatDate ??
                                                  '',
                                              size: 10.sp,
                                              clr: HexColor('#777c8e'),
                                              weight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              size: 13.sp,
                                              color: HexColor('#5f6378'),
                                            ),
                                            const SizedBox(width: 3),
                                            TextWidget(
                                              txt: snapshot.data!.data![index]
                                                      .time ??
                                                  '',
                                              size: 10.sp,
                                              clr: HexColor('#777c8e'),
                                              weight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }

  Future<ChatListModel?>? getChats() async {
    final response = await http.get(Uri.parse(InfixApi.parentChatlist),
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
