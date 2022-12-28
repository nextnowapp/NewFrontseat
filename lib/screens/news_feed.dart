import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:sizer/sizer.dart';

import '../config/app_config.dart';
import '../controller/user_controller.dart';
import '../utils/Utils.dart';
import '../utils/apis/Apis.dart';
import '../utils/model/FeedCategoryModel.dart';
import '../utils/model/SocialFeedModel.dart';
import '../utils/widget/textwidget.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key, required this.admin}) : super(key: key);
  final bool admin;

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  Future<SocialFeedCategoryModel?>? categories;
  Future<SocialFeedModel?>? feeds;
  String selectedCategory = 'All';
  int categoryId = 0;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    categories = getSocialFeedCategory();
    feeds = getSocialFeed(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Social Feed',
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.sp, bottom: 8.sp),
              child: Text(
                'Select Category',
                style: TextStyle(
                  color: HexColor('#a3aab1'),
                  fontSize: 10.sp,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
            ),
            FutureBuilder<SocialFeedCategoryModel?>(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.data!.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.data![index];
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory =
                                          data.feedsCategoryName!;
                                      categoryId = data.id!;
                                      feeds = getSocialFeed(categoryId);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Container(
                                      width: 30.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            categoryId == data.id
                                                ? BoxShadow(
                                                    color: HexColor('#e7e7e7'),
                                                    spreadRadius: 1,
                                                    offset: const Offset(1, 2))
                                                : const BoxShadow()
                                          ],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                InfixApi().root +
                                                    data.feedsCategoryImage!,
                                              ),
                                              fit: BoxFit.fill),
                                          color: HexColor('#f5dac5'),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            Expanded(
              flex: 5,
              child: FutureBuilder<SocialFeedModel?>(
                  future: feeds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CustomLoader());
                    }
                    if (snapshot.data == null) {
                      return Center(
                        child: TextWidget(
                          txt: 'No Data Found!',
                          size: 14.sp,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.allfeeds!.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.data!.allfeeds![index];
                            return Container(
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: HexColor('#f5f5f5')),
                              child: Padding(
                                padding: EdgeInsets.all(10.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: index == 0,
                                      child: Text(
                                        'Top Stories',
                                        style: TextStyle(
                                          color: HexColor('#a3aab1'),
                                          fontSize: 12.sp,
                                          fontFamily: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                          ).fontFamily,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible:
                                                data.feedsType == 'With Image',
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    child: CachedNetworkImage(
                                                      imageUrl: data
                                                                  .staffPhoto ==
                                                              null
                                                          ? 'https://i.stack.imgur.com/34AD2.jpg'
                                                          : InfixApi().root +
                                                              data.staffPhoto!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: HexColor(
                                                                    '#ffe9a7'),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                      ),
                                                      fit: BoxFit.fill,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CachedNetworkImage(
                                                        imageUrl: AppConfig
                                                            .defaultNewsImageUrl,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            // borderRadius:
                                                            //     const BorderRadius.all(Radius.circular(50)),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const CupertinoActivityIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        data.fullName!
                                                                .capitalize ??
                                                            '',
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              '#151f3e'),
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ).fontFamily,
                                                        ),
                                                      ),
                                                      Text(
                                                        data.daysAgo == 0 ||
                                                                data.daysAgo ==
                                                                    null
                                                            ? 'Today'
                                                            : data.daysAgo == 1
                                                                ? '${data.daysAgo} day ago'
                                                                : '${data.daysAgo} days ago',
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              '#b2b9c0'),
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ).fontFamily,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height:
                                                data.feedsType == 'With Image'
                                                    ? 45.h
                                                    : 20.h,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: InfixApi().root +
                                                  data.feedsImage!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: data
                                                              .feedsType ==
                                                          'With Image'
                                                      ? null
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                              ),
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  const CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CachedNetworkImage(
                                                imageUrl: AppConfig
                                                    .defaultNoticeImageUrl,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    // borderRadius:
                                                    //     const BorderRadius.all(Radius.circular(50)),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CupertinoActivityIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Visibility(
                                            visible:
                                                data.feedsType != 'With Image',
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                data.feedsHeadline ?? '',
                                                style: TextStyle(
                                                  color: HexColor('#151f3e'),
                                                  fontSize: 14.sp,
                                                  fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                  ).fontFamily,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                data.feedsType != 'With Image',
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            HexColor('#ffe9a7'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: data
                                                                  .staffPhoto ==
                                                              null
                                                          ? 'https://i.stack.imgur.com/34AD2.jpg'
                                                          : InfixApi().root +
                                                              data.staffPhoto!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: HexColor(
                                                                    '#ffe9a7'),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                      ),
                                                      fit: BoxFit.fill,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CachedNetworkImage(
                                                        imageUrl: AppConfig
                                                            .defaultNewsImageUrl,
                                                        fit: BoxFit.fill,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const CupertinoActivityIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data.fullName ?? '',
                                                    style: TextStyle(
                                                      color:
                                                          HexColor('#151f3e'),
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                          GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ).fontFamily,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 4.h,
                                                    color: HexColor('#4f576e'),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    data.daysAgo == 0 ||
                                                            data.daysAgo == null
                                                        ? 'Today'
                                                        : data.daysAgo == 1
                                                            ? '${data.daysAgo} day ago'
                                                            : '${data.daysAgo} days ago',
                                                    style: TextStyle(
                                                      color:
                                                          HexColor('#b2b9c0'),
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                          GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ).fontFamily,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              data.feedsDetails ?? '',
                                              style: TextStyle(
                                                color: HexColor('#b2b9c0'),
                                                fontSize: 8.sp,
                                                fontFamily: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                ).fontFamily,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (data.liked == true) {
                                                      setState(() {
                                                        data.liked = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        data.liked = true;
                                                      });
                                                    }
                                                    likeFeed(data.id);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color:
                                                            data.liked == true
                                                                ? HexColor(
                                                                    '#e2e6eb')
                                                                : HexColor(
                                                                    '#3bb38e')),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.thumb_up_alt,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            data.liked == true
                                                                ? 'Liked'
                                                                : 'Like ',
                                                            style: TextStyle(
                                                              color: data.liked ==
                                                                      true
                                                                  ? HexColor(
                                                                      '#3bb38e')
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 8.sp,
                                                              fontFamily:
                                                                  GoogleFonts
                                                                      .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ).fontFamily,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                // Container(
                                                //   decoration: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               5),
                                                //       color:
                                                //           HexColor('#e2e6eb')),
                                                //   child: Padding(
                                                //     padding:
                                                //         const EdgeInsets.all(5),
                                                //     child: Row(
                                                //       children: [
                                                //         const SizedBox(
                                                //           width: 5,
                                                //         ),
                                                //         Icon(
                                                //           Icons.visibility,
                                                //           size: 15,
                                                //           color: HexColor(
                                                //               '#a1afc1'),
                                                //         ),
                                                //         const SizedBox(
                                                //           width: 5,
                                                //         ),
                                                //         Text(
                                                //           data.viewCount
                                                //               .toString(),
                                                //           style: TextStyle(
                                                //             color: HexColor(
                                                //                 '#a1afc1'),
                                                //             fontSize: 8.sp,
                                                //             fontFamily:
                                                //                 GoogleFonts
                                                //                     .inter(
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .w500,
                                                //             ).fontFamily,
                                                //           ),
                                                //         ),
                                                //         const SizedBox(
                                                //           width: 5,
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Colors.grey,
                                                        size: 10.sp,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      TextWidget(
                                                        txt: data.feedsDate ==
                                                                null
                                                            ? ''
                                                            : data.feedsDate! +
                                                                ' | ' +
                                                                data.time!,
                                                        fam: GoogleFonts.inter()
                                                            .fontFamily,
                                                        weight: FontWeight.w600,
                                                        size: 7.sp,
                                                        clr: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<SocialFeedModel?> getSocialFeed(int? id) async {
    var data = {'category_id': id, 'user_id': _userDetailsController.id};
    final response = await http.post(Uri.parse(InfixApi.getSocialFeed()),
        body: jsonEncode(data),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());
      var jsonData = jsonDecode(response.body);
      return SocialFeedModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  likeFeed(int? id) async {
    var date = DateTime.now();
    var data = {
      'feeds_id': id,
      'viewer_id': _userDetailsController.id,
      'liked_date': parseDate(date)
    };
    final response = await http.post(Uri.parse(InfixApi.likeSocialFeed()),
        body: jsonEncode(data),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('Liked');
    } else {
      throw Exception('Failed to load');
    }
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  Future<SocialFeedCategoryModel?> getSocialFeedCategory() async {
    final response = await http.get(Uri.parse(InfixApi.getSocialFeedCategory()),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = SocialFeedCategoryModel.fromJson(jsonData);
      if (data.data != null) {
        setState(() {
          categoryId = data.data![0].id!;
        });
      }
      return data;
    } else {
      throw Exception('Failed to load');
    }
  }
}
