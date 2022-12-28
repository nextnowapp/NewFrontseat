import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/website_message/website_message.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/user_controller.dart';
import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../../utils/widget/customLoader.dart';
import '../../utils/widget/textwidget.dart';

class WebsiteMessagesScreen extends StatefulWidget {
  const WebsiteMessagesScreen({Key? key}) : super(key: key);

  @override
  State<WebsiteMessagesScreen> createState() => _WebsiteMessagesScreenState();
}

class _WebsiteMessagesScreenState extends State<WebsiteMessagesScreen> {
  Future<WebsiteMessagesModel?>? messages;
  String? image;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  @override
  void initState() {
    messages = getWebsiteMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#e8e8e8'),
      appBar: CustomAppBarWidget(
        title: 'Website Messages',
      ),
      body: FutureBuilder<WebsiteMessagesModel?>(
          future: messages,
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
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    var messageList = snapshot.data!.data!;
                    var data = snapshot.data!.data![index];
                    var firstData = messageList
                        .firstWhere((element) => element.date == data.date);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          data.id == firstData.id
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.blueAccent),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: TextWidget(
                                            txt: data.date ==
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.now())
                                                ? 'Today'
                                                : data.date ==
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(DateTime
                                                                    .now()
                                                                .subtract(
                                                                    const Duration(
                                                                        days:
                                                                            1)))
                                                    ? 'Yesterday'
                                                    : data.date!,
                                            clr: Colors.white,
                                            size: 10.sp,
                                          ),
                                        ),
                                      )),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: TextWidget(
                                        txt: snapshot.data!.data![index].name!,
                                        size: 12.sp,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              launchUrl(Uri.parse('mailto:' +
                                                  snapshot.data!.data![index]
                                                      .email!));
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svg/E-mail.svg'),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  snapshot.data!.data![index]
                                                      .email!,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.inter()
                                                              .fontFamily,
                                                      color:
                                                          HexColor('#86adff'),
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                'tel:' +
                                                    snapshot.data!.data![index]
                                                        .mobile!,
                                              ));
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svg/Phone.svg'),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                TextWidget(
                                                  txt: snapshot.data!
                                                      .data![index].mobile!,
                                                  fam: GoogleFonts.inter()
                                                      .fontFamily,
                                                  clr: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: HexColor('#ebf2ff'),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextWidget(
                                          txt: snapshot
                                              .data!.data![index].message!,
                                          fam: GoogleFonts.inter().fontFamily,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 12.sp,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextWidget(
                                          txt: snapshot
                                                  .data!.data![index].date! +
                                              ' | ' +
                                              snapshot.data!.data![index].time!,
                                          fam: GoogleFonts.inter().fontFamily,
                                          size: 12,
                                          clr: Colors.grey,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          }),
    );
  }

  Future<WebsiteMessagesModel?>? getWebsiteMessages() async {
    final response = await http.get(Uri.parse(InfixApi.websiteMessages()),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    print(response.body);
    if (response.statusCode == 200) {
      log(response.body);
      var jsonData = jsonDecode(response.body);
      return WebsiteMessagesModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
