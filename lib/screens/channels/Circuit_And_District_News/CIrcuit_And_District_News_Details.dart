import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/config/app_config.dart';
import 'package:nextschool/screens/channels/Circuit_And_District_News/NewsModel.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';
import 'package:video_viewer/video_viewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Project imports:
import '../../../utils/CustomAppBarWidget.dart';

// ignore: must_be_immutable
class CircuitAndDistrictNewsDetailsScreen extends StatefulWidget {
  NewsList newsList;
  int? id;
  String? image;

  CircuitAndDistrictNewsDetailsScreen(this.newsList, this.id, this.image);

  @override
  _CircuitAndDistrictNewsDetailsScreenState createState() =>
      _CircuitAndDistrictNewsDetailsScreenState(newsList);
}

class _CircuitAndDistrictNewsDetailsScreenState
    extends State<CircuitAndDistrictNewsDetailsScreen> {
  NewsList newsList;

  _CircuitAndDistrictNewsDetailsScreenState(this.newsList);

  final VideoViewerController controller = VideoViewerController();

  late YoutubePlayerController _controller;

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(newsList.newsBody);
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Detail News'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                height: 28.h,
                width: 100.w,
                child: CachedNetworkImage(
                  imageUrl: widget.image ?? '',
                  imageBuilder: (context, imageProvider) => GestureDetector(
                    onTap: (() {
                      print(newsList.image!);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Utils.documentViewer(
                            '${InfixApi().root}${newsList.image!}', context);
                      }));
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => GestureDetector(
                    onTap: () {
                      print(newsList.image!);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Utils.documentViewer(
                            '${AppConfig.defaultNewsImageUrl}', context);
                      }));
                    },
                    child: CachedNetworkImage(
                      imageUrl: AppConfig.defaultNewsImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
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
            Container(
              width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 19.0),
                    child: Row(
                      children: [
                        const Text(
                          'Author :',
                          maxLines: 1,
                          style:
                              TextStyle(fontSize: 14, color: Colors.blueGrey),
                        ),
                        Text(
                          newsList.createdBy ?? '',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 19.0),
                    child: Text(
                      newsList.newsTitle.toString().sentenceCase,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: HexColor('#151f3e'),
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 19.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range_outlined,
                          size: 13,
                          color: Colors.black,
                        ),
                        Utils.sizedBoxWidth(4),
                        Text(
                          newsList.publishDate != null
                              ? newsList.publishDate!
                              : '',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Html(
                      data: newsList.newsBody ?? '',
                      style: {
                        '*': Style(
                          fontSize: FontSize(12.sp),
                          color: HexColor('#151f3e'),
                          lineHeight: const LineHeight(2),
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                        //for h1 tag
                        'h1': Style(
                          fontSize: FontSize(18.sp),
                          color: HexColor('#151f3e'),
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ).fontFamily,
                        ),
                        //for h2 tag
                        'h2': Style(
                          fontSize: FontSize(16.sp),
                          color: HexColor('#151f3e'),
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ).fontFamily,
                        ),
                        //for h3 tag
                        'h3': Style(
                          fontSize: FontSize(14.sp),
                          color: HexColor('#151f3e'),
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ).fontFamily,
                        ),
                        //anchor tag
                        'a': Style(
                          fontSize: FontSize(12.sp),
                          color: Colors.blueAccent,
                          fontFamily: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ).fontFamily,
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
            newsList.videoType != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                    ),
                    child: Center(
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: newsList.videoType != 'url'
                                ? VideoViewer(
                                    controller: controller,
                                    source: {
                                      'SubRip Text': VideoSource(
                                        video: VideoPlayerController.network(
                                            'https://vhembewest.co.za/' +
                                                newsList.videoFile!),
                                      )
                                    },
                                    autoPlay: false,
                                  )
                                : YoutubePlayer(
                                    controller: _controller =
                                        YoutubePlayerController(
                                      initialVideoId:
                                          YoutubePlayer.convertUrlToId(
                                              newsList.videoUrl)!,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: false,
                                        mute: false,
                                      ),
                                    ),
                                  ))))
                : Container()
          ],
        ),
      ),
    );
  }
}
