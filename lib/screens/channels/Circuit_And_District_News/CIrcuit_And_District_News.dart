import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/channels/Circuit_And_District_News/CIrcuit_And_District_News_Details.dart';
import 'package:nextschool/screens/channels/Circuit_And_District_News/NewsModel.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/404ErrorWidget.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/apis/Apis.dart';
import '../../../config/app_config.dart';

class CircuitAndDistrictNewsListScreen extends StatefulWidget {
  const CircuitAndDistrictNewsListScreen({Key? key}) : super(key: key);

  @override
  _CircuitAndDistrictNewsListScreenState createState() =>
      _CircuitAndDistrictNewsListScreenState();
}

class _CircuitAndDistrictNewsListScreenState
    extends State<CircuitAndDistrictNewsListScreen> {
  Future<NewsModel?>? news;
  List<NewsList>? newsLIst = [];
  String? _token;
  var school_id;
  late Future<void> _launched;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    school_id = _userDetailsController.schoolId;

    news = getnews(school_id);
    news!.then((value) {
      setState(() {
        newsLIst = value!.data!.newsList!;
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    school_id = _userDetailsController.schoolId;
    news = getnews(school_id);
    news!.then((value) {
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          newsLIst = value!.data!.newsList!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Circuit & District News',
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<NewsModel?>(
                future: news,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.data!.newsList!.length == 0) {
                      return Center(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Wrap(
                                children: [
                                  Text(
                                      snapshot.data!.data!.emptyNewsMessage ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                      ))
                                ],
                              )));
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: newsLIst!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.data!.newsList![index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      CircuitAndDistrictNewsDetailsScreen(
                                          snapshot.data!.data!.newsList![index],
                                          data.id,
                                          snapshot.data!.data!.baseUrl! +
                                              '/' +
                                              data.image!),
                                ),
                              );
                            },
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                width: size.width,
                                height: 35.h,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      child: Container(
                                        height: 16.h,
                                        width: 90.w,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              // 'https://vhembewest.co.za' + data.image!,
                                              data.image != null
                                                  ? snapshot.data!.data!
                                                          .baseUrl! +
                                                      '/' +
                                                      data.image!
                                                  : 'https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg',
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(),
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url, error) =>
                                              CachedNetworkImage(
                                            imageUrl:
                                                AppConfig.defaultNewsImageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16)),
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
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (data.newsTitle.toString())
                                                .sentenceCase,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                              fontFamily: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                              ).fontFamily,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Utils.sizedBoxHeight(8),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Text(
                                                (Utils.parseHtmlString(
                                                        data.newsBody ?? ''))
                                                    .sentenceCase,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.black54,
                                                  height: 1.5,
                                                  fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                  ).fontFamily,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Utils.sizedBoxHeight(8),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 90.w,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(left: 70.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.date_range_outlined,
                                                size: 12,
                                                color: Colors.blueGrey,
                                              ),
                                              Utils.sizedBoxWidth(4),
                                              Text(
                                                data.publishDate != null
                                                    ? data.publishDate!
                                                    : '',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueGrey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const widget_error_404();
                  } else {
                    return const Center(
                      child: CustomLoader(),
                    );
                  }
                })),
      ),
    );
  }

  Future<NewsModel?>? getnews(var id) async {
    var _id = _userDetailsController.schoolId;
    log(InfixApi.getNews(id));
    final response = await http.get(Uri.parse(InfixApi.getNews(_id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return NewsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  _launchCaller(String url) async {
    ;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
