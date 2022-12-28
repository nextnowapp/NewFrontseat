import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/sponsor_our_school.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/user_controller.dart';
import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../../utils/widget/customLoader.dart';
import '../../utils/widget/textwidget.dart';

class SponsorOurSchool extends StatefulWidget {
  const SponsorOurSchool({Key? key}) : super(key: key);

  @override
  State<SponsorOurSchool> createState() => _SponsorOurSchoolState();
}

class _SponsorOurSchoolState extends State<SponsorOurSchool> {
  Future<SponsorOurSchoolModel?>? messages;
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
        title: 'Sponsor Our School',
      ),
      body: FutureBuilder<SponsorOurSchoolModel?>(
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
                    return Padding(
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
                                padding:
                                    const EdgeInsets.only(left: 5, top: 10),
                                child: TextWidget(
                                  txt: 'From',
                                  size: 8.sp,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 5, bottom: 5),
                                child: TextWidget(
                                  txt: snapshot.data!.data![index].name!,
                                  size: 12.sp,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: HexColor('#f8f8f8'),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextWidget(
                                    txt: snapshot.data!.data![index].message!,
                                    fam: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                    ).fontFamily,
                                    clr: Colors.black87,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        launchUrl(Uri.parse('mailto:' +
                                            snapshot
                                                .data!.data![index].email!));
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/E-mail.svg'),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data!.data![index].email!,
                                            style: TextStyle(
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
                                                color: HexColor('#86adff'),
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                          'tel:' +
                                              snapshot
                                                  .data!.data![index].mobile!,
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
                                            txt: snapshot
                                                .data!.data![index].mobile!,
                                            fam: GoogleFonts.inter().fontFamily,
                                            clr: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/School Address.svg'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data!.data![index].location!,
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            color: HexColor('#86adff'),
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
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
                                    txt: snapshot.data!.data![index].date! +
                                        ' | ' +
                                        snapshot.data!.data![index].time!,
                                    fam: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                    ).fontFamily,
                                    size: 8.sp,
                                    clr: Colors.grey,
                                  ),
                                ],
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

  Future<SponsorOurSchoolModel?>? getWebsiteMessages() async {
    final response = await http.get(Uri.parse(InfixApi.sponsorOurSchool()),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    print(response.body);
    if (response.statusCode == 200) {
      log(response.body);
      var jsonData = jsonDecode(response.body);
      return SponsorOurSchoolModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
