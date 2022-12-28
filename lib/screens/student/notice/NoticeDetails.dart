// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nextschool/config/app_config.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

// Project imports:
import '../../../utils/CustomAppBarWidget.dart';
import '../../../utils/model/Notice.dart';

// ignore: must_be_immutable
class NoticDetailsLayout extends StatefulWidget {
  Notice notice;

  NoticDetailsLayout(this.notice);

  @override
  _NoticDetailsLayoutState createState() => _NoticDetailsLayoutState(notice);
}

class _NoticDetailsLayoutState extends State<NoticDetailsLayout> {
  Notice notice;

  _NoticDetailsLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Notice Details'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.6,
              //       child: Text(
              //         notice.title ?? '',
              //         maxLines: 1,
              //         style: Theme.of(context).textTheme.subtitle1!.copyWith(
              //               fontWeight: FontWeight.w500,
              //               fontSize: ScreenUtil().setSp(19),
              //             ),
              //       ),
              //     ),
              //     Row(
              //       children: [
              //         const Icon(
              //           Icons.calendar_month,
              //           color: Colors.grey,
              //           size: 23,
              //         ),
              //         Text(
              //           notice.publish_on != null && notice.publish_on != ''
              //               ? Utils.dateFormatter(notice.publish_on!)
              //               : '',
              //           maxLines: 1,
              //           style:
              //               Theme.of(context).textTheme.subtitle1!.copyWith(
              //                     color: Colors.black87,
              //                     fontWeight: FontWeight.w300,
              //                     fontSize: ScreenUtil().setSp(13),
              //                   ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ),
            // Utils.sizedBoxHeight(15),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return Utils.documentViewer(
                //       '${AppConfig.domainName}${notice.notice_image}', context);
                // }));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Utils.documentViewer(
                        InfixApi().root + widget.notice.notice_image!, context),
                  ),
                );
              },
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: InfixApi().root + notice.notice_image!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl: AppConfig.defaultNoticeImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
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
            const SizedBox(
              height: 5.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  notice.title ?? '',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(19),
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                    size: 23,
                  ),
                  Text(
                    notice.publish_on != null && notice.publish_on != ''
                        ? notice.publish_on!
                        : '',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w300,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Html(
                data: notice.destails ?? '',
                style: {
                  '*': Style(
                    fontSize: FontSize(ScreenUtil().setSp(14.0)),
                    fontFamily: 'Roboto',
                    color: Colors.black87,
                    lineHeight: LineHeight(ScreenUtil().setSp(1)),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
